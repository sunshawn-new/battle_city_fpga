`timescale 1ns / 1ps

module bullet_ctrl #(
    parameter N_B       = 4, 
    parameter N_E       = 3, 
    parameter SPEED_DIV = 24'd400_000, 
    parameter COOLDOWN  = 26'd50_000_000,
    parameter ONE_AT_A_TIME = 1, 
    parameter [19:0] DB_MAX = 20'd999_999,
    parameter BW        = 10,    
    parameter BH        = 10,     
    parameter MAP_W     = 120,  
    parameter MAP_H     = 120,
    parameter TILE      = 5
)(
    input               clock,
    input               reset,
    input               fire_btn,
    input               player_alive,  
    input               freeze,     
    input      [9:0]    tank_x,
    input      [9:0]    tank_y,
    input      [1:0]    tank_dir, 
    input      [N_E-1:0]    e_fire,
    input      [N_E*10-1:0] e_x,
    input      [N_E*10-1:0] e_y,
    input      [N_E*2-1:0]  e_dir,
    input      [N_E-1:0]    e_alive,
    output reg          hit_player, 
    output reg [N_E-1:0] hit_enemy, 
    output reg          map_req,
    output              map_we,    
    output reg [14:0]   map_addr,
    output     [3:0]    map_din,    
    input               map_gnt,
    input      [3:0]    map_dout,
    output reg          base_hit,   
    output     [N_B-1:0]    b_valid,
    output     [N_B-1:0]    b_owner,   
    output     [N_B*10-1:0] b_x,
    output     [N_B*10-1:0] b_y,
    output     [N_B*2-1:0]  b_dir
);
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    localparam [23:0] SPD  = SPEED_DIV;
    localparam [25:0] COOL = COOLDOWN;

    function [7:0] div5;
        input [9:0] v;
        reg [17:0] p;
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    // own 记录谁打的
    localparam [2:0] OWN_NONE = 3'd0; 
    reg [N_B-1:0] act;              // 1 = 槽位被占用
    reg [9:0]     x [0:N_B-1];      // 贴图左上角
    reg [9:0]     y [0:N_B-1];
    reg [1:0]     dir [0:N_B-1];  
    reg [2:0]     own [0:N_B-1]; 
    reg [15:0]    last_cell [0:N_B-1]; 

    // 打包给 VGA
    genvar gi;
    generate
        for (gi = 0; gi < N_B; gi = gi + 1) begin : g_pack
            assign b_x[gi*10 +: 10] = x[gi];
            assign b_y[gi*10 +: 10] = y[gi];
            assign b_dir[gi*2 +: 2] = dir[gi];
            assign b_owner[gi]      = (own[gi] != OWN_NONE);
        end
    endgenerate
    assign b_valid = act;

    reg [1:0]  fire_sync = 2'b00;
    reg [19:0] db_cnt    = 20'd0;
    reg        fire_stable = 1'b0;
    reg        fire_prev   = 1'b0;
    // 消抖模块
    always @(posedge clock) begin
        if (reset) begin
            fire_sync   <= 2'b00;
            db_cnt      <= 20'd0;
            fire_stable <= 1'b0;
            fire_prev   <= 1'b0;
        end else begin
            fire_sync <= {fire_sync[0], fire_btn};
            if (fire_sync[1] != fire_stable) begin
                if (db_cnt == DB_MAX) begin      // 稳定了 10ms，才认这个电平
                    fire_stable <= fire_sync[1];
                    db_cnt      <= 20'd0;
                end else begin
                    db_cnt <= db_cnt + 20'd1;
                end
            end else begin
                db_cnt <= 20'd0;                 // 抖动，重新计时
            end
            fire_prev <= fire_stable;
        end
    end

    wire fire_pulse = fire_stable & ~fire_prev;  

    reg [25:0] cool_cnt = 26'd0;
    wire       cool_ready = (cool_cnt == 26'd0);

    // 分配器，取最低位空槽
    wire [N_B-1:0] free_mask = ~act;
    wire           pool_free = |free_mask;
    wire [N_B-1:0] alloc_oh  = free_mask & (~free_mask + {{(N_B-1){1'b0}}, 1'b1});

    reg [7:0] alloc_idx;
    integer a;
    always @(*) begin
        alloc_idx = 8'd0;
        for (a = 0; a < N_B; a = a + 1)
            if (alloc_oh[a]) alloc_idx = a[7:0];
    end

    // 每个发射者的“我已有弹在飞”标志
    reg        busy_p; 
    reg [N_E-1:0] busy_e; 
    integer b;
    always @(*) begin
        busy_p = 1'b0;
        busy_e = {N_E{1'b0}};
        for (b = 0; b < N_B; b = b + 1)
            if (act[b]) begin
                if (own[b] == 3'd0) busy_p = 1'b1;
                else                busy_e[own[b] - 3'd1] = 1'b1;
            end
    end

    // 发射请求仲裁（玩家优先，然后编号小的敌人
    wire player_req = fire_pulse && cool_ready && player_alive &&
                      (!ONE_AT_A_TIME || !busy_p);

    wire [N_E-1:0] enemy_ok;
    genvar ge;
    generate
        for (ge = 0; ge < N_E; ge = ge + 1) begin : g_enemy_req
            assign enemy_ok[ge] = e_alive[ge] && (!ONE_AT_A_TIME || !busy_e[ge]);
        end
    endgenerate
    wire [N_E-1:0] enemy_req = e_fire & enemy_ok;

    reg [2:0] req_owner;                // 组合：本拍想开火的是谁（0 = 玩家，i = 第 i 辆敌人）
    reg       spawn_req;                // 组合：本拍有请求
    reg        spawn   = 1'b0;          // 寄存：这一拍正在入池（上一拍受理的请求）
    reg [2:0]  own_sel = 3'd0;          // 寄存：入池这一发是谁打的
    integer   r;
    always @(*) begin
        spawn_req = 1'b0;
        req_owner = 3'd0;
        if (pool_free && !freeze && !spawn) begin
            if (player_req) begin
                spawn_req = 1'b1;
                req_owner = 3'd0;
            end else begin
                for (r = 0; r < N_E; r = r + 1)
                    if (!spawn_req && enemy_req[r]) begin
                        spawn_req = 1'b1;
                        req_owner = r + 1;
                    end
            end
        end
    end

    // 打一拍，把“谁要开火”锁下来
    always @(posedge clock) begin
        if (reset) begin
            spawn   <= 1'b0;
            own_sel <= 3'd0;
        end else begin
            spawn   <= spawn_req;
            own_sel <= req_owner;
        end
    end

    // 玩家开火冷却（敌人有自己的开火周期，不占这个计数器）
    always @(posedge clock) begin
        if (reset)                            cool_cnt <= 26'd0;
        else if (spawn && own_sel == 3'd0)    cool_cnt <= COOL - 26'd1;
        else if (cool_cnt != 26'd0)           cool_cnt <= cool_cnt - 26'd1;
    end
    // 移动
    reg [23:0] spd_cnt = 24'd0;
    always @(posedge clock) begin
        if (reset)                          spd_cnt <= 24'd0;
        else if (spd_cnt >= SPD - 24'd1)    spd_cnt <= 24'd0;
        else                                spd_cnt <= spd_cnt + 24'd1;
    end
    wire bullet_tick = (spd_cnt == SPD - 24'd1) && !freeze;

    // 判断炮口位置
    wire [N_E-1:0] src_sel = (own_sel == 3'd0) ? {N_E{1'b0}}
                                               : (3'd1 << (own_sel - 3'd1));
    reg [9:0] src_x, src_y;
    reg [1:0] src_d;
    integer si;
    always @(*) begin
        src_x = tank_x;
        src_y = tank_y;
        src_d = tank_dir;
        for (si = 0; si < N_E; si = si + 1)
            if (src_sel[si]) begin
                src_x = e_x[si*10 +: 10];
                src_y = e_y[si*10 +: 10];
                src_d = e_dir[si*2 +: 2];
            end
    end

    reg [9:0] muzzle_x, muzzle_y;
    always @(*) begin
        case (src_d)
            2'b00:   begin muzzle_x = src_x + 10'd5;  muzzle_y = src_y - 10'd10; end 
            2'b01:   begin muzzle_x = src_x + 10'd5;  muzzle_y = src_y + 10'd20; end
            2'b10:   begin muzzle_x = src_x - 10'd10; muzzle_y = src_y + 10'd5;  end
            default: begin muzzle_x = src_x + 10'd20; muzzle_y = src_y + 10'd5;  end 
        endcase
    end

    // 串行引擎同一时刻只处理一个槽，所以这里用 chk_idx 去索引对象池
    reg [7:0]  chk_idx = 8'd0;      // 当前处理的槽
    reg [7:0]  box_cx  = 8'd0;      // 弹体左上角所在格
    reg [7:0]  box_cy  = 8'd0;
    reg [1:0]  box_i   = 2'd0;      // 本轮正在判定弹体的第几格
    // 【决策流水】只依赖坐标的三个标志在 C_CALC 拍一起寄存，
    // C_CMP 拍就只做“几个标志的优先级选择”，不再把坐标比较串进次态译码。
    reg           f_oob   = 1'b0;                  // 出界
    reg           f_hit_p = 1'b0;                  // 打到玩家
    reg [N_E-1:0] f_hit_e = {N_E{1'b0}};           // 打到哪几辆敌人

    wire [9:0] c_x = x[chk_idx];
    wire [9:0] c_y = y[chk_idx];
    wire [1:0] c_d = dir[chk_idx];

    // 出界判定
    localparam [9:0] OOB_X = MAP_W * TILE - BW;   // 590
    localparam [9:0] OOB_Y = MAP_H * TILE - BH;   // 590
    wire box_oob = (c_x > OOB_X) || (c_y > OOB_Y);

    localparam [14:0] ROW_STRIDE = MAP_W;       // 下一行的地址增量 = 120
    wire [7:0]  scn_col  = box_cx + {7'd0, box_i[0]};
    wire [7:0]  scn_row  = box_cy + {7'd0, box_i[1]};
    wire [15:0] scn_base = ({8'd0, scn_row} << 7) - ({8'd0, scn_row} << 3); // row*120
    wire [15:0] scn_sum  = scn_base + {8'd0, scn_col};
    wire [14:0] scn_addr = scn_sum[14:0];

    // 打砖洞：4 格宽 x 2 格深 = 20x10 像素 
    wire        chop_vert   = ~c_d[1];         
    wire [14:0] chop_row    = ({7'd0, box_cy} << 7) - ({7'd0, box_cy} << 3);
    wire [14:0] chop_base_v = chop_row + {7'd0, box_cx} - 15'd1;     
    wire [14:0] chop_base_h = chop_row - ROW_STRIDE + {7'd0, box_cx};

    reg  [14:0] chop_base = 15'd0;  
    reg         chop_v    = 1'b1;  
    reg  [2:0]  chop_i    = 3'd0; 

    // 8 格的地址当场算出来，不做累加
    wire [14:0] chop_addr_nxt = chop_v
        ? (chop_base + {13'd0, chop_i[1:0]} + (chop_i[2] ? ROW_STRIDE : 15'd0))
        : (chop_base + ({8'd0, chop_i[1:0]} << 7) - ({8'd0, chop_i[1:0]} << 3)
                      + (chop_i[2] ? 15'd1 : 15'd0));

    // 一次 bullet_tick 之后把池里所有占用槽扫一遍，只有“弹体压着的 2x2 格”变了才去读地图（4 格串行读，每格 7 拍；没换格就一次都不读）。
    localparam [3:0] C_IDLE  = 4'd0, 
               C_SEL   = 4'd1,
               C_CALC  = 4'd2,
               C_CMP   = 4'd3, 
               C_REQ   = 4'd4, 
               C_WAIT  = 4'd5,
               C_DEC   = 4'd6,  
               C_NEXT  = 4'd7, 
               C_CHOP  = 4'd8,  
               C_CHOPW = 4'd9, 
               C_CHOPD = 4'd10; 

    reg [3:0]  chk_state = C_IDLE;
    reg [2:0]  chk_cnt   = 3'd0;  
    reg        chk_run   = 1'b0;   
    reg        kill_pulse = 1'b0;  
    reg [7:0]  kill_slot  = 8'd0;
    reg        kill2_pulse = 1'b0; 
    reg [7:0]  kill2_slot  = 8'd0;

    // 坦克命中：包围盒重叠
    function overlap_axis;
        input [9:0] b;      // 弹体坐标
        input [9:0] t;      // 坦克坐标
        reg  [11:0] d;
        begin
            d = ({1'b0, b} + 12'd10) - {1'b0, t};
            overlap_axis = (d < 12'd30) && (d != 12'd0);
        end
    endfunction

    function overlap20;
        input [9:0] bx;
        input [9:0] by;
        input [9:0] tx;
        input [9:0] ty;
        begin
            overlap20 = overlap_axis(bx, tx) && overlap_axis(by, ty);
        end
    endfunction

    wire [N_E-1:0] e_box_hit;
    genvar gh;
    generate
        for (gh = 0; gh < N_E; gh = gh + 1) begin : g_box
            wire [9:0] ex = e_x[gh*10 +: 10];
            wire [9:0] ey = e_y[gh*10 +: 10];
            assign e_box_hit[gh] = e_alive[gh] && overlap20(c_x, c_y, ex, ey);
        end
    endgenerate
    wire player_box_hit = player_alive && overlap20(c_x, c_y, tank_x, tank_y);

    // 当前这一发压到谁了（只有玩家弹才看敌人；敌人弹只看玩家）
    wire [N_E-1:0] e_hit_now = (own[chk_idx] == 3'd0) ? e_box_hit : {N_E{1'b0}};
    wire           p_hit_now = (own[chk_idx] != 3'd0) && player_box_hit;

    // 弹对弹：敌我炮弹相撞同归于尽
    function near10;
        input [9:0] a;
        input [9:0] b;
        reg [11:0] t;
        begin
            t = ({1'b0, a} + 12'd10) - {1'b0, b};
            near10 = (t < 12'd20) && (t != 12'd0);
        end
    endfunction

    reg [N_B*N_B-1:0] pair_now = {(N_B*N_B){1'b0}};
    integer pa, pb2;
    always @(posedge clock) begin
        for (pa = 0; pa < N_B; pa = pa + 1)
            for (pb2 = 0; pb2 < N_B; pb2 = pb2 + 1)
                pair_now[pa*N_B + pb2] <= act[pa] && act[pb2] && (pa != pb2) &&
                                          (own[pa] != own[pb2]) &&
                                          near10(x[pa], x[pb2]) &&
                                          near10(y[pa], y[pb2]);
    end

    // 当前扫描的这发，和哪些槽撞上了（变量下标的位选，1 位 N_B 选 1，很浅）
    wire [N_B-1:0] pair_hits = pair_now[chk_idx * N_B +: N_B];

    reg [7:0] pair_slot;
    reg       pair_found;
    integer   pb;
    always @(*) begin
        pair_slot  = 8'd0;
        pair_found = 1'b0;
        for (pb = N_B - 1; pb >= 0; pb = pb - 1)
            if (pair_hits[pb]) begin      // 倒序覆盖 -> 最终留下编号最小的那个
                pair_found = 1'b1;
                pair_slot  = pb[7:0];
            end
    end
    reg        mark_pulse = 1'b0; // 发出脉冲写回last_cell
    reg [7:0]  mark_idx   = 8'd0;
    reg [15:0] mark_cell  = 16'hFFFF;

    wire chop_hit = (chk_state == C_CHOPD) && map_gnt && (map_dout == T_BRICK);
    assign map_we  = chop_hit;
    assign map_din = 4'd0;

    always @(posedge clock) begin
        if (reset) begin
            chk_state  <= C_IDLE;
            chk_idx    <= 8'd0;
            chk_cnt    <= 3'd0;
            box_cx     <= 8'd0;
            box_cy     <= 8'd0;
            box_i      <= 2'd0;
            f_oob      <= 1'b0;
            f_hit_p    <= 1'b0;
            f_hit_e    <= {N_E{1'b0}};
            chk_run    <= 1'b0;
            kill_pulse <= 1'b0;
            kill_slot  <= 8'd0;
            kill2_pulse <= 1'b0;
            kill2_slot  <= 8'd0;
            mark_pulse <= 1'b0;
            mark_idx   <= 8'd0;
            mark_cell  <= 16'hFFFF;
            base_hit   <= 1'b0;
            hit_player <= 1'b0;
            hit_enemy  <= {N_E{1'b0}};
            map_req    <= 1'b0;
            map_addr   <= 15'd0;
            chop_base  <= 15'd0;
            chop_v     <= 1'b1;
            chop_i     <= 3'd0;
        end else begin
            kill_pulse <= 1'b0;                 // 默认都是单拍脉冲
            kill2_pulse <= 1'b0;
            mark_pulse <= 1'b0;
            base_hit   <= 1'b0;
            hit_player <= 1'b0;
            hit_enemy  <= {N_E{1'b0}};

            // 如果不立刻判定，它会在第一次移动后跳过“炮口所在的那一格”，出现“贴着砖块开火却打不穿”的 bug。
            if (spawn || (bullet_tick && (act != {N_B{1'b0}}))) chk_run <= 1'b1;

            case (chk_state)
                C_IDLE: begin
                    if (chk_run) begin
                        chk_idx   <= 8'd0;
                        chk_state <= C_SEL;
                    end
                end
                C_SEL: begin
                    if (!act[chk_idx]) begin
                        if (chk_idx == N_B - 1) begin
                            chk_run   <= 1'b0;
                            chk_state <= C_IDLE;
                        end else begin
                            chk_idx <= chk_idx + 8'd1;
                        end
                    end else begin
                        chk_state <= C_CALC;
                    end
                end
                C_CALC: begin
                    box_cx    <= div5(c_x);
                    box_cy    <= div5(c_y);
                    box_i     <= 2'd0;
                    f_oob     <= box_oob;
                    f_hit_e   <= e_hit_now;
                    f_hit_p   <= p_hit_now;
                    chk_state <= C_CMP;
                end
                C_CMP: begin
                    if (box_i == 2'd0) begin
                        if (pair_found) begin
                            // 敌我炮弹撞在一起
                            kill_pulse  <= 1'b1;
                            kill_slot   <= chk_idx;
                            kill2_pulse <= 1'b1;
                            kill2_slot  <= pair_slot;
                            chk_state   <= C_NEXT;
                        end else if (f_oob) begin
                            // 飞出地图
                            kill_pulse <= 1'b1;
                            kill_slot  <= chk_idx;
                            chk_state  <= C_NEXT;
                        end else if (|f_hit_e || f_hit_p) begin
                            // 打到坦克
                            kill_pulse <= 1'b1;
                            kill_slot  <= chk_idx;
                            hit_enemy  <= f_hit_e;
                            hit_player <= f_hit_p;
                            chk_state  <= C_NEXT;
                        end else if ({box_cx, box_cy} == last_cell[chk_idx]) begin
                            // 弹体压着的还是那 2x2 格，不可能撞到新东西，省掉 4 次地图读
                            chk_state <= C_NEXT;
                        end else begin
                            map_addr  <= scn_addr;
                            map_req   <= 1'b1;
                            chk_cnt   <= 3'd0;
                            chk_state <= C_REQ;
                        end
                    end else begin
                        map_addr  <= scn_addr;      // 同一窗口内换到下一格
                        chk_cnt   <= 3'd0;
                        chk_state <= C_REQ;
                    end
                end
                C_REQ: begin
                    // 地址这一拍已经送出
                    chk_state <= C_WAIT;
                end
                C_WAIT: begin
                    // 等拿到独占窗口后再数 3 拍，保证 douta 是本格的（容忍 0~3 拍延迟）
                    // 【移位寄存器代替计数器】000 → 001 → 011 → 111
                    if (!map_gnt)        chk_cnt <= 3'd0;
                    else if (chk_cnt[2]) chk_state <= C_DEC;
                    else                 chk_cnt <= {chk_cnt[1:0], 1'b1};
                end
                C_DEC: begin
                    if (map_dout == T_BRICK) begin
                        // 打砖
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chop_base  <= chop_vert ? chop_base_v : chop_base_h;
                        chop_v     <= chop_vert;
                        chop_i     <= 3'd0;
                        chk_state  <= C_CHOP;
                    end else if (map_dout == T_BASE) begin
                        // 基地
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        base_hit   <= 1'b1;
                        chk_state  <= C_NEXT;
                    end else if (map_dout != T_EMPTY && map_dout != T_WOODS &&
                                 map_dout != T_RIVER) begin
                        // 钢墙
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chk_state  <= C_NEXT;
                    end else if (box_i == 2'd3) begin
                        mark_pulse <= 1'b1;
                        mark_idx   <= chk_idx;
                        mark_cell  <= {box_cx, box_cy};
                        chk_state  <= C_NEXT;
                    end else begin
                        box_i     <= box_i + 2'd1;
                        chk_state <= C_CMP;
                    end
                end
                C_CHOP: begin
                    // 把洞里的这一格地址送上总线
                    map_addr  <= chop_addr_nxt;
                    chk_cnt   <= 3'd0;
                    chk_state <= C_CHOPW;
                end
                C_CHOPW: begin
                    // 和 C_WAIT 一样：等 douta 稳定（容忍 0~3 拍读延迟）
                    if (!map_gnt)             chk_cnt <= 3'd0;
                    else if (chk_cnt[2])      chk_state <= C_CHOPD;
                    else                      chk_cnt <= {chk_cnt[1:0], 1'b1};
                end
                C_CHOPD: begin
                    // 这一拍 map_dout 就是本格地形；是砖时 map_we 组合拉高（写 0）。
                    // 地址这一拍不能动，否则 0 会写到别的格子上。
                    if (chop_i == 3'd7) begin
                        chk_state <= C_NEXT;             // 8 格（4x2）清完
                    end else begin
                        chop_i    <= chop_i + 3'd1;
                        chk_state <= C_CHOP;
                    end
                end
                default: begin // C_NEXT
                    map_req <= 1'b0;
                    if (chk_idx == N_B - 1) begin
                        chk_run   <= 1'b0;
                        chk_state <= C_IDLE;
                    end else begin
                        chk_idx   <= chk_idx + 8'd1;
                        chk_state <= C_SEL;
                    end
                end
            endcase
        end
    end
    // 对象池更新：移动 / 生成 / 回收
    integer m;
    always @(posedge clock) begin
        if (reset) begin
            act <= {N_B{1'b0}};
            for (m = 0; m < N_B; m = m + 1) begin
                x[m]         <= 10'd0;
                y[m]         <= 10'd0;
                dir[m]       <= 2'b00;
                own[m]       <= 3'd0;
                last_cell[m] <= 16'hFFFF; 
            end
        end else begin
            if (mark_pulse) last_cell[mark_idx] <= mark_cell;
            // 走像素
            if (bullet_tick) begin
                for (m = 0; m < N_B; m = m + 1) begin
                    if (act[m]) begin
                        case (dir[m])
                            2'b00:   y[m] <= y[m] - 10'd1;
                            2'b01:   y[m] <= y[m] + 10'd1;
                            2'b10:   x[m] <= x[m] - 10'd1;
                            default: x[m] <= x[m] + 10'd1;
                        endcase
                    end
                end
            end

            // 生成
            if (spawn) begin
                act[alloc_idx]       <= 1'b1;
                x[alloc_idx]         <= muzzle_x;
                y[alloc_idx]         <= muzzle_y;
                dir[alloc_idx]       <= src_d;
                own[alloc_idx]       <= own_sel;
                last_cell[alloc_idx] <= 16'hFFFF; 
            end

            // 回收
            if (kill_pulse)  act[kill_slot]  <= 1'b0;
            if (kill2_pulse) act[kill2_slot] <= 1'b0; 
        end
    end

endmodule

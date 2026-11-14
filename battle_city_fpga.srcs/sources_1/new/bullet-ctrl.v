`timescale 1ns / 1ps

// ============================================================================
//  bullet_ctrl —— 炮弹的「对象池」控制器
//
//  1) 对象池（Object Pool）
//     和 C 里预先 malloc 一个数组、用 free/used 标记复用是同一个思路，只是
//     在硬件里不能动态分配，所以：
//        · act[i]      : 槽位是否占用（对象池唯一的“位图”）
//        · x/y/dir[i]  : 每个槽的坐标和朝向（SoA，结构体数组的硬件等价物）
//        · free_mask   = ~act
//        · alloc_oh    = free_mask & (~free_mask + 1)   // 取最低位的空槽
//                         ^ 这是“最低位 one-hot”的经典写法，纯组合、1 拍出结果
//        · alloc_idx   : one-hot -> 二进制索引
//     这样“分配”和“回收”都只是置/清一位，没有任何搜索或移位循环。
//     敌方坦克以后可以直接照抄这套 idiom（新建 tank_pool，字段宽度不同，
//     不要硬塞进同一个池 —— 20x20 的坦克和 10x10 的炮弹字段不一样）。
//
//  2) 移动：所有槽并行更新。每个槽在自己的朝向轴上 +1 像素，
//     节拍由 SPEED_DIV 决定（默认 250Hz，是坦克 62.5Hz 的 4 倍）。
//
//  3) 命中判定：串行化（时间复用）+ 网格原生
//     8 个槽各配一个除法器太浪费，所以只做一个“扫描引擎”：每次移动节拍后
//     依次检查每个占用槽，只有“弹体压着的格子组合”变了才去访问地图 BRAM
//     （绝大多数节拍完全不占总线）。
//
//     【按格判定，不是按弹心判定】
//     player.v 保证坦克坐标永远是 TILE=5 的整数倍，炮口坐标因此也是，
//     10x10 的炮弹正好压在 2x2 个格子上（div5 是精确整除）。
//     所以判定 = 「弹体覆盖的 4 格里有任何一格是砖吗」，而不是只看弹头中心
//     那一个像素所在的格。原来的写法只测 1 格，弹体侧面压着砖、中心线却从
//     缺口/缝里过去时，子弹就整条穿过去了（板子上表现为“炮弹穿墙”）。
//        · 砖墙(1)        -> 炮弹消失，并把这 4 格按坦克宽度扩成 4x2 的洞全清掉
//        · 钢/河/基地(2,3,5) -> 炮弹消失（不改地图）
//        · 空/树林(0,4)   -> 穿过去（树林本来就是可穿透的）
//     格子编号复用 div5（乘 205 右移 10），全模块只用 2 个乘法器。
//
//     【洞的形状：4 格宽 x 2 格深 = 20x10 像素 = 正好一个坦克的“截面”】
//     炮口在坦克正中的那条边上，div5(炮口) 正好是“坦克这条边往里第 1 格”：
//        · 竖直飞（上/下）：列 = box_cx-1 .. box_cx+2（= 坦克那 4 列）
//                           行 = box_cy, box_cy+1（= 弹体压的那 2 行）
//        · 水平飞（左/右）：行 = box_cy-1 .. box_cy+2（= 坦克那 4 行）
//                           列 = box_cx, box_cx+1（= 弹体压的那 2 列）
//     洞和坦克的脚下【一格不差】：坦克每发往前推进 2 格（10 像素），
//     不会出现“剩一列砖把坦克卡在洞口进不去”，也不会出现阶梯状缺口。
//     逐格读回来判断，只有砖才写 0（钢墙挡在洞里也不会被误清）。
//
//  4) 共享地图 Port A
//     bullet_ctrl 不直接驱动 ram_addra，而是通过 map_req/map_gnt 向 map_bus
//     申请独占窗口（读-判定-改写都在同一个窗口里完成）。
// ============================================================================
module bullet_ctrl #(
    parameter N_B       = 4,            // 对象池槽位数
    parameter SPEED_DIV = 24'd400_000,  // 250Hz 移动节拍（100MHz / 400000）
    parameter COOLDOWN  = 26'd50_000_000, // 开火冷却 0.5s @100MHz
    parameter ONE_AT_A_TIME = 1,        // 经典规则：同屏只允许 1 发（0 = 不限）
    parameter [19:0] DB_MAX = 20'd999_999, // 开火键消抖时间（10ms @100MHz；仿真里改小）
    parameter BW        = 10,           // 炮弹贴图宽
    parameter BH        = 10,           // 炮弹贴图高
    parameter MAP_W     = 160,
    parameter MAP_H     = 120,
    parameter TILE      = 5
)(
    input               clock,
    input               reset,
    // ---------------- 开火输入（内部同步/消抖/取边沿）----------------
    input               fire_btn,
    // ---------------- 发射者（坦克）的实时状态 ----------------
    input      [9:0]    tank_x,
    input      [9:0]    tank_y,
    input      [1:0]    tank_dir,       // 00 上，01 下，10 左，11 右
    // ---------------- 地图总线（窗口式握手）----------------
    output reg          map_req,
    output              map_we,         // 组合输出：只在“采到砖”的那一拍拉高
    output reg [14:0]   map_addr,
    output     [3:0]    map_din,        // 恒为 0（打砖 = 把这一格写回空地）
    input               map_gnt,
    input      [3:0]    map_dout,
    // ---------------- 渲染侧（对象池打包成扁平向量，方便接口不用 unpacked array）----
    output     [N_B-1:0]    b_valid,
    output     [N_B*10-1:0] b_x,
    output     [N_B*10-1:0] b_y,
    output     [N_B*2-1:0]  b_dir
);
    // 地形编号（和 pysrc/map_generator.py 保持一致）
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    localparam [23:0] SPD  = SPEED_DIV;
    localparam [25:0] COOL = COOLDOWN;

    // 除 5（乘 205 右移 10），对 v <= 1023 恒定精确
    function [7:0] div5;
        input [9:0] v;
        reg [17:0] p;
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    // ---------------- 对象池本体（SoA）----------------
    reg [N_B-1:0] act;              // 1 = 槽位被占用
    reg [9:0]     x [0:N_B-1];      // 贴图左上角
    reg [9:0]     y [0:N_B-1];
    reg [1:0]     dir [0:N_B-1];    // 飞行方向 = 发射时的坦克朝向
    reg [15:0]    last_cell [0:N_B-1]; // {cell_x, cell_y}：上次判定过的前缘格

    // 打包给 VGA（VGA 只需要“每个槽在哪、朝哪、在不在”）
    genvar gi;
    generate
        for (gi = 0; gi < N_B; gi = gi + 1) begin : g_pack
            assign b_x[gi*10 +: 10] = x[gi];
            assign b_y[gi*10 +: 10] = y[gi];
            assign b_dir[gi*2 +: 2] = dir[gi];
        end
    endgenerate
    assign b_valid = act;

    // ================= 开火输入：同步 -> 消抖 -> 取上升沿 =================
    // 按键是异步的机械触点，必须两级同步 + 消抖，否则一次按下会打出好几发。
    // 消抖时间由参数 DB_MAX 给（板上 10ms；仿真里改小以加速）。

    reg [1:0]  fire_sync = 2'b00;
    reg [19:0] db_cnt    = 20'd0;
    reg        fire_stable = 1'b0;
    reg        fire_prev   = 1'b0;

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

    wire fire_pulse = fire_stable & ~fire_prev;   // 按下那一拍（按住不连发）

    // ================= 冷却计时 =================
    reg [25:0] cool_cnt = 26'd0;
    wire       cool_ready = (cool_cnt == 26'd0);

    // ================= 分配器：取最低位的空槽 =================
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

    wire spawn = fire_pulse && cool_ready && pool_free &&
                 (!ONE_AT_A_TIME || (act == {N_B{1'b0}}));

    always @(posedge clock) begin
        if (reset)                       cool_cnt <= 26'd0;
        else if (spawn)                  cool_cnt <= COOL - 26'd1;
        else if (cool_cnt != 26'd0)      cool_cnt <= cool_cnt - 26'd1;
    end

    // ================= 移动节拍（250Hz，坦克的 4 倍）=================
    reg [23:0] spd_cnt = 24'd0;
    always @(posedge clock) begin
        if (reset)                          spd_cnt <= 24'd0;
        else if (spd_cnt >= SPD - 24'd1)    spd_cnt <= 24'd0;
        else                                spd_cnt <= spd_cnt + 24'd1;
    end
    wire bullet_tick = (spd_cnt == SPD - 24'd1);

    // 炮口位置：贴边生成，10x10 的炮弹正好被坦克居中挡在后面
    reg [9:0] muzzle_x, muzzle_y;
    always @(*) begin
        case (tank_dir)
            2'b00:   begin muzzle_x = tank_x + 10'd5;  muzzle_y = tank_y - 10'd10; end // 向上：坦克上边
            2'b01:   begin muzzle_x = tank_x + 10'd5;  muzzle_y = tank_y + 10'd20; end // 向下：坦克下边
            2'b10:   begin muzzle_x = tank_x - 10'd10; muzzle_y = tank_y + 10'd5;  end // 向左：坦克左边
            default: begin muzzle_x = tank_x + 10'd20; muzzle_y = tank_y + 10'd5;  end // 向右：坦克右边
        endcase
    end
    // ================= 弹体覆盖的 2x2 格（网格原生）=================
    // 串行引擎同一时刻只处理一个槽，所以这里用 chk_idx 去索引对象池：
    // 综合出来是 4 选 1 的 mux，只占一份逻辑、一份乘法器。
    reg [7:0]  chk_idx = 8'd0;      // 当前处理的槽（扫描引擎的“游标”）
    reg [7:0]  box_cx  = 8'd0;      // 弹体左上角所在格（列）
    reg [7:0]  box_cy  = 8'd0;      // 弹体左上角所在格（行）
    reg [1:0]  box_i   = 2'd0;      // 本轮正在判定弹体的第几格（0..3）

    wire [9:0] c_x = x[chk_idx];
    wire [9:0] c_y = y[chk_idx];
    wire [1:0] c_d = dir[chk_idx];

    // 出界判定：坐标是 10 位的，向上/向左走出地图会回绕成很大的值，
    // 右上/右下也要判（贴图原点 + 10 像素超出地图就回收）。
    wire box_oob = (c_x >= MAP_W * TILE) || (c_y >= MAP_H * TILE) ||
                   ((c_x + BW) > MAP_W * TILE) || ((c_y + BH) > MAP_H * TILE);

    // 弹体覆盖的 2x2 格：{box_cx, box_cx+1} x {box_cy, box_cy+1}
    //   box_i[0] = 列偏移，box_i[1] = 行偏移
    wire [7:0]  scn_col  = box_cx + {7'd0, box_i[0]};
    wire [7:0]  scn_row  = box_cy + {7'd0, box_i[1]};
    wire [15:0] scn_base = ({8'd0, scn_row} << 7) + ({8'd0, scn_row} << 5); // row*160
    wire [15:0] scn_sum  = scn_base + {8'd0, scn_col};
    wire [14:0] scn_addr = scn_sum[14:0];

    // ================= 打砖洞：4 格宽 x 2 格深 = 20x10 像素 =================
    // 竖直飞（上/下）：列 box_cx-1 .. box_cx+2（4 列 = 坦克宽），行 box_cy, box_cy+1
    // 水平飞（左/右）：行 box_cy-1 .. box_cy+2（4 行 = 坦克高），列 box_cx, box_cx+1
    // 炮口在坦克正中的那条边上，div5(炮口) 正好是“坦克这条边往里第 1 格”，
    // 所以上面的 -1 之后正好从坦克这条边的第一格开始 —— 洞和坦克脚下一格不差。
    //   _v / _h 是两种形状的基址，C_DEC 里按飞行方向锁存（之后再算 8 个格的地址）。
    // 可达情况下不会下溢：竖直时 box_cx >= 1（炮口 x = 坦克 x + 5），
    // 水平时 box_cy >= 1（炮口 y = 坦克 y + 5）；越界由 box_oob 提前回收。
    wire        chop_vert   = ~c_d[1];                                       // 上下 = 1
    wire [14:0] chop_row    = ({7'd0, box_cy} << 7) + ({7'd0, box_cy} << 5); // box_cy * 160
    wire [14:0] chop_base_v = chop_row + {7'd0, box_cx} - 15'd1;             // 行 box_cy，列 box_cx-1 起
    wire [14:0] chop_base_h = chop_row - 15'd160 + {7'd0, box_cx};           // 行 box_cy-1，列 box_cx 起

    reg  [14:0] chop_base = 15'd0;  // C_DEC 锁存：之后 c_d/x/y 可能被新炮弹覆盖
    reg         chop_v    = 1'b1;   // C_DEC 锁存：1 = 竖直飞的形状（4 列 x 2 行）
    reg  [2:0]  chop_i    = 3'd0;   // 条带内第几格（0..7）

    // 8 格的地址当场算出来，不做累加（累加一旦跑飞会写到别的格子上）：
    //   竖直：i[1:0] 选列（0..3），i[2] 选行（0..1）  -> +列 +行*160
    //   水平：i[1:0] 选行（0..3），i[2] 选列（0..1）  -> +行*160 +列
    wire [14:0] chop_addr_nxt = chop_v
        ? (chop_base + {13'd0, chop_i[1:0]} + (chop_i[2] ? 15'd160 : 15'd0))
        : (chop_base + ({8'd0, chop_i[1:0]} << 7) + ({8'd0, chop_i[1:0]} << 5)
                      + (chop_i[2] ? 15'd1 : 15'd0));

    // ================= 串行命中判定引擎 =================
    // 一次 bullet_tick 之后把池里所有占用槽扫一遍，只有“弹体压着的 2x2 格”变了
    // 才去读地图（4 格串行读，每格 7 拍；没换格就一次都不读）。
    localparam [3:0] C_IDLE  = 4'd0,   // 等一次扫描触发
               C_SEL   = 4'd1,   // 找下一个占用槽（空槽直接跳过）
               C_CALC  = 4'd2,   // 弹体左上角除 5 得到格子坐标（2 个乘法器）
               C_CMP   = 4'd3,   // 出界？和上次的格子比，没变就不用读地图
               C_REQ   = 4'd4,   // 申请总线并发地址
               C_WAIT  = 4'd5,   // 等授权，再等 4 拍让 douta 稳定
               C_DEC   = 4'd6,   // 采样地形，决定：穿过 / 消失 / 打砖
               C_NEXT  = 4'd7,   // 收尾：撤销 req、换下一个槽
               C_CHOP  = 4'd8,   // 打砖：把洞里这一格的地址送上总线
               C_CHOPW = 4'd9,   // 打砖：等 douta 稳定（同 C_WAIT）
               C_CHOPD = 4'd10;  // 打砖：采 douta，是砖就写 0

    reg [3:0]  chk_state = C_IDLE;
    reg [2:0]  chk_cnt   = 3'd0;    // C_WAIT / C_CHOPW 的等待计数
    reg        chk_run   = 1'b0;    // 本轮扫描请求
    reg        kill_pulse = 1'b0;   // 单拍：回收 kill_slot 这个槽
    reg [7:0]  kill_slot  = 8'd0;
    // 判定结果要写回 last_cell[]，但 last_cell 已经在下面的对象池 always 块里
    // 被 reset / spawn 写过。同一个 reg 数组不能有两个 always 驱动（综合会报
    // multi-driven，硬件上直接丢掉一路），所以这里只发一个单拍脉冲，
    // 由对象池那块统一落盘（和 kill_pulse 一个套路）。
    reg        mark_pulse = 1'b0;
    reg [7:0]  mark_idx   = 8'd0;
    reg [15:0] mark_cell  = 16'hFFFF;

    // 写使能做成“组合”输出：C_CHOPD 那一拍 map_addr 还停在被打的那一格上，
    // 而寄存器输出要晚一拍才生效 —— 那样 0 就会被写到下一格去。
    // map_gnt 也一起与进来：没拿到窗口时总线不属于炮弹，不能写。
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
            chk_run    <= 1'b0;
            kill_pulse <= 1'b0;
            kill_slot  <= 8'd0;
            mark_pulse <= 1'b0;
            mark_idx   <= 8'd0;
            mark_cell  <= 16'hFFFF;
            map_req    <= 1'b0;
            map_addr   <= 15'd0;
            chop_base  <= 15'd0;
            chop_v     <= 1'b1;
            chop_i     <= 3'd0;
        end else begin
            kill_pulse <= 1'b0;                 // 默认是单拍脉冲
            mark_pulse <= 1'b0;

            // 每个移动节拍（并且池里还有炮弹）触发一轮扫描；
            // 生成的那一拍也必须马上扫一次：炮弹出生时可能已经贴在墙/砖里，
            // 如果不立刻判定，它会在第一次移动后跳过“炮口所在的那一格”，
            // 出现“贴着砖块开火却打不穿”的 bug。
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
                        // 空槽：直接跳过；走到池尾就结束本轮
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
                    // 弹体左上角所在的格（坐标是 5 的倍数，div5 是精确整除）
                    box_cx    <= div5(c_x);
                    box_cy    <= div5(c_y);
                    box_i     <= 2'd0;
                    chk_state <= C_CMP;
                end
                C_CMP: begin
                    // 每一格都从这儿发地址（窗口从头到尾不撒手，只换地址）
                    if (box_i == 2'd0) begin
                        if (box_oob) begin
                            // 飞出地图：回收，不占用地图总线
                            kill_pulse <= 1'b1;
                            kill_slot  <= chk_idx;
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
                    // 地址这一拍已经送出（寄存器输出，地址路径很短）
                    chk_state <= C_WAIT;
                end
                C_WAIT: begin
                    // 等拿到独占窗口后再数 4 拍，保证 douta 是本格的（容忍 0~3 拍延迟）
                    if (!map_gnt)          chk_cnt <= 3'd0;
                    else if (chk_cnt == 3'd3) chk_state <= C_DEC;
                    else                   chk_cnt <= chk_cnt + 3'd1;
                end
                C_DEC: begin
                    if (map_dout == T_BRICK) begin
                        // 打砖：炮弹消失，并在同一个总线窗口里把 4x2 = 20x10 的洞全清掉
                        // （判定的这 4 格本身就在洞里，不用在这里单独写）
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chop_base  <= chop_vert ? chop_base_v : chop_base_h;
                        chop_v     <= chop_vert;
                        chop_i     <= 3'd0;
                        chk_state  <= C_CHOP;
                    end else if (map_dout != T_EMPTY && map_dout != T_WOODS) begin
                        // 钢墙 / 河流 / 基地：炮弹消失，地图不变
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chk_state  <= C_NEXT;
                    end else if (box_i == 2'd3) begin
                        // 2x2 全是空地/树林：记下这一组格子，下次弹体没换格就跳过
                        mark_pulse <= 1'b1;
                        mark_idx   <= chk_idx;
                        mark_cell  <= {box_cx, box_cy};
                        chk_state  <= C_NEXT;
                    end else begin
                        box_i     <= box_i + 2'd1;   // 换弹体压着的下一格
                        chk_state <= C_CMP;
                    end
                end
                C_CHOP: begin
                    // 把洞里的这一格地址送上总线（窗口已经拿到，req 保持不变）
                    map_addr  <= chop_addr_nxt;
                    chk_cnt   <= 3'd0;
                    chk_state <= C_CHOPW;
                end
                C_CHOPW: begin
                    // 和 C_WAIT 一样：等 douta 稳定（容忍 0~3 拍读延迟）
                    if (!map_gnt)             chk_cnt <= 3'd0;
                    else if (chk_cnt == 3'd3) chk_state <= C_CHOPD;
                    else                      chk_cnt <= chk_cnt + 3'd1;
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
    // ================= 对象池更新：移动 / 生成 / 回收 =================
    // 三个动作放在同一个 always 块里，避免同一个数组被多个 always 驱动
    // （Verilog 里 act[0] 和 act[1] 属于同一个 reg，分开写会报多驱动）。
    integer m;
    always @(posedge clock) begin
        if (reset) begin
            act <= {N_B{1'b0}};
            for (m = 0; m < N_B; m = m + 1) begin
                x[m]         <= 10'd0;
                y[m]         <= 10'd0;
                dir[m]       <= 2'b00;
                last_cell[m] <= 16'hFFFF;     // 不合法的“上次格子”，保证首拍必查
            end
        end else begin
            // 0) 落盘“已经判定过的格子”（扫描引擎发来的单拍脉冲）
            if (mark_pulse) last_cell[mark_idx] <= mark_cell;

            // 1) 移动：所有占用槽并行沿自己的朝向走 1 像素
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

            // 2) 生成：写在移动之后，优先级更高（新炮弹当拍不移动）
            if (spawn) begin
                act[alloc_idx]       <= 1'b1;
                x[alloc_idx]         <= muzzle_x;
                y[alloc_idx]         <= muzzle_y;
                dir[alloc_idx]       <= tank_dir;
                last_cell[alloc_idx] <= 16'hFFFF;  // 下一拍强制做一次命中判定
            end

            // 3) 回收：撞墙 / 打掉砖 / 飞出地图
            if (kill_pulse) act[kill_slot] <= 1'b0;
        end
    end

endmodule

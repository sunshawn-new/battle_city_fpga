`timescale 1ns / 1ps

module enemy_ctrl #(
    parameter N_E        = 3, 
    parameter WIDTH      = 600,
    parameter HEIGHT     = 600,
    parameter TILE       = 5, 
    parameter MOVE_DIV   = 8_000_000, 
    parameter TURN_TICKS = 24,           // 每多少个移动节拍重新选一次向
    parameter FIRE_TICKS = 4             // 开火周期基准
)(
    input clock,
    input reset,

    input  [N_E-1:0]   spawn,
    input  [N_E*2-1:0] spawn_type,

    input      [N_E*4-1:0]  terrain_front,
    input      [N_E-1:0]    terrain_valid, 
    output     [N_E-1:0]    move_tick, 

    input      [9:0]        p_x,
    input      [9:0]        p_y,

    input      [N_E-1:0]    e_hit,
    input                   freeze, 
    output     [N_E-1:0]    e_fire,
    output     [N_E-1:0]    e_kill,
    output     [N_E-1:0]    e_valid, 
    output     [N_E*10-1:0] e_x,
    output     [N_E*10-1:0] e_y,
    output     [N_E*2-1:0]  e_dir,
    output     [N_E*2-1:0]  e_type 
);
    localparam T_EMPTY = 4'd0,
               T_WOODS = 4'd4;
    localparam [9:0] TGT_X = 10'd300,
                     TGT_Y = 10'd590;
    localparam [1:0] D_UP    = 2'b00,
                     D_DOWN  = 2'b01,
                     D_LEFT  = 2'b10,
                     D_RIGHT = 2'b11;
    localparam [7:0] SLIDE_TICKS = 8'd3; // 脱困后滑3格确保离开死胡同，向敌方基地进发

    localparam [1:0] T_FAST  = 2'd0,
                     T_POWER = 2'd1,
                     T_ARMOR = 2'd2;

    localparam TANK_W = 20; 
    localparam TANK_H = 20;
    localparam [9:0] X_MAX = WIDTH  - TANK_W;     // 780：车身右边缘刚好贴住画面
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;     // 580

    wire [N_E-1:0] tick_all;
    assign move_tick = tick_all;

    // 坦克互斥用的全场车辆坐标
    wire [N_E*10-1:0] en_all_x, en_all_y;
    wire [N_E-1:0]    en_all_v;

    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_enemy
            localparam [9:0] SPAWN_X = (gi == 0) ? 10'd40 :
                                       (gi == 1) ? 10'd300 : 10'd560; // 有三个出生点
            localparam [9:0] SPAWN_Y = 10'd0;
            localparam [1:0] SPAWN_D = 2'b01;                 // 朝下

            localparam [1:0] DEF_TYPE = (gi == 0) ? T_FAST : // 初始兵种
                                        (gi == 1) ? T_POWER : T_ARMOR;

            wire [1:0]  ntype   = spawn_type[gi*2 +: 2];
            wire [23:0] n_step  = (ntype == T_FAST)  ? (MOVE_DIV >> 1) :
                                  (ntype == T_POWER) ? MOVE_DIV :
                                                       (MOVE_DIV + (MOVE_DIV >> 1));
            wire [3:0]  n_fire  = (ntype == T_FAST)  ? (FIRE_TICKS + 4'd2) :
                                  (ntype == T_POWER) ? FIRE_TICKS :
                                                       (FIRE_TICKS * 4'd2);
            wire [1:0]  n_hp    = (ntype == T_ARMOR) ? 2'd2 : 2'd1;

            // 相位错开避免同一时刻抢同一条地图总线
            localparam [7:0] PHASE = gi * 8;

            wire [3:0] front    = terrain_front[gi*4 +: 4];
            wire       passable = (front == T_EMPTY) || (front == T_WOODS);

            reg [9:0]  x, y;
            reg [1:0]  dir;
            reg        alive;
            reg [23:0] cnt;
            reg [7:0]  turn_cnt;
            reg [3:0]  fire_cnt;
            reg [1:0]  rot;           // 撞墙后的旋转相位
            reg [1:0]  slide_save;    // 滑行中"瞄一眼基地"时记住的滑行方向（瞄不过去就退回它）
            reg [1:0]  hp;
            reg [1:0]  my_type;
            reg [23:0] step;
            reg [3:0]  fire_period;   // 本槽当前的开火周期（自己的节拍数）
            reg [1:0]  hp_max;
            reg        fire_req;
            reg        kill_req;
            // 判断基地方向
            wire        tgt_right   = (x < TGT_X);
            wire        tgt_down    = (y < TGT_Y);
            wire [9:0]  dist_x      = tgt_right ? (TGT_X - x) : (x - TGT_X);
            wire [9:0]  dist_y      = tgt_down  ? (TGT_Y - y) : (y - TGT_Y);

            reg         hf_q;                               // 1 = 当前先走横向
            wire        hf_next = hf_q ? (dist_x > 10'd10)
                                       : ((dist_y <= 10'd10) ? (dist_x > 10'd10)
                                                             : (dist_x > dist_y));
            wire        horiz_first = hf_q;
            wire [1:0]  want_h      = tgt_right ? D_RIGHT : D_LEFT;
            wire [1:0]  want_v      = tgt_down  ? D_DOWN : D_UP;
            wire [1:0]  want_dir    = horiz_first ? want_h : want_v;

            wire        attack      = (dist_x <= 10'd60) && (dist_y <= 10'd60);

            localparam [N_E:0] OWN_MASK = ({{N_E{1'b0}}, 1'b1} << (gi + 1));
            wire [9:0] cand_x = (dir == D_LEFT)  ? (x - TILE) :
                                (dir == D_RIGHT) ? (x + TILE) : x;
            wire [9:0] cand_y = (dir == D_UP)    ? (y - TILE) :
                                (dir == D_DOWN)  ? (y + TILE) : y;
            wire [N_E:0]      blk_v = {en_all_v, 1'b1} & ~OWN_MASK;   // 第 0 位 = 玩家
            wire [N_E*10+9:0] blk_x = {en_all_x, p_x};
            wire [N_E*10+9:0] blk_y = {en_all_y, p_y};
            wire              cand_blocked;

            tank_block #(.N(N_E + 1)) u_blk (
                .cx(cand_x), .cy(cand_y),
                .o_valid(blk_v), .o_x(blk_x), .o_y(blk_y),
                .blocked(cand_blocked)
            );

            wire wall_ahead = terrain_valid[gi] && !passable;   // 前面是砖/钢/河/基地
            wire can_go     = terrain_valid[gi] && passable && !cand_blocked;

            wire tick = (cnt >= step - 24'd1);
            // 对tick寄存一拍
            reg tick_q;
            always @(posedge clock) begin
                if (reset || spawn[gi]) tick_q <= 1'b0;
                else                    tick_q <= tick;
            end
            assign tick_all[gi] = tick_q;

            // 下一拍(tick_q)怎么走在 tick 拍全部算好并寄存起来
            reg        d_terrain_ok;
            reg        d_can_go;  
            reg        d_wall_ahead; 
            reg        d_attack;  
            reg        d_turn_over; 
            reg        d_hf_next;  
            reg [1:0]  d_want_dir;  

            always @(posedge clock) begin
                if (reset || spawn[gi]) begin
                    d_terrain_ok <= 1'b0;
                    d_can_go     <= 1'b0;
                    d_wall_ahead <= 1'b0;
                    d_attack     <= 1'b0;
                    d_turn_over  <= 1'b0;
                    d_hf_next    <= 1'b0;
                    d_want_dir   <= 2'b00;
                end else if (tick) begin
                    d_terrain_ok <= terrain_valid[gi];
                    d_can_go     <= can_go;
                    d_wall_ahead <= wall_ahead;
                    d_attack     <= attack;
                    d_turn_over  <= (turn_cnt >= TURN_TICKS - 1);
                    d_hf_next    <= hf_next;
                    d_want_dir   <= want_dir;
                end
            end

            assign e_valid[gi]       = alive;
            assign e_x[gi*10 +: 10]  = x;
            assign e_y[gi*10 +: 10]  = y;
            assign e_dir[gi*2  +: 2] = dir;
            assign e_type[gi*2 +: 2] = my_type;
            assign e_fire[gi]        = fire_req;
            assign e_kill[gi]        = kill_req;
            assign en_all_x[gi*10 +: 10] = x;
            assign en_all_y[gi*10 +: 10] = y;
            assign en_all_v[gi]          = alive;

            initial begin
                x           = SPAWN_X;
                y           = SPAWN_Y;
                dir         = SPAWN_D;
                alive       = 1'b0;
                cnt         = PHASE;
                turn_cnt    = 8'd0;
                fire_cnt    = 4'd0;
                rot         = 2'd0;
                slide_save  = SPAWN_D;
                hf_q        = 1'b0;      // 先走纵向（出生点在屏幕顶端，基地在下面）
                hp          = 2'd1;
                my_type     = DEF_TYPE;
                step        = MOVE_DIV;
                fire_period = FIRE_TICKS;
                hp_max      = 2'd1;
                fire_req    = 1'b0;
                kill_req    = 1'b0;
            end
            always @(posedge clock) begin
                if (reset) begin
                    x           <= SPAWN_X;
                    y           <= SPAWN_Y;
                    dir         <= SPAWN_D;
                    alive       <= 1'b0;
                    cnt         <= PHASE;
                    turn_cnt    <= 8'd0;
                    fire_cnt    <= 4'd0;
                    rot         <= 2'd0;
                    slide_save  <= SPAWN_D;
                    hf_q        <= 1'b0;
                    hp          <= 2'd1;
                    my_type     <= DEF_TYPE;
                    step        <= MOVE_DIV;
                    fire_period <= FIRE_TICKS;
                    hp_max      <= 2'd1;
                    fire_req    <= 1'b0;
                    kill_req    <= 1'b0;
                end else if (spawn[gi]) begin
                    x           <= SPAWN_X;
                    y           <= SPAWN_Y;
                    dir         <= SPAWN_D;
                    alive       <= 1'b1;
                    cnt         <= PHASE;
                    turn_cnt    <= 8'd0;
                    fire_cnt    <= 4'd0;
                    rot         <= 2'd0;
                    slide_save  <= SPAWN_D;
                    hf_q        <= 1'b0;                // 新车重新从“先纵向”开始
                    my_type     <= ntype;
                    step        <= n_step;
                    fire_period <= n_fire;
                    hp_max      <= n_hp;
                    hp          <= n_hp;
                    fire_req    <= 1'b0;
                    kill_req    <= 1'b0;
                end else begin
                    fire_req <= 1'b0;      // 两个都是单拍脉冲
                    kill_req <= 1'b0;

                    if (e_hit[gi] && alive && !freeze) begin
                        if (hp > 2'd1) begin
                            hp <= hp - 2'd1;
                        end else begin
                            hp       <= 2'd0;
                            alive    <= 1'b0;
                            kill_req <= 1'b1;
                        end
                    end

                    if (tick) cnt <= 24'd0;
                    else      cnt <= cnt + 24'd1;

                    if (tick_q && alive && !freeze) begin
                        if (fire_cnt >= fire_period - 4'd1) begin
                            fire_cnt <= 4'd0;
                            fire_req <= 1'b1;
                        end else begin
                            fire_cnt <= fire_cnt + 4'd1;
                        end

                        if (d_turn_over) turn_cnt <= 8'd0;
                        else             turn_cnt <= turn_cnt + 8'd1;

                        // 下面所有“怎么走”的判断都用 tick 拍寄存好的决策
                        if (!d_terrain_ok) begin
                            // 刚出生 / 刚转向：新朝向上的地形结果还没回来，本拍不动
                        end else if (d_can_go) begin
                            // 前面能走
                            case (dir)
                                2'b00:   if (y != 10'd0)          y <= y - TILE;  
                                2'b01:   if ((y + TILE) <= Y_MAX) y <= y + TILE;
                                2'b10:   if (x != 10'd0)          x <= x - TILE; 
                                default: if ((x + TILE) <= X_MAX) x <= x + TILE;
                            endcase
                            if (dir == d_want_dir) begin
                                rot        <= 2'd0;
                                slide_save <= d_want_dir; 
                            end
                            hf_q <= d_hf_next;
                            // 到点重瞄基地
                            if (d_turn_over) begin
                                if (dir != d_want_dir) slide_save <= dir;
                                dir <= d_want_dir; 
                            end
                        end else if (d_attack && d_wall_ahead) begin
                            // 贴到基地跟前直接顶着墙打
                            dir        <= d_want_dir;
                            rot        <= 2'd0;
                            slide_save <= d_want_dir;
                            turn_cnt   <= 8'd0;
                            fire_req <= 1'b1;
                            fire_cnt <= 4'd0;
                            hf_q     <= d_hf_next;
                        end else if (dir == d_want_dir && slide_save != d_want_dir) begin
                            dir        <= slide_save;
                            slide_save <= d_want_dir;   // 失效
                            rot        <= 2'd0;
                            turn_cnt   <= TURN_TICKS - SLIDE_TICKS;
                            hf_q       <= d_hf_next;
                        end else begin
                            // 前面是墙或者别的坦克，循环转动
                            case (rot)
                                2'd0:    dir <= d_want_dir;
                                2'd1:    dir <= rot_cw(d_want_dir);
                                2'd2:    dir <= rot_cw(d_want_dir) ^ 2'b01;
                                default: dir <= d_want_dir ^ 2'b01;
                            endcase
                            rot <= rot + 2'd1;
                            // 脱困后每滑 SLIDE_TICKS 格就朝基地瞄一次
                            turn_cnt <= TURN_TICKS - SLIDE_TICKS;
                            hf_q     <= d_hf_next;
                        end
                    end
                end
            end
        end
    endgenerate

    function [1:0] rot_cw; // 顺时针转90°
        input [1:0] d;
        begin
            case (d)
                2'b00:   rot_cw = 2'b11;  // 上 -> 右
                2'b01:   rot_cw = 2'b10;  // 下 -> 左
                2'b10:   rot_cw = 2'b00;  // 左 -> 上
                default: rot_cw = 2'b01;  // 右 -> 下
            endcase
        end
    endfunction

endmodule

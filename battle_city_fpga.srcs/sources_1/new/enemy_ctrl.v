`timescale 1ns / 1ps

// ============================================================================
//  enemy_ctrl —— 敌方坦克的运动 / 转向
//
//  【和 player.v 共用同一条不变量】每个移动节拍走整整一格（TILE = 5 像素），
//  所以坐标永远是 TILE 的整数倍、20x20 的车身永远精确压在自己那 4x4 格上。
//  这样前方地形查询就能直接复用 terrain_probe（每辆车一个实例），以后
//  “坦克互斥 / 炮弹打坦克 / 敌人被击毁”也都能用格点和包围盒来算，
//  不会出现“半格卡住”“偏心命中”这类麻烦。
//
//  速度：MOVE_DIV 决定节拍（top 里给玩家的 2 倍 -> 12.5Hz，比玩家慢一半）。
//  几辆车的计数器初值错开（PHASE），不会同手同脚一起走。
//
//  AI（刻意做得很简单，够演示、不会失控）：
//    1. 前面能走（空地 / 树林）就沿当前朝向走一格；
//    2. 前面是墙（砖 / 钢 / 河 / 基地 / 地图外框）就原地转 90°，
//       左转还是右转由 16 位 LFSR 决定 —— 避免在墙角来回抖；
//    3. 每隔 TURN_TICKS 个节拍，如果 LFSR 某一位是 1 就随机转 90°，
//       让它在空地上也会拐弯，看起来像在“巡逻”而不是一条直线机器人。
//
//  为什么用 generate 展开、而不像炮弹那样做串行引擎：
//    每辆车只有一套 20 位左右的状态（x/y/dir/计数器/LFSR），逻辑量很小，
//    展开后天然并行、每拍都能更新；串行化反而要排队，把逻辑搞复杂。
//
//  朝向编码和 player / bullet / vga 完全一致：00 上，01 下，10 左，11 右。
// ============================================================================
module enemy_ctrl #(
    parameter N_E        = 3,            // 敌方坦克辆数（VGA 的 N_E 必须一致）
    parameter WIDTH      = 800,
    parameter HEIGHT     = 600,
    parameter TILE       = 5,            // 一格 5 像素（和 player.v / map.coe 一致）
    parameter MOVE_DIV   = 8_000_000,    // 12.5Hz：100M / MOVE_DIV 拍/秒
    parameter TURN_TICKS = 24            // 每多少个移动节拍随机换一次向
)(
    input clock,
    input reset,

    // ---------------- 每辆车的“前方地形”（各接一个 terrain_probe 实例）----------------
    input      [N_E*4-1:0]  terrain_front,   // 第 i 辆占 terrain_front[i*4 +: 4]
    input      [N_E-1:0]    terrain_valid,   // 结果可信（查询条件 == 当前 x/y/dir）
    output     [N_E-1:0]    move_tick,       // 每辆车自己的节拍，接各自 probe 的 refresh

    // ---------------- 打包给 VGA（扁平打包，避免 unpacked array 端口）----------------
    output     [N_E-1:0]    e_valid,         // 1 = 这辆车还在（以后被击毁就清 0）
    output     [N_E*10-1:0] e_x,
    output     [N_E*10-1:0] e_y,
    output     [N_E*2-1:0]  e_dir
);
    // 地形编号（和 pysrc/map_generator.py / player.v / terrain_probe.v 一致）
    localparam T_EMPTY = 4'd0,
               T_WOODS = 4'd4;

    localparam [23:0] STEP = MOVE_DIV;

    localparam TANK_W = 20;                       // 敌人和玩家一样是 20x20
    localparam TANK_H = 20;
    localparam [9:0] X_MAX = WIDTH  - TANK_W;     // 780：车身右边缘刚好贴住画面
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;     // 580

    // 每辆车自己的移动节拍（同一条线上的第 gi 位）
    wire [N_E-1:0] tick_all;
    assign move_tick = tick_all;

    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_enemy
            // ---------------- 出生点 / 初始朝向 ----------------
            // 都在真实地图第 2~5 行（那里是空地），朝下开；x 是 5 的倍数，
            // 20x20 的车身压在自己那 4 列上，不会碰到外墙（列 0 / 列 159）。
            //   (40,10)  列 8~11    左边，往下会撞到河（行 60 起，列 20~69）
            //   (380,10) 列 76~79   中间，正对着桥（河的缺口 = 列 70~90）
            //   (740,10) 列 148~151 右边，一路向下能绕过河（河只到列 139）
            // N_E 超过 3 辆时，多出来的都按右边那个点出生（以后做波次再改）。
            localparam [9:0] SPAWN_X = (gi == 0) ? 10'd40 :
                                       (gi == 1) ? 10'd380 : 10'd740;
            localparam [9:0] SPAWN_Y = 10'd10;
            localparam [1:0] SPAWN_D = 2'b01;                 // 朝下
            // 相位错开：第一次节拍发生在 STEP-PHASE 拍之后，所以 PHASE 要取小值
            // （<= STEP-150）：复位后先留 ~150 拍让 4 个 terrain_probe 各扫一遍，
            // 再让几辆车错开 1/4N 个节拍开始走，避免同一时刻抢同一条地图总线。
            localparam [23:0] PHASE  = (STEP / (4 * N_E)) * gi;

            wire [3:0] front    = terrain_front[gi*4 +: 4];
            wire       passable = (front == T_EMPTY) || (front == T_WOODS);

            reg [9:0]  x, y;
            reg [1:0]  dir;
            reg        alive;
            reg [23:0] cnt;
            reg [15:0] rnd;
            reg [7:0]  turn_cnt;

            wire tick = (cnt == STEP - 24'd1);
            assign tick_all[gi] = tick;

            assign e_valid[gi]       = alive;
            assign e_x[gi*10 +: 10]  = x;
            assign e_y[gi*10 +: 10]  = y;
            assign e_dir[gi*2  +: 2] = dir;

            // 上电初值（Vivado 会写进触发器的 INIT 属性，xsim 里同样生效）：
            // 即使板上的 reset 没正常触发，敌人也会出现在出生点而不是 (0,0)。
            initial begin
                x        = SPAWN_X;
                y        = SPAWN_Y;
                dir      = SPAWN_D;
                alive    = 1'b1;
                cnt      = PHASE;
                rnd      = 16'h1ACE + gi[15:0];
                turn_cnt = 8'd0;
            end

            always @(posedge clock) begin
                if (reset) begin
                    x        <= SPAWN_X;
                    y        <= SPAWN_Y;
                    dir      <= SPAWN_D;
                    alive    <= 1'b1;
                    cnt      <= PHASE;
                    rnd      <= 16'h1ACE + gi[15:0];
                    turn_cnt <= 8'd0;
                end else begin
                    // 16 位 LFSR（x^16 + x^14 + x^13 + x^11 + 1，最大长度序列）。
                    // 每拍走一步，换向时取里面不同的低位：不可预测但完全可复现。
                    rnd <= {rnd[14:0], rnd[15] ^ rnd[13] ^ rnd[12] ^ rnd[10]};

                    if (tick) cnt <= 24'd0;
                    else      cnt <= cnt + 24'd1;

                    if (tick && alive) begin
                        // 巡逻计时：到点后由 LFSR 决定要不要拐一下
                        if (turn_cnt >= TURN_TICKS - 1) turn_cnt <= 8'd0;
                        else                            turn_cnt <= turn_cnt + 8'd1;

                        if (!terrain_valid[gi]) begin
                            // 刚出生 / 刚转向：新朝向上的地形结果还没回来，本拍不动
                            // （probe 扫一遍约 30 拍，只耽误不到一个节拍，看不出来）
                        end else if (passable) begin
                            // 前面能走：沿当前朝向走一整格（TILE 像素）
                            case (dir)
                                2'b00:   if (y != 10'd0)          y <= y - TILE;  // 上
                                2'b01:   if ((y + TILE) <= Y_MAX) y <= y + TILE; // 下
                                2'b10:   if (x != 10'd0)          x <= x - TILE;  // 左
                                default: if ((x + TILE) <= X_MAX) x <= x + TILE; // 右
                            endcase
                            // 巡逻：这一格照走，同时随机换个朝向（下一拍 probe 重新扫描）
                            if (turn_cnt >= TURN_TICKS - 1 && rnd[3])
                                dir <= dir ^ 2'b10;
                        end else begin
                            // 前面是墙：转 90°（左/右由 LFSR 决定）。
                            // 2'b10 / 2'b11 都是“垂直转向”，交替着来就不会在墙角来回抖；
                            // 另外 1/4 概率直接掉头 —— 掉头的方向刚走过、一定通，
                            // 这是“贴着墙角出不来”的保底出口（比如一直沿着右墙上下滑）。
                            dir <= dir ^ ((rnd[1:0] == 2'b00) ? 2'b01
                                                              : (rnd[0] ? 2'b10 : 2'b11));
                        end
                    end
                end
            end
        end
    endgenerate

endmodule

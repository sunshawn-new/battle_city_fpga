`timescale 1ns / 1ps

// ============================================================================
//  player —— 玩家坦克的运动 / 碰撞
//
//  【重要不变量】坦克每次移动固定走一整格（TILE = 5 像素），不是走 1 像素。
//  于是 position_x / position_y 永远是 TILE 的整数倍，20x20 的坦克永远精确
//  压在自己那 4x4 个格子上，炮口坐标也永远落在格边界上。
//  炮弹系统（bullet-ctrl.v）就是靠这个不变量把 10x10 的炮弹映射到 2x2 格上、
//  并把打出的洞和坦克的脚下一格不差地对齐 —— 不要再改回“1 像素”移动，
//  否则又会出现“偏心命中 / 阶梯状缺口 / 打完砖坦克挤不进去”。
//
//  速度 = TILE * 100MHz / MOVE_DIV
//    MOVE_DIV = 4_000_000 -> 25 拍/秒 -> 125 像素/秒（6.25 个车身/秒）
// ============================================================================
module player #(
    WIDTH=600,
    HEIGHT=600,
    TILE = 5,             // 一格 5 像素（和 map.coe / vga.v 一致）
    MOVE_DIV = 4_000_000, // 移动节拍分频：100M / MOVE_DIV 拍/秒，每拍走 TILE 像素
                          // 综合默认 4_000_000；仿真里由 testbench 改小以加速
    // 出生点（像素）。必须和 map_generator.py 的 PLAYER_SPAWN 一致：
    //   基地左边一格、和基地底边对齐 —— 原版 Battle City 1P 的出车位置。
    //   20x20 的车放在 (200,560) 时正好占 block 40..43 x 112..115，
    //   下方/左右都是空地，老鹰在它右边 2 格的 (260..339, 520..599)。
    SPAWN_X = 200,
    SPAWN_Y = 560,
    // 参与“坦克互斥”的别的车数量（top 里接的是 N_ENEMY 辆敌方坦克）
    N_BLK = 3
)(
    input clock,
    input reset,
    input up_enable,
    input down_enable,
    input left_enable,
    input right_enable,
    input [3:0] terrain_in_front, // 前方地形（top 中多格查询后取“最硬”的一个）
    input       terrain_valid,    // 前方地形查询完成（BRAM 有 1 拍读延迟）
    // ---------------- 坦克互斥 ----------------
    // 别的车（= 敌方坦克）的包围盒。判定在 tank_block.v 里做，这里只负责
    // “这一格有车就不许进”。没有这一层时两辆车会叠在一起（穿模）。
    input [N_BLK-1:0]    blk_valid,
    input [N_BLK*10-1:0] blk_x,
    input [N_BLK*10-1:0] blk_y,
    input       respawn,          // 单拍：回到出生点（被炮弹打中后由 top 发）
    input       freeze,           // 1 = 冻结（GAME OVER 后玩家不能再动）
    output reg [9:0] position_x,
    output reg [9:0] position_y,
    output          move_tick     // 移动节拍（板上每 40ms 一拍），top 用它定期刷新地形查询
);
    localparam HALFW = WIDTH / 2;
    localparam HALFH = HEIGHT / 2;
    localparam TANK_W = 20;      // 坦克 20x20 像素（= 4x4 格）
    localparam TANK_H = 20;
    // 出生点的 10 位常量（position_x/position_y 是 10 位寄存器）
    localparam [9:0] SP_X = SPAWN_X;
    localparam [9:0] SP_Y = SPAWN_Y;

    // 位置上限（都是 TILE 的整数倍，坦克边缘刚好贴住画面边界）
    localparam [9:0] X_MAX = WIDTH  - TANK_W;   // 780
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;   // 580

    // 地形编号：0 空地，1 砖墙，2 钢墙，3 河流，4 树林，5 基地
    localparam T_EMPTY = 4'd0;
    localparam T_WOODS = 4'd4;

    // 建议：直接加按键消抖模块（这里简写，假设外部输入已消抖）

    // ---------------- 坦克互斥：四个方向各判一次 ----------------
    // 候选位置 = 当前位置往前一格（-TILE / +TILE）。车身 20x20、坐标永远是 5 的
    // 倍数，所以“和别的车重叠”就是“|dx|<20 且 |dy|<20”（见 tank_block.v）。
    // 注意“上”在 y=0 时 position_y - TILE 会回绕成一个很大的数：那一支本来就
    // 被 position_y != 0 挡着，回绕值不可能撞上任何一辆车（坐标都 < 600）。
    wire blk_up, blk_dn, blk_lf, blk_rt;

    tank_block #(.N(N_BLK)) u_blk_up (
        .cx(position_x), .cy(position_y - TILE),
        .o_valid(blk_valid), .o_x(blk_x), .o_y(blk_y), .blocked(blk_up)
    );
    tank_block #(.N(N_BLK)) u_blk_dn (
        .cx(position_x), .cy(position_y + TILE),
        .o_valid(blk_valid), .o_x(blk_x), .o_y(blk_y), .blocked(blk_dn)
    );
    tank_block #(.N(N_BLK)) u_blk_lf (
        .cx(position_x - TILE), .cy(position_y),
        .o_valid(blk_valid), .o_x(blk_x), .o_y(blk_y), .blocked(blk_lf)
    );
    tank_block #(.N(N_BLK)) u_blk_rt (
        .cx(position_x + TILE), .cy(position_y),
        .o_valid(blk_valid), .o_x(blk_x), .o_y(blk_y), .blocked(blk_rt)
    );

    reg [23:0] cnt;
    // 每 MOVE_DIV 拍一个移动节拍，每个节拍走 TILE 像素
    // （板上 4_000_000 -> 25Hz -> 125 像素/秒；仿真里由 testbench 改小以加速）
    wire move_tick_c = (cnt == MOVE_DIV - 1);

    // ---------------- 移动决策流水（时序修复）----------------
    // position_y/position_x -> 候选坐标(±TILE) -> 4 路 tank_block 比较 ->
    // 边界判定 -> D 输入 原来是一条 12 级的组合链（时序报告 WNS -0.40 的
    // 主要来源），而且 Vivado 还会把 probe 的 div5 乘法锥和它合并共享，
    // 路由也一起变长。玩家每 40ms 才动一步：把“能不能走”在 move_tick_c 拍
    // 全部算好寄存，move_tick_q 拍只做“按按钮方向落子”的短路径。
    reg move_tick_q;
    reg d_pass;                                  // 前方可通行（空地/树林）且地形查询可信
    reg d_blk_up, d_blk_dn, d_blk_lf, d_blk_rt;  // 四个候选位上有没有别的车
    assign move_tick = move_tick_q;

    // 上电初值（Vivado 会把这些值写进触发器的 INIT 属性，xsim 里同样生效）。
    // 这样即使板上的 reset 引脚没有正常触发，坦克也会停在出生点而不是 (0,0)。
    initial begin
        cnt        = 24'd0;
        position_x = SP_X;
        position_y = SP_Y;
    end

    always @(posedge clock) begin
        if (reset) begin
            cnt <= 24'd0;
        end else if (move_tick_c) begin
            cnt <= 24'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    // 决策锁存 + 节拍寄存。respawn 拍清掉：复活和节拍同时发生时，
    // 不能拿“复活前”的旧决策在出生点上多走一格。
    always @(posedge clock) begin
        if (reset || respawn) begin
            move_tick_q <= 1'b0;
            d_pass      <= 1'b0;
            d_blk_up    <= 1'b1;
            d_blk_dn    <= 1'b1;
            d_blk_lf    <= 1'b1;
            d_blk_rt    <= 1'b1;
        end else begin
            move_tick_q <= move_tick_c;
            if (move_tick_c) begin
                d_pass <= terrain_valid &&
                          (terrain_in_front == T_EMPTY || terrain_in_front == T_WOODS);
                d_blk_up <= blk_up;
                d_blk_dn <= blk_dn;
                d_blk_lf <= blk_lf;
                d_blk_rt <= blk_rt;
            end
        end
    end

    always @(posedge clock) begin
        if (reset) begin
            position_x <= SP_X;
            position_y <= SP_Y;
        end else if (respawn) begin
            // 被炮弹打中后回到出生点（top 同时会给一段无敌时间，避免刚复活又挨打）
            position_x <= SP_X;
            position_y <= SP_Y;
        end else if (move_tick_q && !freeze) begin
            // 只有前方地形是空地(0)或树林(4)才能前进；
            // terrain_in_front 已经包含了坦克整个前边缘接触到的所有格子
            // （terrain_probe 把这条边上的 4 格全部查一遍、取“最硬”的一个）。
            // 每次移动走整整一格 TILE，保证坐标始终是 TILE 的整数倍。
            // 另外每个方向还要过一遍“坦克互斥”：那一格上站着别的车就不许进
            // （没有这一条时两辆车会互相穿过 / 叠在同一格里）。
            if (d_pass) begin
                if (up_enable && position_y != 10'd0 && !d_blk_up)
                    position_y <= position_y - TILE;
                else if (down_enable && (position_y + TILE) <= Y_MAX && !d_blk_dn)
                    position_y <= position_y + TILE;
                else if (left_enable && position_x != 10'd0 && !d_blk_lf)
                    position_x <= position_x - TILE;
                else if (right_enable && (position_x + TILE) <= X_MAX && !d_blk_rt)
                    position_x <= position_x + TILE;
            end
        end
    end

endmodule


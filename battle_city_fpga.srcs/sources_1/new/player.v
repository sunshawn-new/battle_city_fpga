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
    WIDTH=800,
    HEIGHT=600,
    TILE = 5,             // 一格 5 像素（和 map.coe / vga.v 一致）
    MOVE_DIV = 4_000_000  // 移动节拍分频：100M / MOVE_DIV 拍/秒，每拍走 TILE 像素
                          // 综合默认 4_000_000；仿真里由 testbench 改小以加速
)(
    input clock,
    input reset,
    input up_enable,
    input down_enable,
    input left_enable,
    input right_enable,
    input [3:0] terrain_in_front, // 前方地形（top 中多格查询后取“最硬”的一个）
    input       terrain_valid,    // 前方地形查询完成（BRAM 有 1 拍读延迟）
    output reg [9:0] position_x,
    output reg [9:0] position_y,
    output          move_tick     // 移动节拍（板上每 40ms 一拍），top 用它定期刷新地形查询
);
    localparam HALFW = WIDTH / 2;
    localparam HALFH = HEIGHT / 2;
    localparam TANK_W = 20;      // 坦克 20x20 像素（= 4x4 格）
    localparam TANK_H = 20;

    // 位置上限（都是 TILE 的整数倍，坦克边缘刚好贴住画面边界）
    localparam [9:0] X_MAX = WIDTH  - TANK_W;   // 780
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;   // 580

    // 地形编号：0 空地，1 砖墙，2 钢墙，3 河流，4 树林，5 基地
    localparam T_EMPTY = 4'd0;
    localparam T_WOODS = 4'd4;

    // 建议：直接加按键消抖模块（这里简写，假设外部输入已消抖）

    reg [23:0] cnt;
    // 每 MOVE_DIV 拍一个移动节拍，每个节拍走 TILE 像素
    // （板上 4_000_000 -> 25Hz -> 125 像素/秒；仿真里由 testbench 改小以加速）
    assign move_tick = (cnt == MOVE_DIV - 1);

    // 上电初值（Vivado 会把这些值写进触发器的 INIT 属性，xsim 里同样生效）。
    // 这样即使板上的 reset 引脚没有正常触发，坦克也会停在屏幕中央而不是 (0,0)。
    // 400 / 300 都是 5 的倍数，满足“坐标永远是 TILE 整数倍”的不变量。
    initial begin
        cnt        = 24'd0;
        position_x = HALFW;
        position_y = HALFH;
    end

    always @(posedge clock) begin
        if (reset) begin
            cnt <= 24'd0;
        end else if (move_tick) begin
            cnt <= 24'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge clock) begin
        if (reset) begin
            position_x <= HALFW;
            position_y <= HALFH;
        end else if (move_tick && terrain_valid) begin
            // 只有前方地形是空地(0)或树林(4)才能前进；
            // terrain_in_front 已经包含了坦克整个前边缘接触到的所有格子
            // （terrain_probe 把这条边上的 4 格全部查一遍、取“最硬”的一个）。
            // 每次移动走整整一格 TILE，保证坐标始终是 TILE 的整数倍。
            if (terrain_in_front == T_EMPTY || terrain_in_front == T_WOODS) begin
                if (up_enable && position_y != 10'd0)
                    position_y <= position_y - TILE;
                else if (down_enable && (position_y + TILE) <= Y_MAX)
                    position_y <= position_y + TILE;
                else if (left_enable && position_x != 10'd0)
                    position_x <= position_x - TILE;
                else if (right_enable && (position_x + TILE) <= X_MAX)
                    position_x <= position_x + TILE;
            end
        end
    end

endmodule


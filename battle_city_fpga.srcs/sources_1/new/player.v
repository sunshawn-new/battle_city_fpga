`timescale 1ns / 1ps

module player #(
    WIDTH=800,
    HEIGHT=600,
    MOVE_DIV = 400_000    // 移动节拍分频：100M / MOVE_DIV = 每拍走 1 像素
                          // 综合默认 400_000（250Hz）；仿真里由 testbench 改小以加速
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
    output          move_tick     // 移动节拍（每 4ms 一拍），top 用它定期刷新地形查询
);
    localparam HALFW = WIDTH / 2;
    localparam HALFH = HEIGHT / 2;
    localparam TANK_W = 20;      // 坦克 20x20 像素
    localparam TANK_H = 20;

    // 地形编号：0 空地，1 砖墙，2 钢墙，3 河流，4 树林，5 基地
    localparam T_EMPTY = 4'd0;
    localparam T_WOODS = 4'd4;

    // 建议：直接加按键消抖模块（这里简写，假设外部输入已消抖）

    reg [23:0] cnt;
    assign move_tick = (cnt == MOVE_DIV - 1); // 100M / 400 000 = 250Hz，即每 4ms 走 1 像素

    // 上电初值（Vivado 会把这些值写进触发器的 INIT 属性，xsim 里同样生效）。
    // 这样即使板上的 reset 引脚没有正常触发，坦克也会停在屏幕中央而不是 (0,0)。
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
        end else if (move_tick && terrain_valid) begin // 每 4ms 移动一次
            // 只有前方地形是空地(0)或树林(4)才能前进；
            // terrain_in_front 已经包含了坦克整个前边缘接触到的所有格子
            if (terrain_in_front == T_EMPTY || terrain_in_front == T_WOODS) begin
                if (up_enable && position_y > 0)
                    position_y <= position_y - 10'd1;
                else if (down_enable && position_y < HEIGHT - TANK_H)
                    position_y <= position_y + 10'd1;
                else if (left_enable && position_x > 0)
                    position_x <= position_x - 10'd1;
                else if (right_enable && position_x < WIDTH - TANK_W)
                    position_x <= position_x + 10'd1;
            end
        end
    end

endmodule


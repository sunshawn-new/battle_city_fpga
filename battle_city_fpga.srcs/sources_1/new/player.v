`timescale 1ns / 1ps

module player #(
    WIDTH=800,
    HEIGHT=600
)(
    input clock,
    input reset,
    input up_enable,
    input down_enable,
    input left_enable,
    input right_enable,
    output reg [9:0] position_x,
    output reg [9:0] position_y
);
    localparam HALFW = WIDTH / 2;
    localparam HALFH = HEIGHT / 2;

    // 建议：直接加按键消抖模块（这里简写，假设外部输入已消抖）
    
    reg [23:0] cnt;
    wire tick_10hz = (cnt == 24'd399_999); // 100M / 250Hz = 400 000

    always @(posedge clock) begin
        if (reset) begin
            cnt <= 24'd0;
        end else if (tick_10hz) begin
            cnt <= 24'd0;
        end else begin
            cnt <= cnt + 1'b1;
        end
    end

    always @(posedge clock) begin
        if (reset) begin
            position_x <= HALFW;
            position_y <= HALFH;
        end else if (tick_10hz) begin // 每 4ms移动一次
            // 边界判断 + 修正 Y 轴方向
            if (up_enable && position_y > 0) 
                position_y <= position_y - 10'd1;
            else if (down_enable && position_y < HEIGHT - 21) 
                position_y <= position_y + 10'd1;
            else if (left_enable && position_x > 0) 
                position_x <= position_x - 10'd1;
            else if (right_enable && position_x < WIDTH - 21) 
                position_x <= position_x + 10'd1;
        end
    end
endmodule


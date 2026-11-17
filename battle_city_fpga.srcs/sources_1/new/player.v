`timescale 1ns / 1ps
module player #(
    WIDTH=600,
    HEIGHT=600,
    TILE = 5, 
    MOVE_DIV = 4_000_000, 
    SPAWN_X = 200,
    SPAWN_Y = 560,
    N_BLK = 3
)(
    input clock,
    input reset,
    input up_enable,
    input down_enable,
    input left_enable,
    input right_enable,
    input [3:0] terrain_in_front,
    input       terrain_valid,
    input [N_BLK-1:0]    blk_valid, // 坦克互斥 
    input [N_BLK*10-1:0] blk_x,
    input [N_BLK*10-1:0] blk_y,
    input       respawn,
    input       freeze,
    output reg [9:0] position_x,
    output reg [9:0] position_y,
    output          move_tick
);
    localparam HALFW = WIDTH / 2;
    localparam HALFH = HEIGHT / 2;
    localparam TANK_W = 20;
    localparam TANK_H = 20;
    localparam [9:0] SP_X = SPAWN_X;
    localparam [9:0] SP_Y = SPAWN_Y;

    localparam [9:0] X_MAX = WIDTH  - TANK_W;   // 780
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;   // 580

    localparam T_EMPTY = 4'd0;
    localparam T_WOODS = 4'd4;

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
    wire move_tick_c = (cnt == MOVE_DIV - 1);

    reg move_tick_q;
    reg d_pass;                                  
    reg d_blk_up, d_blk_dn, d_blk_lf, d_blk_rt; 
    assign move_tick = move_tick_q;

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
            position_x <= SP_X;
            position_y <= SP_Y;
        end else if (move_tick_q && !freeze) begin
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


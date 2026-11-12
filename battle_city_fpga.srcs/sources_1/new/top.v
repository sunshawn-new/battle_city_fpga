`timescale 1ns / 1ps

module top(
    input clock,       // 100MHz
    input reset,
    input btn_up, btn_down, btn_left, btn_right,
    output [11:0] disp_RGB,
    output hsync,
    output vsync
);
    wire [9:0] tank_x, tank_y;

    player u_player(
        .clock(clock), .reset(reset),
        .up_enable(btn_up), .down_enable(btn_down),
        .left_enable(btn_left), .right_enable(btn_right),
        .position_x(tank_x), .position_y(tank_y)
    );

    wire [14:0] vga_map_addr;
    wire [3:0]  vga_tile_id;
    wire vga_clk;

    reg [1:0] player_direction = 2'b00; // 00上，01下，10左，11右
    always @(posedge clock) begin
        if(btn_up) player_direction = 2'b00;
        else if(btn_down) player_direction=2'b01;
        else if(btn_left) player_direction=2'b10;
        else if(btn_right) player_direction=2'b11;
        else player_direction=player_direction;
    end

    vga u_vga(
        .clock(clock), .reset(reset),
        .position_x(tank_x), .position_y(tank_y),
        .map_addr(vga_map_addr),
        .tile_id(vga_tile_id),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync),
        .vga_clk(vga_clk),
        .player_direction(player_direction)
    );

    // Port A: 留给子弹写 (现在暂时接 0)
    // Port B: 供 VGA 读
    wire wea = 1'b0;
    wire [14:0] addra = 15'd0;
    wire [3:0] dina = 4'd0;

    blk_mem_gen_0 u_map_ram (
        // Port A (写)
        .clka(clock),
        .wea(wea),
        .addra(addra),
        .dina(dina),
        // Port B (读)
        .clkb(vga_clk),
        .addrb(vga_map_addr),
        .doutb(vga_tile_id)
    );

endmodule
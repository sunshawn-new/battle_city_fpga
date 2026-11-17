`timescale 1ns / 1ps
module terrain_probe #(
    parameter MAP_W  = 120, 
    parameter MAP_H  = 120, 
    parameter TILE   = 5, 
    parameter TANK_W = 20, 
    parameter TANK_H = 20  
)(
    input             clock,
    input             reset,
    input      [9:0]  x,
    input      [9:0]  y,
    input      [1:0]  dir, 
    input             refresh,     
    output            map_req, 
    output     [14:0] map_addr,
    input             map_gnt,
    input      [3:0]  map_dout,
    output     [3:0]  terrain,
    output            valid  
);
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    localparam S_IDLE = 2'd0,
               S_GEOM = 2'd1,
               S_SCAN = 2'd2;   

    reg [1:0]  scan_state = S_IDLE;
    reg [2:0]  scan_phase = 3'd0; 
    reg [2:0]  scan_cell  = 3'd0; 
    reg [3:0]  scan_worst = 4'd0; 
    reg [9:0]  snap_x = 10'd0, snap_y = 10'd0; 
    reg [1:0]  snap_dir = 2'b00;             
    reg [3:0]  front_terrain = 4'd0;        
    reg        front_valid   = 1'b0;       

    reg [7:0] g_tx_first = 8'd0, g_tx_last = 8'd0; 
    reg [7:0] g_ty_first = 8'd0, g_ty_last = 8'd0;
    reg [7:0] g_front_up = 8'd0, g_front_down = 8'd0;
    reg [7:0] g_front_left = 8'd0, g_front_right = 8'd0;
    reg [14:0] scan_addr_r = 15'd0;              

    assign map_req  = (scan_state != S_IDLE);
    assign map_addr = scan_addr_r;
    wire query_changed = (x != snap_x) || (y != snap_y) || (dir != snap_dir);
    wire edge_blocked =
        (snap_dir == 2'b00) && (snap_y == 10'd0) ||
        (snap_dir == 2'b01) && (snap_y + TANK_H >= MAP_H * TILE) ||
        (snap_dir == 2'b10) && (snap_x == 10'd0) ||
        (snap_dir == 2'b11) && (snap_x + TANK_W >= MAP_W * TILE);

    assign terrain = front_terrain;
    assign valid   = front_valid && !query_changed;

    wire [7:0] cell_idx = {5'd0, scan_cell};
    wire [7:0] scan_col_i = (g_tx_first + cell_idx > g_tx_last) ? g_tx_last
                                                                : g_tx_first + cell_idx;
    wire [7:0] scan_row_i = (g_ty_first + cell_idx > g_ty_last) ? g_ty_last
                                                                : g_ty_first + cell_idx;

    reg [7:0] scan_row, scan_col;
    always @(*) begin
        case (snap_dir)
            2'b00: begin scan_row = g_front_up;    scan_col = scan_col_i;     end
            2'b01: begin scan_row = g_front_down;  scan_col = scan_col_i;     end
            2'b10: begin scan_row = scan_row_i;    scan_col = g_front_left;   end
            default: begin scan_row = scan_row_i;  scan_col = g_front_right;  end
        endcase
    end

    wire [15:0] scan_row_base = ({8'd0, scan_row} << 7) - ({8'd0, scan_row} << 3);
    wire [15:0] scan_addr     = scan_row_base + {8'd0, scan_col};
    function [7:0] div5;
        input [9:0] v;  
        reg [17:0] p; 
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    localparam [7:0] COL_LAST = (TANK_W - 1) / TILE;   // 右边缘相对列偏移 = 3
    localparam [7:0] ROW_LAST = (TANK_H - 1) / TILE;   // 下边缘相对行偏移 = 3
    localparam [7:0] COL_NEXT = TANK_W / TILE;         // 前进方向多探一格 = 4
    localparam [7:0] ROW_NEXT = TANK_H / TILE;

    wire [7:0] col0 = div5(x); 
    wire [7:0] row0 = div5(y); 

`ifndef SYNTHESIS
    always @(posedge clock)
        if (!reset && (((x % TILE) != 0) || ((y % TILE) != 0)))
            $display("[terrain_probe] ERROR: x=%0d y=%0d 不是 TILE=%0d 的整数倍", x, y, TILE);
`endif

    function [3:0] merge_terrain;
        input [3:0] a;
        input [3:0] b;
        begin
            if      (a == T_BRICK || a == T_STEEL || a == T_RIVER || a == T_BASE)
                merge_terrain = a;
            else if (b == T_BRICK || b == T_STEEL || b == T_RIVER || b == T_BASE)
                merge_terrain = b;
            else if (a == T_WOODS || b == T_WOODS)
                merge_terrain = T_WOODS;
            else
                merge_terrain = T_EMPTY;
        end
    endfunction
    always @(posedge clock) begin
        if (reset) begin
            scan_state    <= S_IDLE;
            scan_phase    <= 3'd0;
            scan_cell     <= 3'd0;
            scan_worst    <= 4'd0;
            snap_x        <= 10'd0;
            snap_y        <= 10'd0;
            snap_dir      <= 2'b00;
            g_tx_first    <= 8'd0;
            g_tx_last     <= 8'd0;
            g_ty_first    <= 8'd0;
            g_ty_last     <= 8'd0;
            g_front_up    <= 8'd0;
            g_front_down  <= 8'd0;
            g_front_left  <= 8'd0;
            g_front_right <= 8'd0;
            scan_addr_r   <= 15'd0;
            front_terrain <= 4'd0;
            front_valid   <= 1'b0;
        end else case (scan_state)
            S_IDLE: begin
                // 结果还没有 / 位置或朝向变了 / 到了移动节拍
                if (!front_valid || query_changed || refresh) begin
                    snap_x     <= x;
                    snap_y     <= y;
                    snap_dir   <= dir;
                    scan_cell  <= 3'd0;
                    scan_worst <= 4'd0;
                    scan_phase <= 3'd0;
                    scan_state <= S_GEOM;
                    // 只有“查询条件真的变了”才把旧结果作废；定时刷新时保留旧结果，这样本拍的移动不会被拖住
                    if (query_changed) front_valid <= 1'b0;
                end
            end
            S_GEOM: begin
                if (map_gnt) begin
                    g_tx_first <= col0;  
                    g_tx_last  <= col0 + COL_LAST;  
                    g_ty_first <= row0;        
                    g_ty_last  <= row0 + ROW_LAST; 
                    // 前进方向上“新进入”的那一行/列
                    g_front_up    <= (y == 10'd0) ? 8'd0
                                   : (row0 - 8'd1);
                    g_front_down  <= (y + TANK_H >= MAP_H * TILE) ? (MAP_H - 1)
                                   : (row0 + ROW_NEXT);
                    g_front_left  <= (x == 10'd0) ? 8'd0
                                   : (col0 - 8'd1);
                    g_front_right <= (x + TANK_W >= MAP_W * TILE) ? (MAP_W - 1)
                                   : (col0 + COL_NEXT);
                    scan_phase <= 3'd0;
                    scan_state <= S_SCAN;
                end
            end
            default: begin 
                if (scan_phase != 3'd4) begin
                    // 每格第 0 拍把这一格的地址锁进 scan_addr_r（下一拍起 BRAM 就读它）
                    if (scan_phase == 3'd0) scan_addr_r <= scan_addr[14:0];
                    scan_phase <= scan_phase + 3'd1;   // 地址保持 5 拍，等 BRAM 读稳
                end else if (scan_cell == 3'd4) begin
                    // 5 个格子查完（第 5 格可能和第 4 格重复，读到同一个值无害）
                    front_terrain <= edge_blocked ? T_BRICK
                                                  : merge_terrain(scan_worst, map_dout);
                    front_valid   <= 1'b1;
                    scan_state    <= S_IDLE;
                    scan_phase    <= 3'd0;
                end else begin
                    scan_worst <= merge_terrain(scan_worst, map_dout);
                    scan_cell  <= scan_cell + 3'd1;
                    scan_phase <= 3'd0;
                end
            end
        endcase
    end
endmodule

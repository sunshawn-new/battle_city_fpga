`timescale 1ns / 1ps
(* use_dsp = "no" *) // dsp造成过一次时序违例
module tank_block #(
    parameter N      = 3, 
    parameter TANK_W = 20, 
    parameter TANK_H = 20,
    parameter TILE   = 5 
)(
    input  [9:0]      cx,      // 本车想去的左上角
    input  [9:0]      cy,
    input  [N-1:0]    o_valid, // 第 i 辆“别的车”当前是否在场
    input  [N*10-1:0] o_x,     // 第 i 辆占 o_x[i*10 +: 10]
    input  [N*10-1:0] o_y,
    output            blocked  // 1重叠
);
    localparam [10:0] W11 = TANK_W;
    localparam [10:0] H11 = TANK_H;

    function integer flog2;
        input integer v;
        integer i;
        begin
            flog2 = 0;
            for (i = 0; i < 31; i = i + 1)
                if ((1 << i) <= v) flog2 = i;
        end
    endfunction

    localparam HI      = flog2(TANK_W);                  //  4
    localparam [10:0] THR = 11'd1 << HI;                 // 16
    localparam USE_BIT = (TANK_W % TILE == 0) && (THR > (TANK_W - TILE));

    wire [N-1:0] hit;

    genvar gi;
    generate
        if (USE_BIT) begin : g_fast
            for (gi = 0; gi < N; gi = gi + 1) begin : g_cmp
                wire [9:0]  ox = o_x[gi*10 +: 10];
                wire [9:0]  oy = o_y[gi*10 +: 10];
                wire [10:0] dx = (cx > ox) ? ({1'b0, cx} - {1'b0, ox})
                                           : ({1'b0, ox} - {1'b0, cx});
                wire [10:0] dy = (cy > oy) ? ({1'b0, cy} - {1'b0, oy})
                                           : ({1'b0, oy} - {1'b0, cy});
                // 高位全 0 = 距离 < 16 = 距离 < 20（只可能是 0/5/10/15）
                assign hit[gi] = o_valid[gi] &&
                                 (dx[10:HI] == {(11-HI){1'b0}}) &&
                                 (dy[10:HI] == {(11-HI){1'b0}});
            end
        end else begin : g_cmp_generic
            for (gi = 0; gi < N; gi = gi + 1) begin : g_cmp
                wire [9:0]  ox = o_x[gi*10 +: 10];
                wire [9:0]  oy = o_y[gi*10 +: 10];
                wire [10:0] dx = (cx > ox) ? ({1'b0, cx} - {1'b0, ox})
                                           : ({1'b0, ox} - {1'b0, cx});
                wire [10:0] dy = (cy > oy) ? ({1'b0, cy} - {1'b0, oy})
                                           : ({1'b0, oy} - {1'b0, cy});
                assign hit[gi] = o_valid[gi] && (dx < W11) && (dy < H11);
            end
        end
    endgenerate

    assign blocked = |hit;

endmodule

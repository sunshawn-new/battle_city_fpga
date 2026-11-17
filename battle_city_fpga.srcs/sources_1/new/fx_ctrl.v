`timescale 1ns / 1ps

module fx_ctrl #(
    parameter N_FX      = 4,      
    parameter N_E       = 3,        
    parameter FX_DIV    = 8_000_000,  
    parameter FX_PHASES = 6     
)(
    input clock,
    input reset,

    input      [N_E-1:0]    e_kill,
    input      [N_E*10-1:0] e_x,
    input      [N_E*10-1:0] e_y,
    input                   p_kill,
    input      [9:0]        p_x,
    input      [9:0]        p_y,

    output     [N_FX-1:0]    fx_valid,  
    output     [N_FX*10-1:0] fx_x,
    output     [N_FX*10-1:0] fx_y,
    output     [N_FX*2-1:0]  fx_frame    
);
    localparam NREQ    = N_E + 1;
    localparam PH_HALF = FX_PHASES / 2;   

    wire [NREQ-1:0]    req;
    wire [NREQ*10-1:0] req_x, req_y;

    genvar gr;
    generate
        for (gr = 0; gr < N_E; gr = gr + 1) begin : g_req_enemy
            assign req[gr]                = e_kill[gr];
            assign req_x[gr*10 +: 10]     = e_x[gr*10 +: 10];
            assign req_y[gr*10 +: 10]     = e_y[gr*10 +: 10];
        end
    endgenerate
    assign req[N_E]            = p_kill;
    assign req_x[N_E*10 +: 10] = p_x;
    assign req_y[N_E*10 +: 10] = p_y;

    reg [N_FX-1:0]    new_hit;   // 本拍这批槽被新请求占用
    reg [N_FX*10-1:0] new_x, new_y;
    reg [N_FX-1:0]    taken;
    reg               got;
    integer rq, sk;

    always @(*) begin
        new_hit = {N_FX{1'b0}};
        new_x   = {(N_FX*10){1'b0}};
        new_y   = {(N_FX*10){1'b0}};
        taken   = {N_FX{1'b0}};
        for (rq = NREQ - 1; rq >= 0; rq = rq - 1) begin
            if (req[rq]) begin
                got = 1'b0;
                for (sk = N_FX - 1; sk >= 0; sk = sk - 1) begin
                    if (!got && !fx_valid[sk] && !taken[sk]) begin
                        got                = 1'b1;
                        taken[sk]          = 1'b1;
                        new_hit[sk]        = 1'b1;
                        new_x[sk*10 +: 10] = req_x[rq*10 +: 10];
                        new_y[sk*10 +: 10] = req_y[rq*10 +: 10];
                    end
                end
            end
        end
    end

    genvar gs;
    generate
        for (gs = 0; gs < N_FX; gs = gs + 1) begin : g_fx
            reg        busy;      // 1 = 正在爆炸
            reg [9:0]  bx, by;    // 爆炸位置
            reg [3:0]  ph;       
            reg [23:0] d;      

            assign fx_valid[gs]        = busy;
            assign fx_x[gs*10 +: 10]   = bx;
            assign fx_y[gs*10 +: 10]   = by;
            // 前一半相位用"亮爆团"，后一半用"星形环"
            assign fx_frame[gs*2 +: 2] = (ph >= PH_HALF) ? 2'd1 : 2'd0;

            initial begin
                busy = 1'b0;
                bx   = 10'd0;
                by   = 10'd0;
                ph   = 4'd0;
                d    = 24'd0;
            end

            always @(posedge clock) begin
                if (reset) begin
                    busy <= 1'b0;
                    bx   <= 10'd0;
                    by   <= 10'd0;
                    ph   <= 4'd0;
                    d    <= 24'd0;
                end else if (new_hit[gs]) begin
                    busy <= 1'b1;
                    bx   <= new_x[gs*10 +: 10];
                    by   <= new_y[gs*10 +: 10];
                    ph   <= 4'd0;
                    d    <= 24'd0;
                end else if (busy) begin
                    if (d >= FX_DIV - 1) begin
                        d <= 24'd0;
                        if (ph >= FX_PHASES - 1) begin
                            busy <= 1'b0;       // 放完最后一帧 -> 释放槽
                            ph   <= 4'd0;
                        end else begin
                            ph <= ph + 4'd1;
                        end
                    end else begin
                        d <= d + 24'd1;
                    end
                end
            end
        end
    endgenerate

endmodule

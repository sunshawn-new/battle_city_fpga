`timescale 1ns / 1ps

module level_loader #(
    parameter BCOLS = 30, 
    parameter BROWS = 30, 
    parameter MAP_W = 120, 
    parameter LEVEL_SLOT = 1024,  
    parameter HQ_X0 = 58,    
    parameter HQ_Y0 = 116,  

    parameter HQ_W  = 4,
    parameter HQ_H  = 4
)(
    input             clock,
    input             reset,

    input             start,   
    input      [2:0]  level,       
    input             ld_quiet, 

    output reg [11:0] rom_addr,
    input      [3:0]  rom_dout,

    output reg [14:0] wr_addr,
    output reg [3:0]  wr_din,
    output reg        wr_we,

    output            busy,  
    output reg        done       
);
    localparam S_IDLE = 2'd0,
               S_ADS  = 2'd1,   
               S_LAT  = 2'd2,   
               S_WR   = 2'd3;   

    reg [1:0]  state = S_IDLE;
    reg [1:0]  lat_cnt = 2'd0;     
    reg [4:0]  bx = 5'd0, by = 5'd0; 
    reg [3:0]  cc = 4'd0;          
    reg [3:0]  blk = 4'd0;          
    reg [11:0] base = 12'd0;      

    assign busy = (state != S_IDLE);

    // 关卡号兜底：0 当成 1
    wire [2:0]  lv      = (level == 3'd0) ? 3'd1 : level;
    wire [11:0] lv_base = {2'b0, lv - 3'd1, 10'd0};     // (lv-1) * 1024

    wire [11:0] blk_off = ({7'd0, by} << 5) - ({7'd0, by} << 1) + {7'd0, bx};
    wire [4:0]  by_nxt  = by + 5'd1;

    wire [6:0]  gx = {2'b0, bx, 2'b00} + {5'd0, cc[1:0]};
    wire [6:0]  gy = {2'b0, by, 2'b00} + {5'd0, cc[3:2]};
    // 基地判定
    wire        in_hq    = (gx >= HQ_X0) && (gx < HQ_X0 + HQ_W) &&
                           (gy >= HQ_Y0) && (gy < HQ_Y0 + HQ_H);
    wire        in_shell = (gx >= HQ_X0 - 2) && (gx < HQ_X0 + HQ_W + 2) &&
                           (gy >= HQ_Y0 - 2) && (gy < HQ_Y0 + HQ_H) && !in_hq;
    wire [3:0]  tile  = (blk == 4'd5) ? (in_hq ? 4'd5 : (in_shell ? 4'd1 : 4'd0))
                                      : blk;
    wire [14:0] cell_addr = ({8'd0, gy} << 7) - ({8'd0, gy} << 3) + {8'd0, gx};

    wire        last_blk = (bx == BCOLS - 1) && (by == BROWS - 1);

    always @(posedge clock) begin
        if (reset) begin
            state    <= S_IDLE;
            lat_cnt  <= 2'd0;
            bx       <= 5'd0;
            by       <= 5'd0;
            cc       <= 4'd0;
            blk      <= 4'd0;
            base     <= 12'd0;
            rom_addr <= 12'd0;
            wr_addr  <= 15'd0;
            wr_din   <= 4'd0;
            wr_we    <= 1'b0;
            done     <= 1'b0;
        end else begin
            done  <= 1'b0;
            wr_we <= 1'b0;

            case (state)
                S_IDLE: begin
                    if (start) begin
                        bx       <= 5'd0;
                        by       <= 5'd0;
                        cc       <= 4'd0;
                        lat_cnt  <= 2'd0;
                        base     <= lv_base;
                        rom_addr <= lv_base;              // 第 0 块
                        state    <= S_ADS;
                    end
                end

                S_ADS: begin
                    // 读取时经过双重寄存器，要打两拍
                    if (lat_cnt != 2'd2) begin
                        lat_cnt <= lat_cnt + 2'd1;
                    end else begin
                        lat_cnt <= 2'd0;
                        state   <= S_LAT;
                    end
                end

                S_LAT: begin
                    blk   <= rom_dout;
                    cc    <= 4'd0;
                    state <= S_WR;
                end

                default: begin
                    if (ld_quiet) begin
                        wr_we   <= 1'b1;
                        wr_addr <= cell_addr;
                        wr_din  <= tile;
                        cc      <= cc + 4'd1;
                        if (cc == 4'd15) begin
                            if (last_blk) begin
                                state <= S_IDLE;
                                done  <= 1'b1;
                            end else if (bx == BCOLS - 1) begin
                                bx       <= 5'd0;
                                by       <= by_nxt;
                                cc       <= 4'd0;
                                rom_addr <= base + ({7'd0, by_nxt} << 5)
                                                  - ({7'd0, by_nxt} << 1);
                                state    <= S_ADS;
                            end else begin
                                bx       <= bx + 5'd1;
                                cc       <= 4'd0;
                                rom_addr <= base + blk_off + 12'd1;   // 行内下一块
                                state    <= S_ADS;
                            end
                        end
                    end
                end
            endcase
        end
    end
endmodule

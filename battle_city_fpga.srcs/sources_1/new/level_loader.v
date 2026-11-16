`timescale 1ns / 1ps

// ============================================================================
//  level_loader —— 关卡“块图” -> 地图 BRAM 的展开器
//
//  【它解决什么问题】
//    地图 RAM（blk_mem_gen_0）上电时只装了第 1 关（map.coe 是它的初值）。
//    换关必须把整张 120x120 的地图换掉，所以需要一条“把地图重写一遍”的通路。
//
//  【为什么 ROM 里存 30x30 块图，而不是 120x120 格】
//    · 存格子：14400 项 x 4 位 = 57600 位/关，4 关就要 8 个 BRAM36；
//    · 存块图：900 项 x 4 位 = 3600 位/关，4 关塞进 1 个 BRAM18 还有富余。
//    展开规则很简单（每块 -> 4x4 格，'H' 块落在基地矩形里的是 5、其余补砖），
//    硬件做一遍只要 14400 次写 = 144us，比一次屏幕刷新还短，
//    换关时玩区闪一下完全看不出来。
//
//  【展开规则必须和 pysrc/gen_levels.py 逐格一致】
//    Python 那边有同样的 expand_cells()，gen_levels.py 会把它和
//    map_generator.expand() 逐格比对（不一致就报错退出），这边再用
//    tb_stage 把“装载后的地图 RAM”和 Python 期望值对照 —— 三道保险。
//
//  【和地图总线的互斥】
//    装载期间本模块独占 Port A 的写口。上层（top.v）在 paused 期间把
//    terrain_probe / bullet_ctrl 全部复位，它们不会再发请求；本模块自己
//    还会再看一眼 ld_quiet（总线是否真的空闲），避免把别人扫到一半的
//    窗口打断（属于兜底保护）。
//
//  时序（每块）：S_ADS 1 拍（送地址）+ S_LAT 1 拍（收 1 拍读延迟的数据）
//                + S_WR 16 拍（写 4x4 格）= 18 拍/块；
//                30x30 块 = 900 块 -> 16200 拍 ≈ 162us @100MHz。
// ============================================================================
module level_loader #(
    parameter BCOLS = 30,             // 一张地图多少块宽（30）
    parameter BROWS = 30,             // 多少块高（30）
    parameter MAP_W = 120,            // 地图多少格宽（BCOLS * 4）
    parameter LEVEL_SLOT = 1024,      // 关卡 ROM 里每关占多少项（900 向上取到 1024）
    parameter HQ_X0 = 58,             // 基地本体（格坐标）= vga.v 那张 20x20 金鹰
    parameter HQ_Y0 = 113,            // 精灵的包围盒，和 map_generator.py 一致
    parameter HQ_W  = 4,
    parameter HQ_H  = 4
)(
    input             clock,
    input             reset,

    input             start,          // 单拍：开始装载
    input      [2:0]  level,          // 要装的关卡号 1..4
    input             ld_quiet,       // 1 = 地图总线当前空闲（没人占用）

    // ---------------- 关卡 ROM（blk_mem_level：4096 x 4，1 拍读延迟）----------------
    output reg [11:0] rom_addr,
    input      [3:0]  rom_dout,

    // ---------------- 地图 RAM Port A 写口 ----------------
    output reg [14:0] wr_addr,
    output reg [3:0]  wr_din,
    output reg        wr_we,

    output            busy,           // 1 = 正在装载
    output reg        done            // 单拍：装载完成
);
    localparam S_IDLE = 2'd0,
               S_ADS  = 2'd1,         // 地址已经送出，等 ROM 采进去（1 拍读延迟的第 1 拍）
               S_LAT  = 2'd2,         // rom_dout 本拍有效：锁存本块的 tile_id
               S_WR   = 2'd3;         // 写这一块的 4x4 格

    reg [1:0]  state = S_IDLE;
    reg [4:0]  bx = 5'd0, by = 5'd0;  // 块坐标 0..29
    reg [3:0]  cc = 4'd0;             // 块内格子 0..15
    reg [3:0]  blk = 4'd0;            // 本块的 tile_id
    reg [11:0] base = 12'd0;          // 本关在 ROM 里的起始地址

    assign busy = (state != S_IDLE);

    // 关卡号兜底：0 当成 1（stage_ctrl 正常不会给 0，但别让地址跑到别的关卡去）
    wire [2:0]  lv      = (level == 3'd0) ? 3'd1 : level;
    wire [11:0] lv_base = {2'b0, lv - 3'd1, 10'd0};     // (lv-1) * 1024

    // 块内偏移 = by*30 + bx = (by<<5) - (by<<1) + bx
    wire [11:0] blk_off = ({7'd0, by} << 5) - ({7'd0, by} << 1) + {7'd0, bx};
    wire [4:0]  by_nxt  = by + 5'd1;

    // 块内第 cc 格的格坐标：gx = bx*4 + cc[1:0]，gy = by*4 + cc[3:2]
    wire [6:0]  gx = {2'b0, bx, 2'b00} + {5'd0, cc[1:0]};
    wire [6:0]  gy = {2'b0, by, 2'b00} + {5'd0, cc[3:2]};
    // 基地块：落在基地矩形（4x4 格 = 鹰的 20x20 包围盒）里的格子是 5，
    // 矩形上/左/右的格子补砖（U 型堡垒的墙），矩形下方敞开留空 ——
    // 经典样式：鹰完整可见，不埋在整块砖里。和 pysrc 的 expand 规则逐格一致。
    wire        in_hq = (gx >= HQ_X0) && (gx < HQ_X0 + HQ_W) &&
                        (gy >= HQ_Y0) && (gy < HQ_Y0 + HQ_H);
    wire [3:0]  tile  = (blk == 4'd5) ? (in_hq ? 4'd5
                                             : ((gy < HQ_Y0 + HQ_H) ? 4'd1 : 4'd0))
                                      : blk;
    // 地图地址 = gy * MAP_W + gx；MAP_W = 120 = 128 - 8
    wire [14:0] cell_addr = ({8'd0, gy} << 7) - ({8'd0, gy} << 3) + {8'd0, gx};

    wire        last_blk = (bx == BCOLS - 1) && (by == BROWS - 1);

    always @(posedge clock) begin
        if (reset) begin
            state    <= S_IDLE;
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
                        base     <= lv_base;
                        rom_addr <= lv_base;              // 第 0 块
                        state    <= S_ADS;
                    end
                end

                S_ADS: begin
                    // 地址已经稳定了一整拍，ROM 在这一拍末尾把数据打出来
                    state <= S_LAT;
                end

                S_LAT: begin
                    // rom_dout 就是上面那个地址的数据（1 拍读延迟）
                    blk   <= rom_dout;
                    cc    <= 4'd0;
                    state <= S_WR;
                end

                default: begin // S_WR：一块内的 16 格，一拍写一格
                    if (ld_quiet) begin
                        wr_we   <= 1'b1;
                        wr_addr <= cell_addr;
                        wr_din  <= tile;
                        cc      <= cc + 4'd1;
                        if (cc == 4'd15) begin
                            // 这一块写完：换下一块（或收工）。
                            // 注意最后这一拍【不能】再清 wr_we —— 上面刚把它置 1，
                            // 这一拍还要把第 900 块的第 16 格（右下角那一格）真正写进去。
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
                    // ld_quiet = 0：本拍什么也不做，等总线空出来再继续
                    // （上层把 paused 接好之后永远不会走到这里，纯兜底）
                end
            endcase
        end
    end
endmodule

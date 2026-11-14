`timescale 1ns / 1ps

// ============================================================================
//  fx_ctrl —— 坦克被击毁时的爆炸动画（2 帧贴图 + 定时相位）
//
//  贴图已经有两张准备好了（img/tank_destroyed1|2.png -> tank_destroyed*_16bit.coe）：
//    tank_destroyed1：亮黄白色的实心爆团（"炸开的那一下"）
//    tank_destroyed2：橙色的星形环（"火球散掉"）
//  这个模块不画像素（画在 vga.v 的爆炸图层里），只负责：
//    1. 谁死了 -> 在死的位置开一个爆炸槽；
//    2. 每个槽按 FX_DIV 拍 -> 一个相位，相位决定用哪一帧；
//    3. 相位走完 -> 释放槽，等下一次死亡复用。
//
//  【为什么要一个“池”】3 辆敌人 + 玩家可能在同一拍里同时被击毁（两发炮弹同拍命中，
//  或者在弹对弹的同时另一发打中坦克），如果只做一个爆炸寄存器就会丢一个。4 个槽
//  刚好覆盖最坏情况（3 敌人 + 玩家），而且比“按坦克编号各存一套”更省逻辑
//  —— 死亡的坦克不需要一一对应。
//
//  【分配规则】同一拍有多个请求时，从“编号小的敌人 -> 玩家”的顺序依次取
//  当前空闲里编号最小的槽。分配是纯组合的（一个 4 级优先编码链），
//  写进槽的寄存器只有 10+10+4+24 位，不会成为关键路径。
//
//  【为什么位置要在“死亡那一拍”采样】玩家中弹后的下一拍就被 top 的 respawn 拉回
//  出生点，晚一拍采到的就是出生点坐标了（爆炸会跑到画面正中）。所以本模块和
//  player.v 在同一个时钟沿采样 player_x/player_y —— 那还是死亡位置。
//
//  朝向：爆炸是中心对称的，不像坦克那样按朝向旋转取点（地址就是 row*20 + col）。
// ============================================================================
module fx_ctrl #(
    parameter N_FX      = 4,            // 爆炸槽数（>= N_E + 1 才能不丢帧）
    parameter N_E       = 3,            // 敌方坦克辆数（请求源数量，和 top 一致）
    parameter FX_DIV    = 8_000_000,    // 每个相位多少拍（100MHz -> 80ms）
    parameter FX_PHASES = 6             // 相位总数：前一半放亮爆团、后一半放星形环
)(
    input clock,
    input reset,

    // ---------------- 请求：敌人被击毁（单拍，坐标取同一拍的 e_x/e_y）----------------
    input      [N_E-1:0]    e_kill,
    input      [N_E*10-1:0] e_x,
    input      [N_E*10-1:0] e_y,
    // ---------------- 请求：玩家被打中（单拍，坐标取同一拍的 p_x/p_y）----------------
    input                   p_kill,
    input      [9:0]        p_x,
    input      [9:0]        p_y,

    // ---------------- 给 VGA 的爆炸图层（扁平打包，第 i 个槽占 [i*10 +: 10]）--------
    output     [N_FX-1:0]    fx_valid,   // 1 = 这个槽正在放
    output     [N_FX*10-1:0] fx_x,
    output     [N_FX*10-1:0] fx_y,
    output     [N_FX*2-1:0]  fx_frame    // 0 = 亮爆团，1 = 星形环
);
    // 请求源：N_E 辆敌人 + 玩家
    localparam NREQ    = N_E + 1;
    localparam PH_HALF = FX_PHASES / 2;     // 相位过半就换第二帧

    // ---------------- 1. 把两类请求拍平成一条总线（敌人 0..N_E-1，玩家在最高位）----
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

    // ---------------- 2. 组合分配：每个请求取一个当前空闲的槽 ----------------
    // 双重循环 + blocking 赋值：外层从最后一个请求往前扫，内层从最后一个槽往前扫，
    // 一旦这个请求找到槽就置 got 挡住内层继续占（Verilog 没有 break，用 got 代替）。
    // 结果：请求编号小的先占，槽编号大的先用 —— 完全确定，仿真里可复现。
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

    // ---------------- 3. 每个槽自己的相位计数器 ----------------
    genvar gs;
    generate
        for (gs = 0; gs < N_FX; gs = gs + 1) begin : g_fx
            reg        busy;      // 1 = 正在爆炸
            reg [9:0]  bx, by;    // 爆炸位置（左上角，和坦克同一个包围盒 20x20）
            reg [3:0]  ph;        // 当前相位
            reg [23:0] d;         // 相位内的拍数

            assign fx_valid[gs]        = busy;
            assign fx_x[gs*10 +: 10]   = bx;
            assign fx_y[gs*10 +: 10]   = by;
            // 前一半相位用"亮爆团"，后一半用"星形环" —— 先炸开再散掉
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
                    // 新爆炸：锁坐标，从第 0 相位重新开始
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

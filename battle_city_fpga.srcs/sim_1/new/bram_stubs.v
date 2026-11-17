`timescale 1ns / 1ps
// ============================================================================
// 仅用于 xsim 仿真的行为级模型（放在 sim/ 目录，不参与综合）
//
// blk_mem_gen_0
//   读延迟（真实 IP 是 C_READ_LATENCY_A=1）：
//     默认（不加宏）                -> 1 拍（和板子一致）
//     xvlog -d BRAM_LATENCY_0 ...   -> 0 拍（组合直通）
//     xvlog -d BRAM_LATENCY_2 ...   -> 2 拍
//     xvlog -d BRAM_LATENCY_3 ...   -> 3 拍
//   run_sim.ps1 会把 0/1/2/3 四种延迟各跑一遍，用来证明 top.v 的扫描逻辑
//   与 BRAM 的具体读延迟无关。
//
//   地图内容：如果 sim/map_mem.hex 存在（run_sim.ps1 会从工程根目录的
//   map.coe 现场生成），就直接 $readmemh 加载 —— 这样仿真用的就是板子里
//   那张真正的地图，期望值和板子上的行为一一对应。
// ============================================================================

// 注意：xvlog 的 "-d NAME=VALUE" 在这个版本里会把 "=VALUE" 当成文件名，
// 所以只能用“宏名选择”的方式传值。
`ifdef BRAM_LATENCY_0
  `define BRAM_LATENCY 0
`elsif BRAM_LATENCY_2
  `define BRAM_LATENCY 2
`elsif BRAM_LATENCY_3
  `define BRAM_LATENCY 3
`else
  `define BRAM_LATENCY 1
`endif

module blk_mem_gen_0(
    input             clka,
    input             wea,
    input      [14:0] addra,
    input      [3:0]  dina,
    output     [3:0]  douta,
    input             clkb,
    input             web,
    input      [14:0] addrb,
    input      [3:0]  dinb,
    output     [3:0]  doutb
);
    localparam LATENCY = `BRAM_LATENCY;

    // testbench 里会直接写这个数组（poke 任务）来构造和地图文件无关的用例
    reg [3:0] mem [0:32767];

    reg [3:0] dly_a0, dly_a1, dly_a2;
    reg [3:0] dly_b0, dly_b1, dly_b2;

    integer i, fd;

    initial begin
        for (i = 0; i < 32768; i = i + 1) mem[i] = 4'd0;

        fd = $fopen("map_mem.hex", "r");
        if (fd != 0) begin
            $fclose(fd);
            $readmemh("map_mem.hex", mem);
            $display("[bram_stub] map loaded from map_mem.hex (real map.coe)");
        end else begin
            $display("[bram_stub] WARNING: map_mem.hex not found - memory stays empty!");
        end
    end

    always @(posedge clka) begin
        if (wea) mem[addra] <= dina;
        dly_a0 <= mem[addra];
        dly_a1 <= dly_a0;
        dly_a2 <= dly_a1;
    end

    always @(posedge clkb) begin
        if (web) mem[addrb] <= dinb;
        dly_b0 <= mem[addrb];
        dly_b1 <= dly_b0;
        dly_b2 <= dly_b1;
    end

    assign douta = (LATENCY == 0) ? mem[addra] :
                   (LATENCY == 1) ? dly_a0    :
                   (LATENCY == 2) ? dly_a1    : dly_a2;

    assign doutb = (LATENCY == 0) ? mem[addrb] :
                   (LATENCY == 1) ? dly_b0    :
                   (LATENCY == 2) ? dly_b1    : dly_b2;
endmodule

// ---------------- 关卡 ROM 桩（blk_mem_level：4096 x 4）----------------
// 内容来自 levels_mem.hex（run_sim.ps1 从工程根目录的 levels.coe 现场生成）。
// tb_stage 用它验证“换关时地图真的被重写了”，所以这里不能像贴图 ROM 那样返回 0。
//
// 【必须和地图桩一样支持 BRAM_LATENCY】真实 IP 的读延迟不一定是 1 拍
// （blk_mem_level 的 C_HAS_MEM_OUTPUT_REGS_A=1 叠上 BRAM 自己的 DOA 寄存器
// 可能是 2 拍）。以前这里写死 `douta <= mem[addra]`，等于假设延迟恒定 1 拍，
// 于是 level_loader 的“地址发出后第 2 拍采样”在板上会晚一个块 ——
// 现象就是整张地图右移 4 格、基地只剩块 15 的 H 被展开。
// 现在跟着 BRAM_LATENCY 走，28 组仿真就能覆盖这条路径。
module blk_mem_level(
    input             clka,
    input      [11:0] addra,
    output     [3:0]  douta
);
    localparam LATENCY = `BRAM_LATENCY;

    reg [3:0] mem [0:4095];
    reg [3:0] dly0, dly1, dly2;
    integer i, fd;

    initial begin
        for (i = 0; i < 4096; i = i + 1) mem[i] = 4'd0;
        fd = $fopen("levels_mem.hex", "r");
        if (fd != 0) begin
            $fclose(fd);
            $readmemh("levels_mem.hex", mem);
            $display("[bram_stub] level blocks loaded from levels_mem.hex (real levels.coe)");
        end else begin
            $display("[bram_stub] WARNING: levels_mem.hex not found - all levels look empty!");
        end
    end

    always @(posedge clka) begin
        dly0 <= mem[addra];
        dly1 <= dly0;
        dly2 <= dly1;
    end

    assign douta = (LATENCY == 0) ? mem[addra] :
                   (LATENCY == 1) ? dly0       :
                   (LATENCY == 2) ? dly1       : dly2;
endmodule

// ---------------- 贴图 ROM 桩：读延迟 1 拍，数据全 0 ----------------
module blk_mem_brick(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_river(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_steel(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_woods(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_player_tank(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

// 三种敌人兵种的贴图 ROM（20x20 = 400 项，IP 512 深 -> 9 位地址）
module blk_mem_tank_fast(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_tank_power(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_tank_armor(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

// 炮弹贴图 ROM：10x10 = 100 项，IP 配置成 128 深 -> 7 位地址
module blk_mem_bullet(
    input clka, input [6:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

// 基地贴图 ROM：20x20 = 400 项，IP 配置成 512 深 -> 9 位地址
module blk_mem_headquarters(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

// 基地被打爆后的贴图（白旗 + 断杆 + 碎石），同样 512x16
module blk_mem_hq_destroyed(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

// 坦克被击毁的两帧爆炸贴图（20x20 = 400 项，IP 512 深 -> 9 位地址）
//   第 1 帧：亮黄白色的实心爆团；第 2 帧：橙色的星形环
module blk_mem_tank_destroyed1(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

module blk_mem_tank_destroyed2(
    input clka, input [8:0] addra, output reg [15:0] douta
);
    always @(posedge clka) douta <= 16'h0000;
endmodule

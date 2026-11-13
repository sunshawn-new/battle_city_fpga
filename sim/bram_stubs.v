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

`timescale 1ns / 1ps

// ============================================================================
//  tank_block —— 坦克互斥（车身包围盒级别）
//
//  给定“本车想去的位置”（左上角像素坐标），判断 20x20 的车身会不会和场上
//  别的车压在一起。两辆车都是 20x20、坐标又永远是 TILE(5) 的倍数，所以
//  “重叠”就等价于 |dx| < 20 && |dy| < 20；相邻一格（dx 或 dy 恰好 = 20）
//  只是贴边，不算重叠 —— 两辆车因此可以并排、也可以首尾相接跟车。
//
//  【为什么单独做成一个模块】
//    player.v（1 辆玩家 vs N 辆敌人）和 enemy_ctrl.v（每辆敌人 vs 玩家 + 其它
//    敌人）都要做同一件事。以前两边都没有这一层判定，结果就是“坦克能互相穿过”
//    —— 上板一眼就能看见两辆车叠在一格里。判定逻辑只写一份，两边实例化，
//    以后改包围盒尺寸也只改这一处。
//
//  【为什么用“候选位置”而不是“当前位置”】
//    坦克每次移动走一整格，所以“下一格有没有别的车”就等于“候选位置上
//    车身包围盒有没有重叠”。判定是纯组合的（comparator 展开成 N 份），
//    每个移动节拍才用一次，没有任何时序压力。
//
//  【和 vga.v 的关系】
//    vga 里“同一像素最多落在一辆车上”的优先级 mux（玩家 > 编号小的敌人）
//    在这个模块生效之后基本用不上了，但保留着当兜底（出生那一拍还是可能
//    短暂重合，比如玩家正好堵在出生点）。
//
//  【use_dsp = "no" 不是随手加的 —— 它救过一次时序】
//    “|dx| < 20”这种“先比大小再相减再比较”的写法，Vivado 会自动吸收进
//    DSP48E1 的 pattern detect（连 LUT 名字都会变成 div5_return0_i_*_comp_*）。
//    吸收之后最差路径变成：
//      enemy x_reg -> 候选坐标(±5) -> 4 路 dx/dy 减法 -> OR -> 地形 probe 的 DSP CE
//    实测 WNS = -1.49ns / 12 级逻辑 / 路由 7.7ns（34 条违例）。
//    这个判定纯组合、每个移动节拍才用一次，根本不需要 DSP；
//    关掉吸收后它老老实实留在 LUT 里（3~4 级），WNS 就回去了。
//    注意：只关这一个模块，div5（地图坐标 /5）该用 DSP 还是用 DSP。
//
//  【“|dx| < 20”用位测试，不再用比较器】（第二轮优化）
//    坐标恒为 TILE=5 的整数倍 → |dx| 只可能是 0/5/10/15/20/…，
//    所以 |dx| < 16 就等于 |dx| < 20。把 11 位比较器换成“高 7 位全 0”
//    的位测试：每个比较器少 3 级进位链、省约 10 个 LUT。
//    这里是最差时序路径（enemy 的 y_reg → can_go → 决策寄存器）的源头，
//    改完后的 slack 见 sim/build_report.txt（11 级 → 更少，WNS 明显变大）。
// ============================================================================
(* use_dsp = "no" *)
module tank_block #(
    parameter N      = 3,      // 参与比较的“别的车”数量
    parameter TANK_W = 20,     // 车身宽（像素）
    parameter TANK_H = 20,
    parameter TILE   = 5       // 一格像素：所有坦克坐标都是它的整数倍
)(
    input  [9:0]      cx,      // 本车想去的左上角（像素）
    input  [9:0]      cy,
    input  [N-1:0]    o_valid, // 第 i 辆“别的车”当前是否在场
    input  [N*10-1:0] o_x,     // 第 i 辆占 o_x[i*10 +: 10]
    input  [N*10-1:0] o_y,
    output            blocked  // 1 = 这个位置上会和别的车重叠
);
    localparam [10:0] W11 = TANK_W;
    localparam [10:0] H11 = TANK_H;

    // ================= “|d| < 车宽”的最省写法 =================
    // 所有坦克坐标恒为 TILE 的整数倍（player / enemy_ctrl 都是整格移动），
    // 所以 |d| 只可能是 0、5、10、15、20、…
    // 于是 |d| < 2^HI（HI = floor(log2(TANK_W)) = 4，即 16）就等价于 |d| < 20：
    //   16 落在 (TANK_W-TILE, TANK_W] 这个区间里，中间没有任何“可行值”。
    //   老写法：11 位比较器        → 3 级 CARRY4 + 比较逻辑
    //   新写法：高 7 位全 0 的位测试 → 1 个 LUT6（NOR），没有进位链
    // 参数保护：只有 TANK_W 是 TILE 的整数倍、且 2^HI > TANK_W-TILE 时才用位测试，
    // 否则自动退回普通比较器 —— 以后改车身尺寸/格子大小不会被这个技巧坑到。
    function integer flog2;        // floor(log2(v))
        input integer v;
        integer i;
        begin
            flog2 = 0;
            for (i = 0; i < 31; i = i + 1)
                if ((1 << i) <= v) flog2 = i;
        end
    endfunction

    localparam HI      = flog2(TANK_W);                  // 20 -> 4
    localparam [10:0] THR = 11'd1 << HI;                 // 16
    localparam USE_BIT = (TANK_W % TILE == 0) && (THR > (TANK_W - TILE));

    // 无符号绝对差：先比大小再减，避免 10 位相减回绕成一个大数
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

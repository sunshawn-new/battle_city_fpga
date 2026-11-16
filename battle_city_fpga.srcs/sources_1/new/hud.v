`timescale 1ns / 1ps

// ============================================================================
//  hud —— 右侧信息栏（x = 600..799）：分数 / 关卡 / 敌人 / 生命 / 结算横幅
//
//  【为什么单独一个模块】
//    vga.v 已经负责「地图 + 坦克 + 炮弹 + 基地」的一整条像素流水线，再塞进
//    文字排版就彻底读不动了。HUD 只吃「像素坐标 + 几个状态量」，输出「这个
//    像素算不算侧栏、是什么颜色」，和地图/贴图完全解耦 —— 也就不受 600x600
//    玩区尺寸的影响（改玩区宽度只要改这里的 X0）。
//
//  【排版：字模 5x7、放大 2 倍、字距 16px】
//    5x7 的字模放大 2 倍是 10x14，看起来清楚又不占地方；字距取 16 而不是 12，
//    是为了让「第几个字符 = (x - 行首) >> 4」变成一条移位 —— 不用除法器。
//    一屏最多 12 个字符（12*16 = 192 < 200），够写 BATTLE CITY（11 个）。
//
//  【字形从哪来】
//    font5x7.v（由 pysrc/gen_font.py 从 pysrc/font5x7.py 生成，纯组合 LUT）。
//    没有用 BRAM ROM：42 个字形综合出来才一百多个 LUT，比「新建 IP + coe +
//    仿真桩 + check_mif 期望值」那一整套便宜太多。
//
//  【敌人图标】
//    复用敌人坦克的贴图 ROM：本模块只输出 icon_on / icon_addr / icon_type，
//    由 vga.v 把坦克 ROM 的地址 mux 过去（见 vga.v 里 tank_rom_addr 的注释）。
//    这样图标和场上的坦克长得一模一样，而且不用再多一张贴图。
//
//  【和像素流水线的对齐】
//    map/贴图 ROM 都是 1 拍读延迟，vga.v 里已经有一整套 _d1 信号。本模块的
//    输入坐标必须喂「已经延迟 1 拍」的 img_x/img_y（vga.v 的 img_x_d1/img_y_d1），
//    输出的颜色才是组合的、和背景同一时刻 —— 否则整块侧栏会左移 1 像素。
// ============================================================================
module hud #(
    parameter N_E = 3                  // 敌方坦克辆数（决定图标个数）
)(
    input             clock,           // vga_clk（50MHz），只用来做闪烁计时
    input             reset,
    // ---------------- 像素坐标（0..799 / 0..599，已延迟 1 拍）----------------
    input      [10:0] x,
    input      [10:0] y,
    // ---------------- 显示用的状态 ----------------
    input      [3:0]  score100,        // 分数 = score100 * 100（见 top.v 的说明）
    input      [2:0]  lives,
    input      [2:0]  level,
    input      [5:0]  enemy_left,      // 本关还剩多少辆敌人（含场上活着的）
    input      [N_E-1:0]   enemy_valid,
    input      [N_E*2-1:0] enemy_type,  // 图标按兵种选贴图
    input             game_over,        // 基地被摧毁 / 生命耗尽
    input             victory,          // 敌人全灭
    // ---------------- 输出 ----------------
    output            hud_on,           // 1 = 这个像素属于侧栏（vga 用它抢占图层）
    output reg [11:0] rgb,
    output            icon_on,          // 1 = 这个像素落在某个敌人图标格子里
    output     [8:0]  icon_addr,        // 该图标格的 20x20 贴图地址（朝下）
    output     [1:0]  icon_type         // 该格对应的兵种
);
    // 侧栏从 x = 600 开始；面板宽 200px
    localparam [10:0] X0 = 11'd600;

    wire        in_panel = (x >= X0);
    wire [10:0] px       = x - X0;      // 面板内横坐标 0..199

    assign hud_on = in_panel;

    // ================= 1. 选行：y -> 这一扫描线属于哪一行文字 =================
    //   行表（y0 / 行首 x / 内容）：
    //     16   BATTLE CITY              标题
    //     44   LEVEL n                  关卡
    //     76   ENEMY nn                敌人（+ 本关剩余数，两位十进制）
    //     100  敌人图标格（20x20，间距 28）
    //     132  SCORE  /  160  nn00      分数
    //     192  LIVES  /  220  n         生命
    //     300  GAME OVER / STAGE CLEAR  结算横幅（闪烁）
    //     322  PRESS BTNC              GAME OVER 时的重开提示
    //     556  BTNC=FIRE                按键提示
    //   所有文字行都是 14px 高（= 7 行 x 2 倍），所以 (y - y0) >> 1 就是字模行号。
    reg [3:0]  li;      // 行号，4'hF = 这一行不是文字
    reg [10:0] lx0;     // 该行第一个字符的绝对 x
    reg [10:0] ly0;     // 该行的 y0
    always @(*) begin
        li  = 4'hF;
        lx0 = X0;
        ly0 = 11'd0;
        if (y >= 11'd16 && y < 11'd30) begin
            li = 4'd0; lx0 = X0 + 11'd12; ly0 = 11'd16;
        end else if (y >= 11'd44 && y < 11'd58) begin
            li = 4'd1; lx0 = X0 + 11'd12; ly0 = 11'd44;
        end else if (y >= 11'd76 && y < 11'd90) begin
            li = 4'd2; lx0 = X0 + 11'd12; ly0 = 11'd76;
        end else if (y >= 11'd132 && y < 11'd146) begin
            li = 4'd3; lx0 = X0 + 11'd12; ly0 = 11'd132;
        end else if (y >= 11'd160 && y < 11'd174) begin
            li = 4'd4; lx0 = X0 + 11'd12; ly0 = 11'd160;
        end else if (y >= 11'd192 && y < 11'd206) begin
            li = 4'd5; lx0 = X0 + 11'd12; ly0 = 11'd192;
        end else if (y >= 11'd220 && y < 11'd234) begin
            li = 4'd6; lx0 = X0 + 11'd12; ly0 = 11'd220;
        end else if (y >= 11'd556 && y < 11'd570) begin
            li = 4'd7; lx0 = X0 + 11'd12; ly0 = 11'd556;
        end else if (game_over && y >= 11'd300 && y < 11'd314) begin
            li = 4'd8; lx0 = X0 + 11'd28; ly0 = 11'd300;
        end else if (game_over && y >= 11'd322 && y < 11'd336) begin
            // GAME OVER 下面再补一行"按 BTNC 重开"：板子上唯一的按键提示
            // （y=556 那行会被玩家忽略，贴在横幅下面才看得见）。
            li = 4'd10; lx0 = X0 + 11'd20; ly0 = 11'd322;
        end else if (victory && y >= 11'd300 && y < 11'd314) begin
            li = 4'd9; lx0 = X0 + 11'd12; ly0 = 11'd300;
        end
    end

    // ================= 2. 选字符：行内第几个 + 查字形 =================
    // 注意：这里必须用【绝对】x 减行首 x0（lx0 是绝对坐标），
    // 不能用上面的面板内坐标 px —— px 已经减过一次 600 了，再减 612 会回绕。
    wire [10:0] rel = x - lx0;          // 负数会回绕成大数，被下面的范围检查挡掉
    wire [3:0]  ci  = rel[7:4];         // 第几个字符（每格 16px）
    wire [3:0]  col = rel[3:0];         // 格内 x（0..9 是字形，10..15 是字距）
    wire [10:0] gy0 = y - ly0;          // 行内 y（0..13）
    wire [2:0]  gry = gy0[3:1];         // 字模行号（0..6）
    wire        in_text = (rel < 11'd176);   // 一行最多 11 个字符

    // ASCII 常数表（避免到处写 "X" 这种字符串常量，读代码时也不容易看花眼）
    localparam [7:0] C_A = 8'h41, C_B = 8'h42, C_C = 8'h43, C_E = 8'h45,
                     C_F = 8'h46, C_G = 8'h47, C_I = 8'h49, C_L = 8'h4C,
                     C_M = 8'h4D, C_N = 8'h4E, C_O = 8'h4F, C_P = 8'h50,
                     C_R = 8'h52,
                     C_S = 8'h53, C_T = 8'h54, C_V = 8'h56, C_Y = 8'h59,
                     C_0 = 8'h30, C_SP = 8'h20, C_EQ = 8'h3D;

    function [7:0] dchr;                // 0..9 -> '0'..'9'
        input [3:0] d;
        begin
            case (d)
                4'd0: dchr = 8'h30;  4'd1: dchr = 8'h31;  4'd2: dchr = 8'h32;
                4'd3: dchr = 8'h33;  4'd4: dchr = 8'h34;  4'd5: dchr = 8'h35;
                4'd6: dchr = 8'h36;  4'd7: dchr = 8'h37;  4'd8: dchr = 8'h38;
                4'd9: dchr = 8'h39;  default: dchr = 8'h2D;
            endcase
        end
    endfunction

    // 分数的十进制位：分数永远是 100 的倍数（杀一辆车 +100/200/300），
    // 所以只要 score100 的十位和个位，后面两位恒为 0 —— 零除法器。
    wire [3:0] sc_hi = (score100 >= 4'd10) ? 4'd1 : 4'd0;
    wire [3:0] sc_lo = score100 - (sc_hi * 4'd10);

    // 剩余敌人数的两位十进制（0..43：每关最多 20 辆，加上场上的 3 辆不会溢出）。
    // 同样是“比较链 + 一次乘 10”，没有除法器：6 位比较器 5 个，十几 LUT。
    wire [3:0] el_hi = (enemy_left >= 6'd40) ? 4'd4 :
                       (enemy_left >= 6'd30) ? 4'd3 :
                       (enemy_left >= 6'd20) ? 4'd2 :
                       (enemy_left >= 6'd10) ? 4'd1 : 4'd0;
    wire [3:0] el_lo = enemy_left - (el_hi * 4'd10);

    reg [7:0] ch;
    always @(*) begin
        ch = C_SP;                      // 默认空格
        case (li)
            4'd0: case (ci)             // BATTLE CITY
                4'd0: ch = C_B;  4'd1: ch = C_A;  4'd2: ch = C_T;
                4'd3: ch = C_T;  4'd4: ch = C_L;  4'd5: ch = C_E;
                4'd6: ch = C_SP; 4'd7: ch = C_C;  4'd8: ch = C_I;
                4'd9: ch = C_T;  4'd10: ch = C_Y;
                default: ch = C_SP;
            endcase
            4'd1: case (ci)             // LEVEL n
                4'd0: ch = C_L; 4'd1: ch = C_E; 4'd2: ch = C_V;
                4'd3: ch = C_E; 4'd4: ch = C_L; 4'd5: ch = C_SP;
                4'd6: ch = dchr({1'b0, level});
                default: ch = C_SP;
            endcase
            4'd2: case (ci)             // ENEMY nn
                4'd0: ch = C_E; 4'd1: ch = C_N; 4'd2: ch = C_E;
                4'd3: ch = C_M; 4'd4: ch = C_Y;
                4'd6: ch = dchr(el_hi);
                4'd7: ch = dchr(el_lo);
                default: ch = C_SP;
            endcase
            4'd3: case (ci)             // SCORE
                4'd0: ch = C_S; 4'd1: ch = C_C; 4'd2: ch = C_O;
                4'd3: ch = C_R; 4'd4: ch = C_E;
                default: ch = C_SP;
            endcase
            4'd4: case (ci)             // 分数：nn00
                4'd0: ch = dchr(sc_hi);
                4'd1: ch = dchr(sc_lo);
                4'd2: ch = C_0;
                4'd3: ch = C_0;
                default: ch = C_SP;
            endcase
            4'd5: case (ci)             // LIVES
                4'd0: ch = C_L; 4'd1: ch = C_I; 4'd2: ch = C_V;
                4'd3: ch = C_E; 4'd4: ch = C_S;
                default: ch = C_SP;
            endcase
            4'd6: case (ci)             // 剩余生命数
                4'd0: ch = dchr({1'b0, lives});
                default: ch = C_SP;
            endcase
            4'd7: case (ci)             // BTNC=FIRE
                4'd0: ch = C_B; 4'd1: ch = C_T; 4'd2: ch = C_N;
                4'd3: ch = C_C; 4'd4: ch = C_EQ; 4'd5: ch = C_F;
                4'd6: ch = C_I; 4'd7: ch = C_R; 4'd8: ch = C_E;
                default: ch = C_SP;
            endcase
            4'd8: case (ci)             // GAME OVER
                4'd0: ch = C_G; 4'd1: ch = C_A; 4'd2: ch = C_M;
                4'd3: ch = C_E; 4'd4: ch = C_SP; 4'd5: ch = C_O;
                4'd6: ch = C_V; 4'd7: ch = C_E; 4'd8: ch = C_R;
                default: ch = C_SP;
            endcase
            4'd9: case (ci)             // STAGE CLEAR
                4'd0: ch = C_S; 4'd1: ch = C_T; 4'd2: ch = C_A;
                4'd3: ch = C_G; 4'd4: ch = C_E; 4'd5: ch = C_SP;
                4'd6: ch = C_C; 4'd7: ch = C_L; 4'd8: ch = C_E;
                4'd9: ch = C_A; 4'd10: ch = C_R;
                default: ch = C_SP;
            endcase
            4'd10: case (ci)            // PRESS BTNC（GAME OVER 后提示重开）
                4'd0: ch = C_P; 4'd1: ch = C_R; 4'd2: ch = C_E;
                4'd3: ch = C_S; 4'd4: ch = C_S; 4'd5: ch = C_SP;
                4'd6: ch = C_B; 4'd7: ch = C_T; 4'd8: ch = C_N;
                4'd9: ch = C_C;
                default: ch = C_SP;
            endcase
            default: ch = C_SP;
        endcase
    end

    wire [4:0] gbits;
    font5x7 u_font(.ch(ch), .row(gry), .bits(gbits));

    // 像素落在字形上？(col 0..9 且行 0..13 且该位是 1)
    // 字模 5 列放大 2 倍 = 10 像素宽，所以【两个像素共用一位】：列号要 >>1
    // （行方向同理，gry = gy0[3:1]）。只写 4-col 会把字形横向压扁成乱码。
    wire [2:0] gcol = 3'd4 - col[3:1];       // col 0..9 -> 字模列 0..4
    wire       text_px = in_text && (li != 4'hF) && (col < 4'd10)
                         && (gy0 < 11'd14) && gbits[gcol];

    // ================= 3. 敌人图标：N_E 个 20x20 的格子 =================
    //   位置：面板内 x = 12 + i*28，y = 100..119；和场上坦克同一张贴图，
    //   朝下（正好对着玩区里的玩家方向），一眼能看出还剩几个、什么兵种。
    wire [10:0] iy = y - 11'd100;
    wire        icon_row = (y >= 11'd100) && (y < 11'd120);
    wire [N_E-1:0]   icon_hit;
    wire [N_E*9-1:0] icon_a;
    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_icon
            wire [10:0] ix = px - (11'd12 + gi * 11'd28);
            assign icon_hit[gi] = icon_row && (ix < 11'd20) && enemy_valid[gi];
            // 朝下的坦克（和 vga.v 里 tank_addr 的 2'b01 分支一致）：399 - py*20 - px
            wire [8:0] row20 = ({4'b0, iy[4:0]} << 4) + ({4'b0, iy[4:0]} << 2);
            assign icon_a[gi*9 +: 9] = 9'd399 - row20 - {4'b0, ix[4:0]};
        end
    endgenerate

    reg [8:0] icon_addr_r;
    reg [1:0] icon_type_r;
    reg       icon_on_r;
    integer   ii;
    always @(*) begin
        icon_on_r   = 1'b0;
        icon_addr_r = 9'd0;
        icon_type_r = 2'd0;
        for (ii = 0; ii < N_E; ii = ii + 1)
            if (!icon_on_r && icon_hit[ii]) begin
                icon_on_r   = 1'b1;
                icon_addr_r = icon_a[ii*9 +: 9];
                icon_type_r = enemy_type[ii*2 +: 2];
            end
    end
    assign icon_on   = icon_on_r;
    assign icon_addr = icon_addr_r;
    assign icon_type = icon_type_r;

    // ================= 4. 颜色 =================
    // 闪烁：50MHz / 2^25 ≈ 1.5Hz，结算横幅共用这个节拍
    reg [24:0] blink_cnt = 25'd0;
    always @(posedge clock) blink_cnt <= blink_cnt + 25'd1;
    wire blink = blink_cnt[24];

    wire banner_on = (y >= 11'd300) && (y < 11'd314);
    wire banner_bg = banner_on && blink;

    // 颜色（12 位）：标题黄、标签浅蓝、数值白
    reg [11:0] text_color;
    always @(*) begin
        case (li)
            4'd0:       text_color = 12'hFE0;   // 标题：黄
            4'd4, 4'd6: text_color = 12'hFFF;   // 数值：白
            4'd8, 4'd9: text_color = 12'hFFF;   // 横幅文字：白
            4'd10:      text_color = blink ? 12'hFE0 : 12'h888;  // 重开提示：闪
            4'd7:       text_color = 12'h789;   // 底部提示：暗
            default:    text_color = 12'hADF;   // 标签：浅蓝
        endcase
    end

    always @(*) begin
        rgb = 12'h113;                       // 面板底色（深蓝黑）
        if (px < 11'd2)  rgb = 12'h8CF;      // 左侧 2px 分界线
        if (banner_bg)   rgb = game_over ? 12'hB11 : 12'h1B1;
        if (text_px)     rgb = text_color;   // 文字压在所有底色之上
    end

endmodule

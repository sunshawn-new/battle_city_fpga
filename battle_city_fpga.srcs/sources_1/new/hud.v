`timescale 1ns / 1ps

module hud #(
    parameter N_E = 3   
)(
    input             clock,  
    input             reset,
    input      [10:0] x,
    input      [10:0] y,
    input      [3:0]  score100,   
    input      [2:0]  lives,
    input      [2:0]  level,
    input      [5:0]  enemy_left,   
    input      [N_E-1:0]   enemy_valid,
    input      [N_E*2-1:0] enemy_type, 
    input             game_over, 
    input             victory,    
    output            hud_on,   
    output reg [11:0] rgb,
    output            icon_on,   
    output     [8:0]  icon_addr,  
    output     [1:0]  icon_type   
);
    localparam [10:0] X0 = 11'd600;

    wire        in_panel = (x >= X0);
    wire [10:0] px       = x - X0;  

    assign hud_on = in_panel;

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

    // 注意：这里必须用【绝对】x 减行首 x0（lx0 是绝对坐标），
    wire [10:0] rel = x - lx0;    
    wire [3:0]  ci  = rel[7:4];  
    wire [3:0]  col = rel[3:0];   
    wire [10:0] gy0 = y - ly0;   
    wire [2:0]  gry = gy0[3:1];  
    wire        in_text = (rel < 11'd176);  

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

    wire [3:0] sc_hi = (score100 >= 4'd10) ? 4'd1 : 4'd0;
    wire [3:0] sc_lo = score100 - (sc_hi * 4'd10);

    wire [3:0] el_hi = (enemy_left >= 6'd40) ? 4'd4 :
                       (enemy_left >= 6'd30) ? 4'd3 :
                       (enemy_left >= 6'd20) ? 4'd2 :
                       (enemy_left >= 6'd10) ? 4'd1 : 4'd0;
    wire [3:0] el_lo = enemy_left - (el_hi * 4'd10);

    reg [7:0] ch;
    always @(*) begin
        ch = C_SP;  
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

    wire [2:0] gcol = 3'd4 - col[3:1];       // col 0..9 -> 字模列 0..4
    wire       text_px = in_text && (li != 4'hF) && (col < 4'd10)
                         && (gy0 < 11'd14) && gbits[gcol];

    // 控制敌人图标
    wire [10:0] iy = y - 11'd100;
    wire        icon_row = (y >= 11'd100) && (y < 11'd120);
    wire [N_E-1:0]   icon_hit;
    wire [N_E*9-1:0] icon_a;
    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_icon
            wire [10:0] ix = px - (11'd12 + gi * 11'd28);
            assign icon_hit[gi] = icon_row && (ix < 11'd20) && enemy_valid[gi];
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

    reg [24:0] blink_cnt = 25'd0;
    always @(posedge clock) blink_cnt <= blink_cnt + 25'd1;
    wire blink = blink_cnt[24];

    wire banner_on = (y >= 11'd300) && (y < 11'd314);
    wire banner_bg = banner_on && (game_over || victory) && blink;

    reg [11:0] text_color;
    always @(*) begin
        case (li)
            4'd0:       text_color = 12'hFE0; 
            4'd4, 4'd6: text_color = 12'hFFF;  
            4'd8, 4'd9: text_color = 12'hFFF;
            4'd10:      text_color = blink ? 12'hFE0 : 12'h888;
            4'd7:       text_color = 12'h789; 
            default:    text_color = 12'hADF; 
        endcase
    end

    always @(*) begin
        rgb = 12'h113;                
        if (px < 11'd2)  rgb = 12'h8CF;    
        if (banner_bg)   rgb = game_over ? 12'hB11 : 12'h1B1;
        if (text_px)     rgb = text_color;  
    end

endmodule

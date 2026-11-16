`timescale 1ns / 1ps
// ============================================================================
// HUD（右侧 200px 信息栏）仿真测试台
//
// 像素级的检查办法：把 vga.v 的 hcount/vcount 直接 force 成想要的像素，
// 等两拍（img_x_d1/img_y_d1 是打一拍之后才用的），再读 hud 的组合输出：
//    u_vga.hud_on   —— 这个像素算不算侧栏
//    u_vga.hud_rgb  —— 侧栏颜色（面板底色 / 分界线 / 文字）
//    u_vga.hud_icon_on / hud_icon_type —— 敌人图标格
// 这样不用跑完一整帧（800x600 = 48 万像素），一条用例只要几百拍。
//
// 覆盖：
//   H01 侧栏边界正好在 x = 600（599 不是、600 是）
//   H02/H03 面板底色 / 2px 分界线的颜色
//   H04 玩区里不会出现侧栏像素
//   H05~H07 标题 / 关卡 / 标签确实画出了字形（数“文字色”像素 > 阈值）
//   H08/H09 分数、生命是数字字形，随状态变化
//   H10 敌人图标的位置/兵种跟着 enemy_valid 走
//   H11/H12 GAME OVER 横幅（含下面那行 "PRESS BTNC" 重开提示）
// ============================================================================
module tb_hud;
    localparam MOVE_DIV = 200;

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz（vga_clk = 二分频 = 50MHz）

    top #(
        .MOVE_DIV(MOVE_DIV),
        .ENEMY_FIRE(0),
        .INVULN_CYCLES(0)
    ) u_top(
        .clock(clock), .reset(reset),
        .btn_up(btn_up), .btn_down(btn_down),
        .btn_left(btn_left), .btn_right(btn_right),
        .btn_fire(btn_fire),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync)
    );

    integer errors = 0;
    integer i, j, cnt, prev;

    // 把一个像素“送进”vga 流水线：force 扫描计数器，等 img_x_d1 更新
    task probe;
        input integer ix;
        input integer iy;
        begin
            force u_top.u_vga.hcount = ix + 184;     // H_DAT_BEGIN
            force u_top.u_vga.vcount = iy + 29;      // V_DAT_BEGIN
            @(posedge u_top.u_vga.vga_clk);
            @(posedge u_top.u_vga.vga_clk);
            #1;
        end
    endtask

    // 在矩形里数“等于 col 这个颜色”的像素个数（用来判断文字/底色是否存在）
    task count_color;
        input integer x0, x1, y0, y1;
        input [11:0]  col;
        output integer n;
        integer ix, iy;
        begin
            n = 0;
            for (iy = y0; iy <= y1; iy = iy + 1)
                for (ix = x0; ix <= x1; ix = ix + 1) begin
                    probe(ix, iy);
                    if (u_top.u_vga.hud_rgb === col) n = n + 1;
                end
        end
    endtask

    task check_int;
        input [8*46-1:0] name;
        input integer    got;
        input integer    exp;
        begin
            if (got !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got %0d, expected %0d", name, got, exp);
            end else begin
                $display("[ OK ] %0s : %0d", name, got);
            end
        end
    endtask

    task check_ge;
        input [8*46-1:0] name;
        input integer    got;
        input integer    lo;
        begin
            if (got < lo) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got %0d, expected >= %0d", name, got, lo);
            end else begin
                $display("[ OK ] %0s : %0d (>= %0d)", name, got, lo);
            end
        end
    endtask

    task check_ne;
        input [8*46-1:0] name;
        input integer    a;
        input integer    b;
        begin
            if (a == b) begin
                errors = errors + 1;
                $display("[FAIL] %0s : both are %0d (should differ)", name, a);
            end else begin
                $display("[ OK ] %0s : %0d != %0d", name, a, b);
            end
        end
    endtask
    initial begin
        $display("=========== HUD (sidebar) test ===========");

        reset = 1'b1;
        repeat (10) @(posedge clock);
        reset = 1'b0;
        repeat (50) @(posedge clock);

        // 横幅闪烁：钉住计数器的最高位，让 banner 底色确定（文字不受闪烁影响）
        force u_top.u_vga.u_hud.blink_cnt = 25'd0;

        // ---------------- H01 侧栏边界正好在 x = 600 ----------------
        probe(599, 300);
        check_int("H01a x=599 is playfield", u_top.u_vga.hud_on, 0);
        probe(600, 300);
        check_int("H01b x=600 is sidebar",  u_top.u_vga.hud_on, 1);

        // ---------------- H02/H03 底色与分界线 ----------------
        probe(601, 400);
        check_int("H02 2px divider colour", u_top.u_vga.hud_rgb, 12'h8CF);
        probe(700, 400);
        check_int("H03 panel background",   u_top.u_vga.hud_rgb, 12'h113);

        // ---------------- H04 玩区里没有侧栏像素 ----------------
        cnt = 0;
        for (i = 0; i < 8; i = i + 1) begin
            probe(i * 75, 300);
            if (u_top.u_vga.hud_on !== 1'b0) cnt = cnt + 1;
        end
        check_int("H04 no sidebar pixels below x=600", cnt, 0);

        // ---------------- H05~H07 文字真的画出来了 ----------------
        // 标题 "BATTLE CITY"（黄 12'hFE0）：x 612..787，y 16..29
        count_color(612, 787, 16, 29, 12'hFE0, cnt);
        check_ge("H05 title glyphs drawn", cnt, 100);

        // "LEVEL 1"（浅蓝 12'hADF）：x 612..723，y 44..57
        count_color(612, 723, 44, 57, 12'hADF, cnt);
        check_ge("H06 level line drawn", cnt, 50);

        // ---------------- H05b~e 字形形状（钉死 2 倍放大）----------------
        // 标题第一个字是 'B'（cell 起点 x=612, y=16）。'B' 的点阵：
        //   行0 = 11110   行1 = 10001   行3 = 11110
        // 放大 2 倍 -> 字模列 3 占 x 偏移 6..7，字模行 0 占 y 偏移 0..1。
        // 只数“有没有文字像素”抓不到“横向压扁”（4-col / 4-col>>1 都能点亮一片），
        // 所以这里直接钉几个像素的亮/暗。
        probe(612 + 6, 16);
        check_int("H05b B row0 col3 lit",  (u_top.u_vga.hud_rgb === 12'hFE0), 1);
        probe(612 + 6, 18);
        check_int("H05c B row1 col3 dark", (u_top.u_vga.hud_rgb === 12'hFE0), 0);
        probe(612 + 8, 16);
        check_int("H05d B row0 col4 dark (x scale)", (u_top.u_vga.hud_rgb === 12'hFE0), 0);
        probe(612 + 6, 22);
        check_int("H05e B row3 col3 lit (y scale)",  (u_top.u_vga.hud_rgb === 12'hFE0), 1);

        // "SCORE" 标签（浅蓝）
        count_color(612, 691, 132, 145, 12'hADF, cnt);
        check_ge("H07 score label drawn", cnt, 50);

        // ---------------- H08 分数数字随 score100 变化 ----------------
        // 数字用的是白色（12'hFFF）；score100=0 -> "0000"，=6 -> "0600"
        force u_top.score100 = 4'd0;
        repeat (4) @(posedge clock);
        count_color(612, 675, 160, 173, 12'hFFF, prev);
        force u_top.score100 = 4'd6;
        repeat (4) @(posedge clock);
        count_color(612, 675, 160, 173, 12'hFFF, cnt);
        check_ne("H08 score digits change with score", cnt, prev);
        check_ge("H08b score digits actually drawn", cnt, 20);
        release u_top.score100;

        // ---------------- H09 生命数字随 lives 变化 ----------------
        force u_top.lives = 2'd3;
        repeat (4) @(posedge clock);
        count_color(612, 627, 220, 233, 12'hFFF, prev);
        force u_top.lives = 2'd1;
        repeat (4) @(posedge clock);
        count_color(612, 627, 220, 233, 12'hFFF, cnt);
        check_ne("H09 lives digit changes", cnt, prev);
        release u_top.lives;

        // ---------------- H10 敌人图标：位置 / 兵种 / 消失 ----------------
        force u_top.enemy_valid = 3'b101;      // 0 号（快速）和 2 号（装甲）在，1 号没了
        repeat (4) @(posedge clock);
        probe(612 + 10, 100 + 10);
        check_int("H10a icon0 on",        u_top.u_vga.hud_icon_on, 1);
        check_int("H10b icon0 type=fast", u_top.u_vga.hud_icon_type, 0);
        probe(640 + 10, 100 + 10);
        check_int("H10c icon1 hidden (dead)", u_top.u_vga.hud_icon_on, 0);
        probe(668 + 10, 100 + 10);
        check_int("H10d icon2 on",         u_top.u_vga.hud_icon_on, 1);
        check_int("H10e icon2 type=armor", u_top.u_vga.hud_icon_type, 2);
        // 图标用的是坦克贴图 ROM：这个像素上 ROM 地址必须切到图标地址
        if (u_top.u_vga.tank_rom_addr === u_top.u_vga.tank_addr_mux) begin
            errors = errors + 1;
            $display("[FAIL] H10f tank ROM address not muxed to icon");
        end else begin
            $display("[ OK ] H10f tank ROM address muxed to icon (%0d)",
                     u_top.u_vga.tank_rom_addr);
        end
        release u_top.enemy_valid;

        // ---------------- H11/H12 GAME OVER 横幅 ----------------
        // 没输的时候 banner 区域不该有白色文字
        count_color(628, 771, 300, 313, 12'hFFF, prev);
        check_int("H11 no banner before game over", prev, 0);
        // 也没输的时候 y=322 那行不该被当成文字行（li=15 = 不是文字）
        probe(620, 322);
        check_int("H11g no hint row before game over", u_top.u_vga.u_hud.li, 15);

        force u_top.game_over = 1'b1;
        repeat (4) @(posedge clock);
        probe(628, 300);
        check_int("H11b banner row is a text row", u_top.u_vga.u_hud.li, 8);
        count_color(628, 771, 300, 313, 12'hFFF, cnt);
        check_ge("H11c GAME OVER text drawn", cnt, 100);

        // GAME OVER 下面那行“按 BTNC 重开”（hud.v 的 li=10 行，x0+20, y=322）。
        // tb 里 blink_cnt 被钉成 0 -> blink=0 -> 文字是暗色 12'h888。
        // 这是重开一局在板子上唯一的入口，缺了它 GAME OVER 就没法退出。
        probe(620, 322);
        check_int("H11e restart hint is a text row", u_top.u_vga.u_hud.li, 10);
        count_color(620, 795, 322, 335, 12'h888, cnt);
        check_ge("H11f PRESS BTNC drawn", cnt, 60);

        // release 之后 game_over 会停在 force 的那个值（过程赋值没再出现），
        // 所以这里要复位一次把它清掉，否则下面的 VICTORY 永远被 GAME OVER 压着。
        release u_top.game_over;
        reset = 1'b1;
        repeat (10) @(posedge clock);
        reset = 1'b0;
        repeat (20) @(posedge clock);
        check_int("H11d game over cleared by reset", u_top.game_over, 0);

        // VICTORY -> STAGE CLEAR 横幅（同样的区域、更长的字，从 X0+12 开始排）
        force u_top.u_stage_ctrl.stage_clear = 1'b1;
        repeat (4) @(posedge clock);
        probe(612, 300);
        check_int("H12a stage clear banner row", u_top.u_vga.u_hud.li, 9);
        count_color(612, 787, 300, 313, 12'hFFF, cnt);
        check_ge("H12b STAGE CLEAR text drawn", cnt, 200);
        release u_top.u_stage_ctrl.stage_clear;

        // ---------------- H14 ENEMY nn：本关剩余敌人（两位十进制）----------------
        // 直接看 hud 里选出来的字符（ch 是组合的 ASCII），比数像素精确得多。
        force u_top.u_vga.hud_enemy_left = 6'd17;
        repeat (4) @(posedge clock);
        probe(710, 79);
        check_int("H14a ENEMY tens '1'",  u_top.u_vga.u_hud.ch, 8'h31);
        probe(726, 79);
        check_int("H14b ENEMY units '7'", u_top.u_vga.u_hud.ch, 8'h37);

        force u_top.u_vga.hud_enemy_left = 6'd20;
        repeat (4) @(posedge clock);
        probe(710, 79);
        check_int("H14c ENEMY tens '2'",  u_top.u_vga.u_hud.ch, 8'h32);
        probe(726, 79);
        check_int("H14d ENEMY units '0'", u_top.u_vga.u_hud.ch, 8'h30);
        release u_top.u_vga.hud_enemy_left;

        // ---------------- H13 爆炸图层：包围盒命中 / 地址 / 帧选择 ----------------
        // 贴图 ROM 的桩返回全 0（透明），所以这里不看颜色，只看 vga.v 的命中与地址：
        // 地址算错（比如漏了 row*20）在板上表现为"爆炸图案错位/花屏"，只在预览图里看不出来。
        force u_top.u_vga.fx_valid = 4'b1000;              // 只开 3 号槽
        force u_top.u_vga.fx_x     = {10'd100, 30'd0};     // 槽 3 的 x = 100
        force u_top.u_vga.fx_y     = {10'd200, 30'd0};     // 槽 3 的 y = 200
        force u_top.u_vga.fx_frame = 8'b00_00_00_00;

        probe(105, 205);                                   // dx=5 dy=5 -> row*20+col = 105
        check_int("H13a explosion pixel hit",   u_top.u_vga.fx_on, 1);
        check_int("H13b explosion rom addr",    u_top.u_vga.fx_addr_mux, 105);
        check_int("H13c frame0 selected",       u_top.u_vga.fx_frame_sel, 0);

        probe(119, 219);                                   // 包围盒最右下角 -> 399
        check_int("H13d last pixel addr",       u_top.u_vga.fx_addr_mux, 399);

        probe(99, 205);                                    // 左边一格之外：不能命中
        check_int("H13e left of bbox misses",   u_top.u_vga.fx_on, 0);

        probe(120, 205);                                    // dx=20 正好越界
        check_int("H13f right edge misses",     u_top.u_vga.fx_on, 0);

        force u_top.u_vga.fx_frame = 8'b01_00_00_00;       // 槽 3 切到第 2 帧
        probe(105, 205);
        check_int("H13g frame1 selected",       u_top.u_vga.fx_frame_sel, 1);

        release u_top.u_vga.fx_valid;
        release u_top.u_vga.fx_x;
        release u_top.u_vga.fx_y;
        release u_top.u_vga.fx_frame;

        // 收尾：放开所有 force
        release u_top.u_vga.hcount;
        release u_top.u_vga.vcount;
        release u_top.u_vga.u_hud.blink_cnt;
        release u_top.enemy_valid;

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


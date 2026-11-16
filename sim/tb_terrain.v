`timescale 1ns / 1ps
// ============================================================================
// 地形碰撞仿真测试台（xsim）
//
// 地图不是手写的：run_sim.ps1 会把工程根目录的 map.coe 转成 map_mem.hex，
// bram_stubs.v 用 $readmemh 加载 —— 仿真的就是板子里那张真地图。
//
// 【为什么用例不写死地图坐标】
//   地图现在由 pysrc/maps/level1.txt + map_generator.py 生成，随时会改。
//   用例一旦写死“行 40~54 列 30~49 是砖”，改一次地图就要改一次测试台。
//   所以这里分成两类：
//     · 真地图契约（T15/T16）：只断言“基地在哪、出生点净空”这些不可变的约定
//     · 碰撞行为（T06~T13）：先 clear_map 把整张图清零，再用 poke 摆出
//       砖/钢/河/树的形状，断言的是“碰撞逻辑”而不是“某张地图的内容”
//   真地图里仍有三条用例（T06 河流挡路 / T07 浅滩能过 / T13 基地顶盖挡路），
//   用来证明关卡生成出来的地形在 RTL 里确实是这个效果。
//
// 【几何常量】600x600 玩区 = 120x120 格；改玩区尺寸时只需要改这一小段
// 地图契约（map_generator.py 校验的同一套）：
//       基地本体 : 列 58~61 x 行 113~116（= vga.v 里 20x20 金鹰精灵的包围盒，
//                  HQ_X0/HQ_Y0 = 290/565；H 块其余格子由展开器补成砖，
//                  所以砖墙是紧贴着基地的）
//   玩家出生 : (200,560) 格 (40,112) —— 基地左边一块、贴着底边（原版 1P 位置）
//              车身上下 ±60px（下方到画面底边为止）和往右到堡垒墙的横走廊必须空
//   敌人出生 : (40,0)/(300,0)/(560,0) 及其正下方 20px 必须空
//
// 仿真用 MOVE_DIV=200 代替板上的 4_000_000。坦克是【整格移动】：每个
// move_tick 走一整格 TILE=5 像素（见 player.v 的说明），地形扫描约 22 拍，
// 200 拍足够它完成。所以下面的 step_ticks(n) 表示“走 n 像素”，内部换算成 n/5 格。
// ============================================================================
module tb_terrain;
    localparam MOVE_DIV = 200;

    // ---------------- 几何常量（和 top.v / map_generator.py 保持一致）----------
    localparam MAP_W   = 120;          // 地图宽（格）
    localparam SPAWN_X = 200;          // 玩家出生点（像素）= player.v 的 SPAWN_X/Y
    localparam SPAWN_Y = 560;          //   基地左边一块、贴着底边（块 10 x 28）
    // 下面那批“清空地图再摆砖”的碰撞用例不依赖出生点，统一把坦克摆到画面中心
    // 来摆形状（对应 poke 里的行 59 / 列 60 这些地址）。
    localparam COMB_X  = 300;
    localparam COMB_Y  = 300;
    localparam HQ_CX   = 58;           // 基地本体左上角（格）= 鹰的 20x20 包围盒
    localparam HQ_CY   = 113;
    localparam HQ_W    = 4;            // 4x4 格 = 20x20 像素（vga.v 的 HQ_X0/HQ_Y0 = 290/565）
    localparam HQ_H    = 4;
    localparam ENEMY_X0 = 40;          // 三个敌人出生点（像素）
    localparam ENEMY_X1 = 300;
    localparam ENEMY_X2 = 560;
    localparam ENEMY_Y  = 0;           // 贴最上面一行（块行 0）

    // 格地址 = row*MAP_W + col（和 RTL 里 (row<<7)-(row<<3)+col 一致）
    function [14:0] A;
        input [7:0] col;
        input [7:0] row;
        begin
            A = row * MAP_W + col;
        end
    endfunction

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;    // 本测试台不开火（炮弹逻辑由 tb_bullet 覆盖）

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz

    top #(
        .MOVE_DIV(MOVE_DIV),
        .ENEMY_FIRE(0),         // 地形用例不让敌人开火（否则结果不可复现）
        .INVULN_CYCLES(0)
    ) u_top(
        .clock(clock), .reset(reset),
        .btn_up(btn_up), .btn_down(btn_down),
        .btn_left(btn_left), .btn_right(btn_right),
        .btn_fire(btn_fire),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync)
    );

    wire [9:0] px = u_top.player_x;
    wire [9:0] py = u_top.player_y;

    integer errors = 0;
    integer k, j;

    // 等待走过 n 个像素（n 必须是 5 的倍数）。
    // 坦克是整格移动的，所以内部换算成 n/5 次移动节拍，每次走 TILE 像素。
    // move_tick 在 cnt==MOVE_DIV-1 那一拍拉高，位置的更新发生在其后的下一个
    // 时钟沿，所以要多等一拍再 #1 才能看到新位置。
    task step_ticks;
        input integer n;
        begin
            for (k = 0; k < (n / 5); k = k + 1) begin
                @(posedge u_top.u_player.move_tick);
                @(posedge clock);
                #1;
            end
        end
    endtask

    task do_reset;
        integer n;
        begin
            reset = 1'b1;
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            repeat (10) @(posedge clock);
            reset = 1'b0;
            // 复位后 stage_ctrl 会把第 1 关地图重新写进 BRAM（约 15k 拍），
            // 期间 paused=1、玩家被冻结。等它装完再往下跑。
            n = 0;
            while (u_top.stage_paused && n < 200000) begin
                @(posedge clock); n = n + 1;
            end
            repeat (80) @(posedge clock);   // 等前方地形扫描完成（约 22 拍）
        end
    endtask

    // 直接把坦克放到指定坐标（仿真专用）
    task place_tank;
        input [9:0] tx;
        input [9:0] ty;
        begin
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            force u_top.u_player.position_x = tx;
            force u_top.u_player.position_y = ty;
            repeat (4) @(posedge clock);
            release u_top.u_player.position_x;
            release u_top.u_player.position_y;
            repeat (80) @(posedge clock);
        end
    endtask

    // 直接改地图内容（仿真专用），用来做与地图文件无关的碰撞用例
    task poke;
        input [14:0] idx;
        input [3:0]  val;
        begin
            @(negedge clock);
            u_top.u_map_ram.mem[idx] = val;
        end
    endtask

    // 把整张地图清零（仿真专用）：后面的碰撞用例和关卡文件解耦，
    // 断言的是“砖/钢/河/树怎么挡”，而不是“某张地图恰好长什么样”。
    // 19200 = BRAM 的物理深度（有效数据只有 120x120 = 14400，尾部是填充）。
    task clear_map;
        integer m;
        begin
            @(negedge clock);
            for (m = 0; m < 19200; m = m + 1) u_top.u_map_ram.mem[m] = 4'd0;
        end
    endtask

    // 改完地图后等一次“定时刷新”，确保 top 里的查询结果已经更新
    task wait_refresh;
        begin
            repeat (MOVE_DIV + 60) @(posedge clock);
        end
    endtask

    task check_pos;
        input [8*44-1:0] name;
        input [9:0] exp_x;
        input [9:0] exp_y;
        begin
            if (px !== exp_x || py !== exp_y) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got (%0d,%0d), expected (%0d,%0d)",
                         name, px, py, exp_x, exp_y);
            end else begin
                $display("[ OK ] %0s : (%0d,%0d)", name, px, py);
            end
        end
    endtask

    task check_grid;
        input [8*44-1:0] name;
        input [9:0] gx;
        input [9:0] gy;
        begin
            if (((gx % 5) !== 0) || ((gy % 5) !== 0)) begin
                errors = errors + 1;
                $display("[FAIL] %0s : (%0d,%0d) is not on the 5px grid", name, gx, gy);
            end else begin
                $display("[ OK ] %0s : (%0d,%0d)", name, gx, gy);
            end
        end
    endtask
    initial begin
        $display("=========== terrain collision test ===========");

        // T00: 复位后必须已经完成一次地形查询，否则坦克永远不会动
        do_reset;
        if (u_top.terrain_valid !== 1'b1) begin
            errors = errors + 1;
            $display("[FAIL] T00 terrain_valid after reset = %b (front=%0d)",
                     u_top.terrain_valid, u_top.player_terrain_in_front);
        end else begin
            $display("[ OK ] T00 terrain_valid after reset, front=%0d",
                     u_top.player_terrain_in_front);
        end

        // ---- T15：真地图契约 —— 基地本体必须正好是 列 58~61 x 行 113~116 ----
        // vga.v 画基地精灵用的是 HQ_X0/HQ_Y0 = 290/565（20x20 精灵 = 4x4 格），
        // map_generator.py 就必须把 tile 5 铺在同一块 4x4 格上 —— 两者严丝合缝，
        // 鹰占不到的格子才有砖补上（不会有"砖墙中间挖个黑坑"）。
        // 一旦错开，板上就会变成"鹰画在砖墙上"或者"炮弹打不掉基地"。
        begin : hq_contract
            integer hx, hy, hq_bad, stray_bad, shell_bad;
            begin
                hq_bad = 0;
                for (hy = HQ_CY; hy < HQ_CY + HQ_H; hy = hy + 1)
                    for (hx = HQ_CX; hx < HQ_CX + HQ_W; hx = hx + 1)
                        if (u_top.u_map_ram.mem[A(hx, hy)] !== 4'd5) hq_bad = hq_bad + 1;
                if (hq_bad != 0) begin
                    errors = errors + 1;
                    $display("[FAIL] T15a HQ body: %0d/16 cells are not tile 5", hq_bad);
                end else
                    $display("[ OK ] T15a HQ body 4x4 @ cell(%0d,%0d) is all tile 5",
                             HQ_CX, HQ_CY);

                stray_bad = 0;
                for (hy = 0; hy < 120; hy = hy + 1)
                    for (hx = 0; hx < 120; hx = hx + 1)
                        if (u_top.u_map_ram.mem[A(hx, hy)] === 4'd5 &&
                            !(hx >= HQ_CX && hx < HQ_CX + HQ_W &&
                              hy >= HQ_CY && hy < HQ_CY + HQ_H))
                            stray_bad = stray_bad + 1;
                if (stray_bad != 0) begin
                    errors = errors + 1;
                    $display("[FAIL] T15b %0d stray tile-5 cells outside HQ box", stray_bad);
                end else
                    $display("[ OK ] T15b no tile 5 outside the HQ box");

                // T15c：基地上下左右各 1 格必须是砖/钢 —— "砖块把基地围起来"。
                // 这就是地图生成时 map_generator.validate() 的第 1b 条，在 RTL 侧
                // 再验一遍：只要外墙漏一格，坦克就能贴着基地开炮。
                shell_bad = 0;
                for (hx = HQ_CX - 1; hx <= HQ_CX + HQ_W; hx = hx + 1) begin
                    if (u_top.u_map_ram.mem[A(hx, HQ_CY - 1)] !== 4'd1 &&
                        u_top.u_map_ram.mem[A(hx, HQ_CY - 1)] !== 4'd2) shell_bad = shell_bad + 1;
                    if (u_top.u_map_ram.mem[A(hx, HQ_CY + HQ_H)] !== 4'd1 &&
                        u_top.u_map_ram.mem[A(hx, HQ_CY + HQ_H)] !== 4'd2) shell_bad = shell_bad + 1;
                end
                for (hy = HQ_CY; hy < HQ_CY + HQ_H; hy = hy + 1) begin
                    if (u_top.u_map_ram.mem[A(HQ_CX - 1, hy)] !== 4'd1 &&
                        u_top.u_map_ram.mem[A(HQ_CX - 1, hy)] !== 4'd2) shell_bad = shell_bad + 1;
                    if (u_top.u_map_ram.mem[A(HQ_CX + HQ_W, hy)] !== 4'd1 &&
                        u_top.u_map_ram.mem[A(HQ_CX + HQ_W, hy)] !== 4'd2) shell_bad = shell_bad + 1;
                end
                if (shell_bad != 0) begin
                    errors = errors + 1;
                    $display("[FAIL] T15c %0d HQ shell cells are not brick/steel", shell_bad);
                end else
                    $display("[ OK ] T15c HQ shell is brick on all four sides");
            end
        end

        // ---- T16：出生点净空（玩家 ±60px 通道 + 三个敌人出生点正下方）----
        // 可通行 = tile 0（空地）或 4（树林）；砖 1 / 钢 2 / 河 3 / 基地 5 都算挡住
        begin : spawn_contract
            integer sx, sy, bad;
            begin
                // 玩家出生点 (200,560) = 格列 40~43 x 格行 112~115。
                // 竖直方向 ±60px：往上是 100 行，往下会越出画面，所以只检查 100~119
                // （和 map_generator.validate() 里 clip=True 的那条一致）。
                bad = 0;
                for (sy = 100; sy <= 119; sy = sy + 1)
                    for (sx = 40; sx <= 43; sx = sx + 1)
                        if (!(u_top.u_map_ram.mem[A(sx, sy)] == 4'd0 ||
                              u_top.u_map_ram.mem[A(sx, sy)] == 4'd4)) bad = bad + 1;
                // 横向：出生点到堡垒左墙（块列 13，= 格列 52）之间必须能开过去
                for (sy = 112; sy <= 115; sy = sy + 1)
                    for (sx = 40; sx <= 51; sx = sx + 1)
                        if (!(u_top.u_map_ram.mem[A(sx, sy)] == 4'd0 ||
                              u_top.u_map_ram.mem[A(sx, sy)] == 4'd4)) bad = bad + 1;
                if (bad != 0) begin
                    errors = errors + 1;
                    $display("[FAIL] T16a player spawn corridor: %0d blocked cells", bad);
                end else
                    $display("[ OK ] T16a player spawn (%0d,%0d) corridor is clear",
                             SPAWN_X, SPAWN_Y);

                bad = 0;
                for (sy = 0; sy <= 9; sy = sy + 1) begin
                    for (sx = ENEMY_X0/5; sx <= ENEMY_X0/5 + 3; sx = sx + 1)
                        if (!(u_top.u_map_ram.mem[A(sx, sy)] == 4'd0 ||
                              u_top.u_map_ram.mem[A(sx, sy)] == 4'd4)) bad = bad + 1;
                    for (sx = ENEMY_X1/5; sx <= ENEMY_X1/5 + 3; sx = sx + 1)
                        if (!(u_top.u_map_ram.mem[A(sx, sy)] == 4'd0 ||
                              u_top.u_map_ram.mem[A(sx, sy)] == 4'd4)) bad = bad + 1;
                    for (sx = ENEMY_X2/5; sx <= ENEMY_X2/5 + 3; sx = sx + 1)
                        if (!(u_top.u_map_ram.mem[A(sx, sy)] == 4'd0 ||
                              u_top.u_map_ram.mem[A(sx, sy)] == 4'd4)) bad = bad + 1;
                end
                if (bad != 0) begin
                    errors = errors + 1;
                    $display("[FAIL] T16b enemy spawn boxes: %0d blocked cells", bad);
                end else
                    $display("[ OK ] T16b enemy spawns (%0d/%0d/%0d,%0d) +20px are clear",
                             ENEMY_X0, ENEMY_X1, ENEMY_X2, ENEMY_Y);
            end
        end

        // ---- 出生点四方向：这就是“空气墙”bug 的回归测试 ----
        do_reset;                                  // 出生点 (200,560)
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T01 spawn -> up (was stuck)", SPAWN_X, SPAWN_Y - 10);

        do_reset;
        btn_down = 1'b1;  step_ticks(10); btn_down = 1'b0;
        check_pos("T02 spawn -> down", SPAWN_X, SPAWN_Y + 10);

        do_reset;
        btn_left = 1'b1;  step_ticks(10); btn_left = 1'b0;
        check_pos("T03 spawn -> left", SPAWN_X - 10, SPAWN_Y);

        do_reset;
        btn_right = 1'b1; step_ticks(10); btn_right = 1'b0;
        check_pos("T04 spawn -> right", SPAWN_X + 10, SPAWN_Y);

        // ---- 连续前进 60 像素：中途不能卡住 ----
        do_reset;
        btn_up = 1'b1;    step_ticks(60); btn_up = 1'b0;
        check_pos("T05 spawn -> up 60px continuous", SPAWN_X, SPAWN_Y - 60);

        // ---- T06：真地图的河挡路（关卡 1 的河在块行 8~9 = 格行 32~39）----
        // 坦克放在 (300,200)（格列 60~63，河中央、不在浅滩上），向上正好撞到行 39 的水
        do_reset; place_tank(10'd300, 10'd200);
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T06 up blocked by river", 10'd300, 10'd200);

        // ---- T07：真地图的浅滩能过（块列 4~6 = 格列 16~27）----
        do_reset; place_tank(10'd100, 10'd200);
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T07 up across river ford", 10'd100, 10'd190);

        // ---- T13：真地图的基地顶盖挡路（块行 26~27 = 格行 104~111）----
        // (300,480) 一路向下，走到 y=500 时正前方是行 104 的顶盖砖，停住
        do_reset; place_tank(10'd300, 10'd480);
        btn_down = 1'b1;  step_ticks(50); btn_down = 1'b0;
        check_pos("T13 down blocked by base roof", 10'd300, 10'd500);

        // ================= 以下用例先把地图清零，只测碰撞逻辑 =================
        // poke 的地址 = A(列, 行)。这些用例不测出生点，统一把坦克摆到 (300,300)：
        //   上边缘 = 行 60（所以“正前方”是行 59），左边缘 = 列 60
        // 这样用例和关卡文件内容、和出生点位置都完全解耦。

        // ---- T08：砖块切角 —— 正前方 4 格只有最左一格是砖，也必须挡住 ----
        do_reset; clear_map; wait_refresh; place_tank(COMB_X, COMB_Y);
        poke(A(60, 59), 4'd1);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T08 up blocked by 1 brick cell", COMB_X, COMB_Y);

        // ---- T09：河流挡住；把河擦掉就能走 ----
        do_reset; clear_map; wait_refresh; place_tank(COMB_X, COMB_Y);
        for (j = 60; j <= 63; j = j + 1) poke(A(j[7:0], 59), 4'd3);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T09a river blocks", COMB_X, COMB_Y);

        for (j = 60; j <= 63; j = j + 1) poke(A(j[7:0], 59), 4'd0);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T09b river removed -> moves", COMB_X, COMB_Y - 5);

        // ---- T10：树林可以通行 ----
        do_reset; clear_map; wait_refresh; place_tank(COMB_X, COMB_Y);
        for (j = 60; j <= 63; j = j + 1) poke(A(j[7:0], 59), 4'd4);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T10 up into woods (passable)", COMB_X, COMB_Y - 5);

        // ---- T11：钢板挡住；擦掉后能走 ----
        do_reset; clear_map; wait_refresh; place_tank(COMB_X, COMB_Y);
        for (j = 60; j <= 63; j = j + 1) poke(A(j[7:0], 59), 4'd2);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T11a steel injected blocks", COMB_X, COMB_Y);

        for (j = 60; j <= 63; j = j + 1) poke(A(j[7:0], 59), 4'd0);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T11b steel removed -> moves", COMB_X, COMB_Y - 5);

        // ---- T12：向左撞砖块（左前方是列 59，坦克占行 60~63）----
        do_reset; clear_map; wait_refresh; place_tank(COMB_X, COMB_Y);
        for (j = 60; j <= 63; j = j + 1) poke(A(59, j[7:0]), 4'd1);
        wait_refresh;
        btn_left = 1'b1;  step_ticks(5); btn_left = 1'b0;
        check_pos("T12 left blocked by brick", COMB_X, COMB_Y);

        // ---- T14 格点不变量：坐标必须永远是 TILE(5) 的倍数 ----
        // 这是炮弹系统（bullet-ctrl.v）按格判定的前提：坦克一旦停在非格点上，
        // 炮口就不再落在格边界，10x10 的弹体就会跨 3 格，打出的洞也会偏心。
        do_reset;                                   // (300,300)
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_grid("T14a after up   on 5px grid", px, py);

        btn_right = 1'b1; step_ticks(10); btn_right = 1'b0;
        check_grid("T14b after right on 5px grid", px, py);

        btn_down = 1'b1;  step_ticks(10); btn_down = 1'b0;
        check_grid("T14c after down  on 5px grid", px, py);

        btn_left = 1'b1;  step_ticks(10); btn_left = 1'b0;
        check_grid("T14d after left  on 5px grid", px, py);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


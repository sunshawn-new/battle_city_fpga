`timescale 1ns / 1ps
// ============================================================================
// 敌方坦克仿真测试台（xsim）
//
// 和 tb_terrain 一样直接例化 top（地图用 bram_stubs 加载真实 map.coe），
// 这样测的是“接线 + 仲裁 + AI”整体，而不是单独一个模块。
//
// 参数：
//   MOVE_DIV   = 200   -> 玩家 200 拍走一格（板上 4_000_000）
//   敌人节拍    = top 里 MOVE_DIV*2 = 400 拍走一格（板上 8_000_000 -> 12.5Hz）
//   TURN_TICKS = 250   -> 关掉“巡逻随机转向”，用例才可复现
//
// 覆盖的场景：
//   E00 出生点 / 朝向 / 全部存活
//   E01 每个移动节拍走一整格（5px），坐标始终在格点上
//   E02 三个 terrain_probe 同时挂在 map_bus 上，各自读到的地形不能串台
//   E03 正前方是砖：原地转 90°，绝不走进墙里，转向后能继续走
//   E04 玩家查询（p_req[0]）在 4 个客户端抢总线时依然正常
//   E05 长时间跑：坐标始终在格点/边界内，车身 4x4 格永远不会压在硬地形上
// ============================================================================
module tb_enemy;
    localparam MOVE_DIV   = 200;
    localparam TURN_TICKS = 250;

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz

    top #(.MOVE_DIV(MOVE_DIV), .TURN_TICKS(TURN_TICKS)) u_top(
        .clock(clock), .reset(reset),
        .btn_up(btn_up), .btn_down(btn_down),
        .btn_left(btn_left), .btn_right(btn_right),
        .btn_fire(btn_fire),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync)
    );

    integer errors = 0;
    integer k, j;

    task do_reset;
        begin
            reset = 1'b1;
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            repeat (10) @(posedge clock);
            reset = 1'b0;
            repeat (150) @(posedge clock);   // 玩家+3 辆敌人的 probe 各扫一遍
        end
    endtask

    // 等第 i 辆敌人走过 n 个移动节拍。
    // 位置更新发生在本拍之后的下一个时钟沿，所以要多等一拍再 #1 才看得到。
    task step_enemy;
        input integer i;
        input integer n;
        begin
            for (k = 0; k < n; k = k + 1) begin
                @(posedge u_top.enemy_move_tick[i]);
                @(posedge clock);
                #1;
            end
        end
    endtask

    // 三辆车各走 n 个节拍：逐辆等自己的节拍。
    // 注意顺序：enemy_ctrl 里 PHASE 随编号递增，所以编号大的车“先到”它的节拍
    // （第一次节拍在 STEP-PHASE 拍之后）。这里必须按 2 -> 1 -> 0 等，
    // 否则等 0 号的时候 1/2 号的那个节拍已经溜走了，会多走一格。
    task step_all;
        input integer n;
        integer t, i;
        begin
            for (t = 0; t < n; t = t + 1)
                for (i = 2; i >= 0; i = i - 1) begin
                    @(posedge u_top.enemy_move_tick[i]);
                    @(posedge clock);
                    #1;
                end
        end
    endtask

    // 等玩家走过 n 个像素（n 必须是 5 的倍数）
    task step_player;
        input integer n;
        begin
            for (k = 0; k < (n / 5); k = k + 1) begin
                @(posedge u_top.u_player.move_tick);
                @(posedge clock);
                #1;
            end
        end
    endtask

    task poke;
        input [14:0] idx;
        input [3:0]  val;
        begin
            @(negedge clock);
            u_top.u_map_ram.mem[idx] = val;
        end
    endtask

    task check_enemy_pos;
        input [8*40-1:0] name;
        input integer    i;
        input [9:0]      exp_x;
        input [9:0]      exp_y;
        reg   [9:0]      gx, gy;
        begin
            gx = u_top.enemy_x[i*10 +: 10];
            gy = u_top.enemy_y[i*10 +: 10];
            if (gx !== exp_x || gy !== exp_y) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d got (%0d,%0d), expected (%0d,%0d)",
                         name, i, gx, gy, exp_x, exp_y);
            end else begin
                $display("[ OK ] %0s : enemy%0d (%0d,%0d)", name, i, gx, gy);
            end
        end
    endtask

    task check_dir;
        input [8*40-1:0] name;
        input integer    i;
        input [1:0]      exp_d;
        reg   [1:0]      gd;
        begin
            gd = u_top.enemy_dir[i*2 +: 2];
            if (gd !== exp_d) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d dir=%b, expected %b", name, i, gd, exp_d);
            end else begin
                $display("[ OK ] %0s : enemy%0d dir=%b", name, i, gd);
            end
        end
    endtask

    task check_front;
        input [8*40-1:0] name;
        input integer    i;
        input [3:0]      exp_t;
        reg   [3:0]      gt;
        begin
            gt = u_top.enemy_terrain_front[i*4 +: 4];
            if (gt !== exp_t) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d front=%0d, expected %0d", name, i, gt, exp_t);
            end else begin
                $display("[ OK ] %0s : enemy%0d front=%0d", name, i, gt);
            end
        end
    endtask

    task check_grid;
        input [8*40-1:0] name;
        input integer    i;
        reg   [9:0]      gx, gy;
        begin
            gx = u_top.enemy_x[i*10 +: 10];
            gy = u_top.enemy_y[i*10 +: 10];
            if (((gx % 5) !== 0) || ((gy % 5) !== 0)) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d (%0d,%0d) is not on the 5px grid", name, i, gx, gy);
            end else begin
                $display("[ OK ] %0s : enemy%0d (%0d,%0d)", name, i, gx, gy);
            end
        end
    endtask

    // 车身压着的 4x4 格必须全是可通行地形（空地 0 / 树林 4）。
    // 这是“敌人永远不会开进墙里”的最终判据：地形查询只看前边缘，
    // 万一坐标和查询对不上（比如退化成半格移动），这里立刻就会报出来。
    task check_not_in_wall;
        input [8*40-1:0] name;
        input integer    i;
        integer cx, cy, r, c;
        reg [3:0] v;
        reg       bad;
        begin
            bad = 1'b0;
            cx  = u_top.enemy_x[i*10 +: 10];
            cy  = u_top.enemy_y[i*10 +: 10];
            for (r = 0; r < 4; r = r + 1)
                for (c = 0; c < 4; c = c + 1) begin
                    v = u_top.u_map_ram.mem[(cy/5 + r) * 160 + (cx/5 + c)];
                    if (v == 4'd1 || v == 4'd2 || v == 4'd3 || v == 4'd5) bad = 1'b1;
                end
            if (bad) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d at (%0d,%0d) overlaps hard terrain", name, i, cx, cy);
            end else begin
                $display("[ OK ] %0s : enemy%0d at (%0d,%0d) on passable tiles", name, i, cx, cy);
            end
        end
    endtask

    initial begin
        $display("=========== enemy tank test ===========");

        // ---------------- E00 出生状态 ----------------
        do_reset;
        if (u_top.enemy_valid !== 3'b111) begin
            errors = errors + 1;
            $display("[FAIL] E00a enemy_valid=%b, expected 111", u_top.enemy_valid);
        end else begin
            $display("[ OK ] E00a all 3 enemies alive");
        end
        check_enemy_pos("E00b spawn left",   0, 10'd40,  10'd10);
        check_enemy_pos("E00c spawn middle", 1, 10'd380, 10'd10);
        check_enemy_pos("E00d spawn right",  2, 10'd740, 10'd10);
        check_dir("E00e face down", 0, 2'b01);
        check_dir("E00f face down", 1, 2'b01);
        check_dir("E00g face down", 2, 2'b01);

        // ---------------- E01 每个移动节拍走一整格（5px）----------------
        step_all(4);
        check_enemy_pos("E01a down 4 cells", 0, 10'd40,  10'd30);
        check_enemy_pos("E01b down 4 cells", 1, 10'd380, 10'd30);
        check_enemy_pos("E01c down 4 cells", 2, 10'd740, 10'd30);
        check_grid("E01d on 5px grid", 0);
        check_grid("E01e on 5px grid", 1);
        check_grid("E01f on 5px grid", 2);

        // ---------------- E02 三个 probe 读地形不能串台 ----------------
        // 复位期间把三辆车正前方 poke 成不同地形，再放开 reset：
        // 每个 probe 的第一次扫描就会各读各的格子，地址一旦串了这里立刻炸。
        reset = 1'b1;
        repeat (5) @(posedge clock);
        for (j = 8;  j <= 11; j = j + 1) poke(15'd960 + j, 4'd1);   // 行6 列8~11  : 砖
        for (j = 76; j <= 79; j = j + 1) poke(15'd960 + j, 4'd2);   // 行6 列76~79 : 钢
        // 敌人 2 正前方（行6 列148~151）留空地 0
        repeat (5) @(posedge clock);
        reset = 1'b0;
        repeat (150) @(posedge clock);          // 3 个 probe 轮流扫一遍（每个约 30 拍）
        check_front("E02a front=brick", 0, 4'd1);
        check_front("E02b front=steel", 1, 4'd2);
        check_front("E02c front=empty", 2, 4'd0);
        check_enemy_pos("E02d no move before tick", 0, 10'd40, 10'd10);

        // ---------------- E03 前面是砖：原地转 90°，不撞墙 ----------------
        step_enemy(0, 1);
        if (u_top.enemy_dir[1:0] === 2'b01) begin
            errors = errors + 1;
            $display("[FAIL] E03a enemy0 still faces down after hitting brick");
        end else begin
            $display("[ OK ] E03a enemy0 turned to dir=%b", u_top.enemy_dir[1:0]);
        end
        check_enemy_pos("E03b not inside brick", 0, 10'd40, 10'd10);

        step_enemy(0, 2);
        if (u_top.enemy_x[9:0] === 10'd40 && u_top.enemy_y[9:0] === 10'd10) begin
            errors = errors + 1;
            $display("[FAIL] E03c enemy0 stuck at spawn after turning");
        end else begin
            $display("[ OK ] E03c enemy0 left spawn, now at (%0d,%0d)",
                     u_top.enemy_x[9:0], u_top.enemy_y[9:0]);
        end
        check_not_in_wall("E03d body not on brick", 0);
        check_grid("E03e on 5px grid", 0);

        // ---------------- E04 玩家在 4 个客户端抢总线时依然正常 ----------------
        do_reset;
        btn_up = 1'b1;
        step_player(10);
        btn_up = 1'b0;
        if (u_top.player_x !== 10'd400 || u_top.player_y !== 10'd290) begin
            errors = errors + 1;
            $display("[FAIL] E04a player got (%0d,%0d), expected (400,290)",
                     u_top.player_x, u_top.player_y);
        end else begin
            $display("[ OK ] E04a player still moves with 4 probes on the bus");
        end
        // 玩家刚换了坐标，probe 会作废旧结果重扫（约 30 拍），等它回来再看
        repeat (80) @(posedge clock);
        if (u_top.terrain_valid !== 1'b1) begin
            errors = errors + 1;
            $display("[FAIL] E04b player terrain_valid=%b, expected 1", u_top.terrain_valid);
        end else begin
            $display("[ OK ] E04b player terrain_valid=1");
        end

        // ---------------- E05 长时间运行：格点 / 边界 / 不压墙 ----------------
        do_reset;
        step_all(60);
        for (j = 0; j < 3; j = j + 1) begin
            check_grid("E05a still on 5px grid", j);
            check_not_in_wall("E05b body on passable tiles", j);
        end

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule

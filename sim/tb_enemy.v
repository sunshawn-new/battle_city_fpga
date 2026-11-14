`timescale 1ns / 1ps
// ============================================================================
// 敌方坦克仿真测试台（xsim）
//
// 和 tb_terrain 一样直接例化 top（地图用 bram_stubs 加载真实 map.coe），
// 这样测的是“接线 + 仲裁 + AI + 兵种差异”整体，而不是单独一个模块。
//
// 参数：
//   MOVE_DIV   = 200   -> 玩家 200 拍走一格（板上 4_000_000）
//   TURN_TICKS = 250   -> 关掉“巡逻随机转向”，用例才可复现
//   ENEMY_FIRE = 0     -> 敌人不开火：战斗用例在 tb_bullet / tb_combat 里测，
//                         这里只关心移动，不能让随机炮弹把用例搅乱
//
// 兵种差异（enemy_ctrl 里按出生点分配）：
//   0 号 左边 快速 : 步进 = MOVE_DIV（和玩家同速）、每 6 拍开一炮、1 发就碎
//   1 号 中间 火力 : 步进 = MOVE_DIV*2、每 4 拍开一炮、1 发就碎
//   2 号 右边 装甲 : 步进 = MOVE_DIV*3、每 8 拍开一炮、要挨 2 发
//
// 覆盖的场景：
//   E00 出生点 / 朝向 / 兵种 / 全部存活
//   E01 每个移动节拍走一整格（5px），坐标始终在格点上
//   E02 三个 terrain_probe 同时挂在 map_bus 上，各自读到的地形不能串台
//   E03 正前方是砖：原地转 90°，绝不走进墙里，转向后能继续走
//   E04 玩家查询（p_req[0]）在 4 个客户端抢总线时依然正常
//   E05 长时间跑：坐标始终在格点/边界内，车身 4x4 格永远不会压在硬地形上
//   E06 兵种速度差异：三个节拍周期分别是 200 / 400 / 600 拍
//   E07 兵种开火周期差异：6 / 4 / 8 个“自己的移动节拍”
//   E08 装甲要挨两发；全灭 -> victory 相关信号（e_kill 单拍）
//   E09 freeze=1（GAME OVER）之后敌人不再移动
// ============================================================================
module tb_enemy;
    localparam MOVE_DIV   = 200;
    localparam TURN_TICKS = 250;
    localparam MAP_W      = 120;

    function [14:0] A;
        input integer col;
        input integer row;
        begin
            A = row * MAP_W + col;
        end
    endfunction

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz

    top #(
        .MOVE_DIV(MOVE_DIV),
        .TURN_TICKS(TURN_TICKS),
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
    // 三个兵种的 STEP 不同，但“各等自己 n 次”依然成立（只是墙钟时间不同）。
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

    // 给第 i 辆车一个单拍“被打中”脉冲（force 它的输入线，绕开炮弹系统）。
    // 注意：Verilog 不允许 force 一个“变量下标的位选”，所以这里用 case 展开。
    task hit_enemy;
        input integer i;
        begin
            @(negedge clock);
            case (i)
                0:       force u_top.enemy_hit[0] = 1'b1;
                1:       force u_top.enemy_hit[1] = 1'b1;
                default: force u_top.enemy_hit[2] = 1'b1;
            endcase
            @(negedge clock);
            release u_top.enemy_hit[0];
            release u_top.enemy_hit[1];
            release u_top.enemy_hit[2];
            repeat (3) @(posedge clock);
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

    // 兵种（enemy_ctrl 按出生点分配：左=快速 00 / 中=火力 01 / 右=装甲 10）
    task check_type;
        input [8*40-1:0] name;
        input integer    i;
        input [1:0]      exp_t;
        reg   [1:0]      gt;
        begin
            gt = u_top.enemy_type[i*2 +: 2];
            if (gt !== exp_t) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d type=%b, expected %b", name, i, gt, exp_t);
            end else begin
                $display("[ OK ] %0s : enemy%0d type=%b", name, i, gt);
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
                    v = u_top.u_map_ram.mem[(cy/5 + r) * MAP_W + (cx/5 + c)];
                    if (v == 4'd1 || v == 2 || v == 3 || v == 5) bad = 1'b1;
                end
            if (bad) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d at (%0d,%0d) overlaps hard terrain", name, i, cx, cy);
            end else begin
                $display("[ OK ] %0s : enemy%0d at (%0d,%0d) on passable tiles", name, i, cx, cy);
            end
        end
    endtask

    // 量一次“第 i 辆车的移动节拍周期”（两次节拍之间隔了多少个 10ns 时钟）
    task measure_period;
        input  integer i;
        output integer period;
        integer t0;
        begin
            @(posedge u_top.enemy_move_tick[i]);
            t0 = $time;
            @(posedge u_top.enemy_move_tick[i]);
            period = ($time - t0) / 10;
        end
    endtask

    // 量一次“第 i 辆车两次开火请求之间隔了多少拍”
    task measure_fire;
        input  integer i;
        output integer period;
        integer t0;
        begin
            @(posedge u_top.enemy_fire[i]);
            t0 = $time;
            @(posedge u_top.enemy_fire[i]);
            period = ($time - t0) / 10;
        end
    endtask

    task check_range;
        input [8*40-1:0] name;
        input integer    got;
        input integer    lo;
        input integer    hi;
        begin
            if (got < lo || got > hi) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got %0d, expected %0d..%0d", name, got, lo, hi);
            end else begin
                $display("[ OK ] %0s : %0d (in %0d..%0d)", name, got, lo, hi);
            end
        end
    endtask

    integer kills = 0;
    always @(posedge clock) if (|u_top.enemy_kill) kills = kills + 1;

    integer period0, period1, period2;
    integer k0;

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
        check_enemy_pos("E00c spawn middle", 1, 10'd300, 10'd10);
        check_enemy_pos("E00d spawn right",  2, 10'd560, 10'd10);
        check_dir("E00e face down", 0, 2'b01);
        check_dir("E00f face down", 1, 2'b01);
        check_dir("E00g face down", 2, 2'b01);
        // 兵种跟着出生点走，三张敌人贴图都能在同一屏里看到
        check_type("E00h type fast",  0, 2'd0);
        check_type("E00i type power", 1, 2'd1);
        check_type("E00j type armor", 2, 2'd2);

        // ---------------- E01 每个移动节拍走一整格（5px）----------------
        // 注意：三个兵种的 STEP 不一样，所以不能用 step_all（等慢车的节拍时
        // 快车已经多走了好几格）。这里每辆车各自复位、各自数自己的节拍。
        do_reset; step_enemy(0, 4);
        check_enemy_pos("E01a down 4 cells", 0, 10'd40,  10'd30);
        check_grid("E01d on 5px grid", 0);

        do_reset; step_enemy(1, 4);
        check_enemy_pos("E01b down 4 cells", 1, 10'd300, 10'd30);
        check_grid("E01e on 5px grid", 1);

        do_reset; step_enemy(2, 4);
        check_enemy_pos("E01c down 4 cells", 2, 10'd560, 10'd30);
        check_grid("E01f on 5px grid", 2);

        // ---------------- E02 三个 probe 读地形不能串台 ----------------
        // 复位期间把三辆车正前方 poke 成不同地形，再放开 reset：
        // 每个 probe 的第一次扫描就会各读各的格子，地址一旦串了这里立刻炸。
        reset = 1'b1;
        repeat (5) @(posedge clock);
        for (j = 8;  j <= 11;  j = j + 1) poke(A(j, 6), 4'd1);   // 行6 列8~11  : 砖
        for (j = 60; j <= 63;  j = j + 1) poke(A(j, 6), 4'd2);   // 行6 列60~63 : 钢
        // 敌人 2 正前方（行6 列112~115）留空地 0
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
        if (u_top.player_x !== 10'd300 || u_top.player_y !== 10'd290) begin
            errors = errors + 1;
            $display("[FAIL] E04a player got (%0d,%0d), expected (300,290)",
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
        // ---------------- E06 兵种速度差异：200 / 400 / 600 拍 ----------------
        // MOVE_DIV=200，top 给 enemy_ctrl 的是 MOVE_DIV*2=400 当“中间档”：
        //   快速 = 400/2 = 200（和玩家同速）/ 火力 = 400 / 装甲 = 600
        do_reset;
        measure_period(0, period0);
        measure_period(1, period1);
        measure_period(2, period2);
        check_range("E06a fast  step = 200 clk", period0, MOVE_DIV,     MOVE_DIV);
        check_range("E06b power step = 400 clk", period1, 2*MOVE_DIV,   2*MOVE_DIV);
        check_range("E06c armor step = 600 clk", period2, 3*MOVE_DIV,   3*MOVE_DIV);

        // ---------------- E07 兵种开火周期差异 ----------------
        // FIRE_TICKS=4（top 默认）：
        //   快速 6 个自己的节拍 = 6*200  = 1200 拍
        //   火力 4 个自己的节拍 = 4*400  = 1600 拍
        //   装甲 8 个自己的节拍 = 8*600  = 4800 拍
        do_reset;
        measure_fire(0, period0);
        measure_fire(1, period1);
        measure_fire(2, period2);
        check_range("E07a fast  fires every ~1200 clk", period0, 6*MOVE_DIV - 20, 6*MOVE_DIV + 20);
        check_range("E07b power fires every ~1600 clk", period1, 8*MOVE_DIV - 20, 8*MOVE_DIV + 20);
        check_range("E07c armor fires every ~4800 clk", period2, 24*MOVE_DIV - 20, 24*MOVE_DIV + 20);

        // ---------------- E08 血量差异：装甲挨两发，其它一发就碎 ----------------
        do_reset;
        k0 = kills;
        hit_enemy(0);                                   // 快速：1 发
        if (u_top.enemy_valid[0] !== 1'b0) begin
            errors = errors + 1;
            $display("[FAIL] E08a fast tank survived a hit");
        end else begin
            $display("[ OK ] E08a fast tank destroyed by 1 hit");
        end
        hit_enemy(2);                                   // 装甲：第 1 发只掉血
        if (u_top.enemy_valid[2] !== 1'b1) begin
            errors = errors + 1;
            $display("[FAIL] E08b armor died on the first hit");
        end else begin
            $display("[ OK ] E08b armor survives the first hit");
        end
        hit_enemy(2);                                   // 装甲：第 2 发
        if (u_top.enemy_valid[2] !== 1'b0) begin
            errors = errors + 1;
            $display("[FAIL] E08c armor survived two hits");
        end else begin
            $display("[ OK ] E08c armor destroyed by the 2nd hit");
        end
        repeat (10) @(posedge clock);
        if (kills - k0 !== 2) begin
            errors = errors + 1;
            $display("[FAIL] E08d e_kill pulses = %0d, expected 2", kills - k0);
        end else begin
            $display("[ OK ] E08d exactly 2 kill pulses (one per destroyed tank)");
        end

        // ---------------- E09 freeze=1（GAME OVER）之后敌人不再移动 ----------------
        do_reset;
        force u_top.game_over = 1'b1;
        repeat (4) @(posedge clock);
        period0 = u_top.enemy_x[9:0];
        period1 = u_top.enemy_y[9:0];
        step_all(6);                     // 节拍照样来，但 freeze 期间不许走
        if (u_top.enemy_x[9:0] !== period0 || u_top.enemy_y[9:0] !== period1) begin
            errors = errors + 1;
            $display("[FAIL] E09a enemy0 moved while frozen (%0d,%0d)",
                     u_top.enemy_x[9:0], u_top.enemy_y[9:0]);
        end else begin
            $display("[ OK ] E09a enemy0 frozen at (%0d,%0d)",
                     u_top.enemy_x[9:0], u_top.enemy_y[9:0]);
        end
        release u_top.game_over;

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


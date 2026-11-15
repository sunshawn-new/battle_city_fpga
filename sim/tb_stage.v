`timescale 1ns / 1ps
// ============================================================================
// 关卡与波次仿真测试台（xsim）：stage_ctrl.v + level_loader.v + 关卡 ROM
//
// 和 tb_enemy 一样直接例化 top，地图/关卡 ROM 都用 bram_stubs 从真实的
// map.coe / levels.coe 加载 —— 所以这里验的是“板上会发生什么”，
// 包括“换关后地图内容真的是第 2 关”这种光看代码看不出来的事。
//
// 参数都调小：
//   ENEMIES_PER_STAGE = 4    -> 开局 3 辆 + 补 1 辆就能打到 STAGE CLEAR
//   SPAWN_CYCLES      = 400  -> 补车间隔 400 拍（板上 3s）
//   CLEAR_CYCLES      = 60   -> 横幅 60 拍（板上 2s）
//   地图装载固定是 900 块 x 18 拍 ≈ 16200 拍（这个是硬件时间，改不了）
//
// 覆盖：
//   S01 复位：第 1 关、3 辆敌人已入场、本关剩余 6/4、兵种 F/P/A、出生点/朝向
//   S02 敌人被击毁 -> 空出槽位
//   S03 到点自动补车：兵种按队列（第 4 辆 = 本关配比里的第一辆，第 1 关是快速）
//   S04 本关打完 -> STAGE CLEAR 横幅 + 全场暂停
//   S05 换关：level 变 2、地图被重写成第 2 关（河道变成空地、钢板出现、基地台座）
//   S06 新关开局：玩家回出生点、3 辆敌人重新排一屏、队列重新计数
//   S07 GAME OVER 之后不再补车
//   S08 打完最后一关回到第 1 关（地图又变回第 1 关）
// ============================================================================
module tb_stage;
    localparam MOVE_DIV     = 200;
    localparam N_LEVELS     = 4;
    localparam ENEMIES      = 4;
    localparam SPAWN_CYCLES = 400;
    localparam CLEAR_CYCLES = 60;
    localparam MAP_W        = 120;

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
        .N_LEVELS(N_LEVELS),
        .ENEMIES_PER_STAGE(ENEMIES),
        .SPAWN_CYCLES(SPAWN_CYCLES),
        .CLEAR_CYCLES(CLEAR_CYCLES),
        .ENEMY_FIRE(0),
        .INVULN_CYCLES(0),
        .FX_DIV(8)
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
            repeat (200) @(posedge clock);   // 3 辆入场 + 4 个 probe 各扫一遍
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

    // 给第 i 辆敌人一个单拍“被打中”脉冲（绕开炮弹，和 tb_enemy 的做法一致）
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

    // 等 0 号槽被补上一辆新车（最多等 limit 拍），返回等待了多少拍。
    // 这里刻意用常量下标 enemy_valid[0]：变量下标在位选上虽然合法，
    // 但在 xsim 里配上 integer 形参容易读到 X，用例会“静默不生效”。
    task wait_slot0;
        input  integer limit;
        output integer waited;
        begin
            waited = 0;
            while (!u_top.enemy_valid[0] && waited < limit) begin
                @(posedge clock);
                waited = waited + 1;
            end
        end
    endtask

    // 等某个条件成立（超时也算过，由后面的 check 负责报错）
    task wait_level;
        input  integer lv;
        input  integer limit;
        begin
            k = 0;
            while (u_top.level !== lv && k < limit) begin
                @(posedge clock);
                k = k + 1;
            end
        end
    endtask

    task check_enemy_pos;
        input [8*40-1:0] name;
        input integer    i;
        input [9:0]      exp_x;
        input [9:0]      exp_y;
        begin
            if (u_top.enemy_x[i*10 +: 10] !== exp_x || u_top.enemy_y[i*10 +: 10] !== exp_y) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d at (%0d,%0d), expected (%0d,%0d)", name, i,
                         u_top.enemy_x[i*10 +: 10], u_top.enemy_y[i*10 +: 10], exp_x, exp_y);
            end else begin
                $display("[ OK ] %0s : enemy%0d at (%0d,%0d)", name, i, exp_x, exp_y);
            end
        end
    endtask

    task check_enemy_type;
        input [8*40-1:0] name;
        input integer    i;
        input [1:0]      exp_t;
        begin
            if (u_top.enemy_type[i*2 +: 2] !== exp_t) begin
                errors = errors + 1;
                $display("[FAIL] %0s : enemy%0d type=%b, expected %b", name, i,
                         u_top.enemy_type[i*2 +: 2], exp_t);
            end else begin
                $display("[ OK ] %0s : enemy%0d type=%b", name, i, exp_t);
            end
        end
    endtask

    // 读地图 RAM 的一格（bram_stubs 里的 mem 数组，板上就是 blk_mem_gen_0 的内容）
    task check_cell;
        input [8*46-1:0] name;
        input integer    col;
        input integer    row;
        input [3:0]      exp;
        reg   [3:0]      got;
        begin
            got = u_top.u_map_ram.mem[row * MAP_W + col];
            if (got !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : cell(%0d,%0d)=%0d, expected %0d", name, col, row, got, exp);
            end else begin
                $display("[ OK ] %0s : cell(%0d,%0d)=%0d", name, col, row, got);
            end
        end
    endtask
    initial begin
        $display("==============================================");
        $display(" tb_stage : level switching / enemy waves");
        $display("==============================================");

        // ---------------- S01 复位后的开局状态 ----------------
        do_reset;
        check_int("S01a level starts at 1",      u_top.level, 1);
        check_int("S01b 3 enemies on field",     u_top.enemy_valid, 3'b111);
        check_int("S01c enemies_left = 4",       u_top.enemies_left, ENEMIES);
        check_int("S01d hud_level = level",      u_top.u_vga.hud_level, 1);
        check_enemy_type("S01e slot0 = fast",  0, 2'd0);
        check_enemy_type("S01f slot1 = power", 1, 2'd1);
        check_enemy_type("S01g slot2 = armor", 2, 2'd2);
        check_enemy_pos("S01h spawn point", 0, 10'd40, 10'd10);
        check_enemy_pos("S01i spawn point", 1, 10'd300, 10'd10);
        check_enemy_pos("S01j spawn point", 2, 10'd560, 10'd10);

        // 第 1 关的地图（map.coe）在 (1,33) 是河
        check_cell("S01k level1 river at (1,33)", 1, 33, 4'd3);

        // ---------------- S02/S03 击毁 -> 到点补车 ----------------
        hit_enemy(0);
        check_int("S02a slot0 empty after kill", u_top.enemy_valid, 3'b110);
        k = u_top.u_stage_ctrl.spawn_timer;      // 补车要等这个计时器走到 0
        wait_slot0(SPAWN_CYCLES * 3, j);
        check_int("S03a slot0 refilled",         u_top.enemy_valid[0], 1);
        // 补车不是“死了立刻重生”，而是等到计时器下一次到点：
        // 等待拍数应该正好等于击毁时计时器的剩余值（±几拍）
        check_int("S03b refill waited for the timer",
                  ((j >= k - 2) && (j <= k + 8)) ? 1 : 0, 1);
        check_enemy_type("S03c 4th enemy = fast (L1 queue)", 0, 2'd0);
        check_enemy_pos("S03d back to spawn point", 0, 10'd40, 10'd10);
        check_int("S03e enemies_left = 3",       u_top.enemies_left, 3);

        // ---------------- S04 本关打完 -> STAGE CLEAR ----------------
        hit_enemy(0);                       // 快速：1 发
        hit_enemy(1);                       // 火力：1 发
        hit_enemy(2);                       // 装甲：第 1 发只掉血
        check_int("S04a armor still alive",  u_top.enemy_valid[2], 1);
        hit_enemy(2);                       // 装甲：第 2 发
        check_int("S04b all enemies gone",   u_top.enemy_valid, 3'b000);
        check_int("S04c stage clear banner", u_top.stage_clear, 1);
        check_int("S04d paused during banner", u_top.stage_paused, 1);

        // 换关会把整张地图重写一遍 —— 连右下角最后一格也得写。
        // 先把它改成“河”，装载后应该变回第 2 关的值（空地 0）。
        // 这条专治“最后一块的最后一个写周期被 wr_we 提前清掉”的 bug。
        @(negedge clock);
        u_top.u_map_ram.mem[119 * MAP_W + 119] = 4'd3;
        check_cell("S04e last cell poked to river", 119, 119, 4'd3);

        // ---------------- S05 换关：地图被重写成第 2 关 ----------------
        wait_level(2, 60000);
        check_int("S05a level -> 2",              u_top.level, 2);
        check_int("S05b banner off",              u_top.stage_clear, 0);
        check_int("S05c no longer paused",        u_top.stage_paused, 0);
        // 第 2 关：(1,33) 是空地（河往下挪了两块）；(21,25) 是钢板（第 5~6 块列的 SS）
        check_cell("S05d level2 no river at (1,33)", 1, 33, 4'd0);
        check_cell("S05e level2 steel at (21,25)",   21, 25, 4'd2);
        // 基地块展开：'H' 块在基地矩形外补砖 -> (56,118) 是砖
        check_cell("S05f base pedestal is brick",    56, 118, 4'd1);
        check_cell("S05g base itself is tile 5",     56, 112, 4'd5);
        check_cell("S05h last cell rewritten by loader", 119, 119, 4'd0);

        // ---------------- S06 新关开局 ----------------
        // level 一变就立刻检查会抢在 spawn 之前（开局那一屏是在接下来 3 拍里派出去的）
        repeat (10) @(posedge clock);
        check_int("S06a player back to centre",  u_top.player_x, 10'd300);
        check_int("S06b 3 enemies again",        u_top.enemy_valid, 3'b111);
        check_int("S06c enemies_left reset to 4", u_top.enemies_left, ENEMIES);
        check_enemy_type("S06d slot0 = fast again",  0, 2'd0);
        check_enemy_type("S06e slot1 = power again", 1, 2'd1);
        check_enemy_type("S06f slot2 = armor again", 2, 2'd2);
        check_enemy_pos("S06g back at spawn point 0", 0, 10'd40, 10'd10);

        // ---------------- S07 GAME OVER 之后不再补车 ----------------
        // 先打掉一辆空出槽位，再让 game_over=1：补车计时照样会到点，
        // 但 stage_ctrl 里 !game_over 不成立，所以永远不该再有新车。
        hit_enemy(1);
        check_int("S07a slot1 empty",               u_top.enemy_valid[1], 0);
        force u_top.game_over = 1'b1;
        repeat (SPAWN_CYCLES * 2) @(posedge clock);
        check_int("S07b no refill after game over", u_top.enemy_valid[1], 0);
        release u_top.game_over;

        // ---------------- S08 打完最后一关回到第 1 关 ----------------
        do_reset;
        check_int("S08a level back to 1 after reset", u_top.level, 1);
        // 把关卡号按到最后一关（地图还是第 2 关的内容，不影响流程判断）
        force u_top.u_stage_ctrl.level = 3'd4;
        repeat (4) @(posedge clock);
        hit_enemy(0);
        wait_slot0(SPAWN_CYCLES * 3, j);
        hit_enemy(0);
        hit_enemy(1);
        hit_enemy(2);
        hit_enemy(2);
        check_int("S08b last stage cleared",     u_top.stage_clear, 1);
        release u_top.u_stage_ctrl.level;        // 放掉强制，让装载完成时写入 1
        wait_level(1, 60000);
        check_int("S08c wrapped to level 1",     u_top.level, 1);
        check_cell("S08d level1 river is back",  1, 33, 4'd3);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


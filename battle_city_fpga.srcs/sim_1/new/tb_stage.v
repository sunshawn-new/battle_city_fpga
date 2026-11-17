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
//   S09 GAME OVER 后按 BTNC 重开：生命/分数/基地清零、地图重装、玩家回出生点
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
        integer n;
        begin
            reset = 1'b1;
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            repeat (10) @(posedge clock);
            reset = 1'b0;
            // 复位后先把第 1 关地图重新写进 BRAM（约 15k 拍，paused=1 全场冻结）。
            // 等装载完再数 200 拍：这段时间刚好够 3 辆车各派出去、probe 扫一遍，
            // 但不到一个敌人移动节拍（MOVE_DIV*2 = 400），所以坐标还在出生点。
            n = 0;
            while (u_top.stage_paused && n < 200000) begin
                @(posedge clock); n = n + 1;
            end
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

    // 等地图装载结束（paused 落回 0）：900 块 x 18 拍 ≈ 16200 拍。
    // 装载期间全场冻结，不等它就去测移动/坐标会全部读到“还没动”的状态。
    task wait_load;
        integer n;
        begin
            n = 0;
            while (u_top.stage_paused && n < 200000) begin
                @(posedge clock);
                n = n + 1;
            end
        end
    endtask

    // 给玩家一个单拍“被打中”脉冲（绕开炮弹，和 hit_enemy 一样直接捅 top 里的线）。
    // 这条线平时由 bullet_ctrl 驱动，force 会临时盖过它，release 就还给炮弹。
    task hit_player;
        begin
            @(negedge clock);
            force u_top.b_hit_player = 1'b1;
            @(negedge clock);
            release u_top.b_hit_player;
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
        check_enemy_pos("S01h spawn point", 0, 10'd40, 10'd0);
        check_enemy_pos("S01i spawn point", 1, 10'd300, 10'd0);
        check_enemy_pos("S01j spawn point", 2, 10'd560, 10'd0);

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
        check_enemy_pos("S03d back to spawn point", 0, 10'd40, 10'd0);
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
        // 第 2 关：(1,33) 是空地（第 2 关没有那条河）；(9,17) 是钢板
        // （level2.txt 第 4 行第 2 列的 'SS'，展开到 4x4 格 = 像素 8..11 x 16..19）
        check_cell("S05d level2 no river at (1,33)", 1, 33, 4'd0);
        check_cell("S05e level2 steel at (9,17)",     9, 17, 4'd2);
        // 基地块展开：'H' 块里基地本体是 4x4 格（= 鹰的 20x20 包围盒），
        // 外面套一圈 2 格（10px）厚的砖墙（上/左/右），环以外留空（0）。
        check_cell("S05f base shell is brick",      56, 114, 4'd1);
        check_cell("S05g base itself is tile 5",     58, 116, 4'd5);
        check_cell("S05h last cell rewritten by loader", 119, 119, 4'd0);

        // ---------------- S06 新关开局 ----------------
        // level 一变就立刻检查会抢在 spawn 之前（开局那一屏是在接下来 3 拍里派出去的）
        repeat (10) @(posedge clock);
        check_int("S06a player back to spawn",  u_top.player_x, 10'd200);
        check_int("S06b 3 enemies again",        u_top.enemy_valid, 3'b111);
        check_int("S06c enemies_left reset to 4", u_top.enemies_left, ENEMIES);
        check_enemy_type("S06d slot0 = fast again",  0, 2'd0);
        check_enemy_type("S06e slot1 = power again", 1, 2'd1);
        check_enemy_type("S06f slot2 = armor again", 2, 2'd2);
        check_enemy_pos("S06g back at spawn point 0", 0, 10'd40, 10'd0);

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

        // ---------------- S09 GAME OVER 之后按 BTNC 重开一局 ----------------
        // 这一条守的是“重开”整条链：BTNC 上升沿 -> restart_pulse -> sys_rst
        // （top 里的生命/分数/基地/敌人/炮弹/特效）+ stage_ctrl 推到 S_LOAD
        // （重新写第 1 关地图 + 玩家回出生点）。改之前 GAME OVER 是死锁的：
        // freeze=1 把所有人冻住，按复位键又只清寄存器不重装地图（BRAM 里
        // 留着打掉的砖），所以在板子上“重开”根本不好使。
        do_reset;
        check_int("S09a fresh game: level 1", u_top.level, 1);
        hit_enemy(0);                       // 快速：+100 分，顺便弄脏状态
        check_int("S09b score after one kill", u_top.score100, 1);
        // 把第 1 关的河挖掉：重开必须把它写回来（证明地图真的重装了）
        @(negedge clock);
        u_top.u_map_ram.mem[33 * MAP_W + 1] = 4'd0;
        check_cell("S09c river poked to empty", 1, 33, 4'd0);

        // 三条命依次打光：3 -> 2 -> 1 -> 0 并锁存 GAME OVER
        hit_player;
        check_int("S09d lives 3 -> 2", u_top.lives, 2);
        check_int("S09e respawn back at spawn", u_top.player_x, 10'd200);
        hit_player;
        check_int("S09f lives 2 -> 1", u_top.lives, 1);
        check_int("S09g not over yet", u_top.game_over, 0);
        hit_player;
        check_int("S09h lives = 0",         u_top.lives, 0);
        check_int("S09i game over latched", u_top.game_over, 1);
        // GAME OVER 期间全场冻结：玩家再按方向键也不动
        btn_left = 1'b1;
        repeat (MOVE_DIV * 2) @(posedge clock);
        btn_left = 1'b0;
        check_int("S09j player frozen on game over", u_top.player_x, 10'd200);

        // 按一下 BTNC（开火键）= 重开。只用上升沿，所以按一下、松手。
        // 必须在 negedge 改按键：如果和 posedge 同一个 delta 里把 btn_fire 抬起来，
        // top 里的 fire_d 可能在同一拍就采到 1，上升沿被“吃掉”（仿真特有的竞争）。
        @(negedge clock);
        btn_fire = 1'b1;
        repeat (2) @(posedge clock);
        @(negedge clock);
        btn_fire = 1'b0;
        repeat (4) @(posedge clock);

        check_int("S09k restart clears game over", u_top.game_over, 0);
        check_int("S09l lives restored",          u_top.lives, 3);   // LIVES_START
        check_int("S09m score cleared",           u_top.score100, 0);
        check_int("S09n base restored",           u_top.base_alive, 1);
        check_int("S09o map reload started (paused)", u_top.stage_paused, 1);

        wait_load;                          // 900 块 x 18 拍
        repeat (200) @(posedge clock);      // 3 辆入场 + probe 各扫一遍
        check_int("S09p level back to 1",   u_top.level, 1);
        check_int("S09q no longer paused",  u_top.stage_paused, 0);
        check_cell("S09r level1 map rewritten (river back)", 1, 33, 4'd3);
        check_int("S09s player back to spawn x", u_top.player_x, 10'd200);
        check_int("S09t player back to spawn y", u_top.player_y, 10'd560);
        check_int("S09u 3 enemies again",        u_top.enemy_valid, 3'b111);
        check_int("S09v enemies_left reset to 4", u_top.enemies_left, ENEMIES);
        check_enemy_pos("S09w enemy0 back at spawn", 0, 10'd40, 10'd0);
        check_int("S09x can play again (not frozen)", u_top.freeze, 0);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


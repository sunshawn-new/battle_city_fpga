`timescale 1ns / 1ps
// ============================================================================
// 关卡流程仿真测试台（xsim）：生命 / 复活无敌 / 分数 / GAME OVER / VICTORY
//
// 这一层测的是 top.v 里的“打法状态机”，不测弹道（弹道在 tb_bullet 里）。
// 触发的办法是直接 force 炮弹系统的输出（b_hit_player / enemy_kill / enemy_valid /
// b_base_hit）：等于让“炮弹打中了”这件事单拍发生，然后看 top 的状态怎么走。
// 这样用例与地图、AI、时序全都解耦，改玩区/改 AI 都不用改这里。
//
// 用例编号：
//   C01 复位初值        C02 挨打扣命 + 复活 + 无敌   C03 无敌期间免疫
//   C04 命耗尽 GAME OVER C05 GAME OVER 后冻结        C06 基地被打爆
//   C07 击杀分数        C08 STAGE CLEAR 横幅         C09 敌人爆炸位置
//   C10 玩家爆炸位置    C11 无敌期间闪烁（player_hide）
// ============================================================================
module tb_combat;
    localparam MOVE_DIV      = 200;
    localparam INVULN_CYCLES = 40;          // 板上 1 亿，仿真里缩到 40 拍
    localparam FX_DIV        = 8;           // 爆炸每个相位 8 拍（板上 8M = 80ms）

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz

    top #(
        .MOVE_DIV(MOVE_DIV),
        .ENEMY_FIRE(0),
        .INVULN_CYCLES(INVULN_CYCLES),
        .LIVES_START(3),
        .FX_DIV(FX_DIV)
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
            // 复位后 stage_ctrl 会把第 1 关地图重新写进 BRAM（约 15k 拍），
            // 期间 paused=1、全场冻结。等它装完再往下跑，否则后面的移动用例全动不了。
            n = 0;
            while (u_top.stage_paused && n < 200000) begin
                @(posedge clock); n = n + 1;
            end
            repeat (100) @(posedge clock);
        end
    endtask

    // 玩家挨一发：单拍 force 炮弹系统的报告线
    task player_hit;
        begin
            @(negedge clock);
            force u_top.b_hit_player = 1'b1;
            @(negedge clock);
            release u_top.b_hit_player;
            repeat (4) @(posedge clock);
        end
    endtask

    // 基地挨一发
    task base_hit;
        begin
            @(negedge clock);
            force u_top.b_base_hit = 1'b1;
            @(negedge clock);
            release u_top.b_base_hit;
            repeat (4) @(posedge clock);
        end
    endtask

    // 第 i 辆敌人被击毁（i = 0 快速 / 1 火力 / 2 装甲）
    task kill_enemy;
        input integer i;
        begin
            @(negedge clock);
            case (i)
                0:       force u_top.enemy_kill = 3'b001;
                1:       force u_top.enemy_kill = 3'b010;
                default: force u_top.enemy_kill = 3'b100;
            endcase
            @(negedge clock);
            release u_top.enemy_kill;
            repeat (4) @(posedge clock);
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

    task check_pos;
        input [8*46-1:0] name;
        input [9:0] exp_x;
        input [9:0] exp_y;
        begin
            if (u_top.player_x !== exp_x || u_top.player_y !== exp_y) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got (%0d,%0d), expected (%0d,%0d)",
                         name, u_top.player_x, u_top.player_y, exp_x, exp_y);
            end else begin
                $display("[ OK ] %0s : (%0d,%0d)", name, u_top.player_x, u_top.player_y);
            end
        end
    endtask

    initial begin
        $display("=========== level flow test (lives / score / game over) ===========");

        // ---------------- C01 复位初值 ----------------
        do_reset;
        check_int("C01a lives start at 3", u_top.lives, 3);
        check_int("C01b score starts at 0", u_top.score100, 0);
        check_int("C01c not game over",     u_top.game_over, 0);
        check_pos("C01d player at spawn", 10'd200, 10'd560);

        // ---------------- C02 挨一发：扣命 + 复活回出生点 + 进入无敌 ----------------
        btn_right = 1'b1;
        repeat (MOVE_DIV * 3) @(posedge clock);     // 走 3 格
        btn_right = 1'b0;
        repeat (10) @(posedge clock);
        check_pos("C02a moved away from spawn", 10'd215, 10'd560);

        player_hit;
        check_int("C02b lives 3 -> 2", u_top.lives, 2);
        check_pos("C02c respawn at spawn", 10'd200, 10'd560);
        if (u_top.player_invuln !== 1'b1) begin
            errors = errors + 1;
            $display("[FAIL] C02d no invulnerability after respawn");
        end else begin
            $display("[ OK ] C02d invulnerable after respawn");
        end

        // ---------------- C03 无敌期间再挨打不算 ----------------
        player_hit;
        check_int("C03a lives still 2 while invulnerable", u_top.lives, 2);

        // ---------------- C04 无敌结束后连挨两发 -> 命耗尽 -> GAME OVER ----------------
        repeat (INVULN_CYCLES + 10) @(posedge clock);
        player_hit;
        check_int("C04a lives 2 -> 1", u_top.lives, 1);
        repeat (INVULN_CYCLES + 10) @(posedge clock);
        player_hit;
        check_int("C04b lives 1 -> 0", u_top.lives, 0);
        check_int("C04c game over when lives run out", u_top.game_over, 1);

        // ---------------- C05 GAME OVER 之后玩家被冻结 ----------------
        k = u_top.player_x;
        btn_right = 1'b1;
        repeat (MOVE_DIV * 3) @(posedge clock);
        btn_right = 1'b0;
        if (u_top.player_x !== k[9:0]) begin
            errors = errors + 1;
            $display("[FAIL] C05 player moved after game over (%0d -> %0d)",
                     k, u_top.player_x);
        end else begin
            $display("[ OK ] C05 player frozen after game over at x=%0d", u_top.player_x);
        end

        // ---------------- C06 基地被打爆 -> GAME OVER + 白旗贴图 ----------------
        do_reset;
        base_hit;
        check_int("C06a base destroyed", u_top.base_alive, 0);
        check_int("C06b hq_destroyed=1", u_top.u_vga.hq_destroyed, 1);
        check_int("C06c game over on base loss", u_top.game_over, 1);

        // ---------------- C07 分数：100 / 200 / 300 ----------------
        do_reset;
        kill_enemy(0);
        check_int("C07a fast kill -> 100 pts", u_top.score100, 1);
        kill_enemy(1);
        check_int("C07b power kill -> +200",   u_top.score100, 3);
        kill_enemy(2);
        check_int("C07c armor kill -> +300",   u_top.score100, 6);

        // ---------------- C08 本关打完 -> STAGE CLEAR 横幅 ----------------
        // 关卡判定（队列空 + 场上没人）在 stage_ctrl 里，tb_stage 专门测它；
        // 这里只验 top 把这个信号一路接到了 HUD 的横幅上。
        do_reset;
        force u_top.u_stage_ctrl.stage_clear = 1'b1;
        repeat (4) @(posedge clock);
        check_int("C08a stage clear banner reaches HUD", u_top.u_vga.hud_victory, 1);
        release u_top.u_stage_ctrl.stage_clear;

        // ---------------- C09 敌人被击毁 -> 在死亡位置开一个爆炸 ----------------
        // 爆炸槽 3 是“一键分配”里的最高槽（只有这一个请求时一定落在槽 3）。
        do_reset;
        force u_top.enemy_terrain_valid = 3'b000;   // 冻住敌人移动，坐标才是确定的
        repeat (4) @(posedge clock);
        k = u_top.enemy_x[0*10 +: 10];
        j = u_top.enemy_y[0*10 +: 10];
        kill_enemy(0);
        check_int("C09a explosion started on kill", (u_top.fx_valid != 4'd0), 1);
        check_int("C09b explosion x = dead tank x", u_top.fx_x[3*10 +: 10], k);
        check_int("C09c explosion y = dead tank y", u_top.fx_y[3*10 +: 10], j);
        repeat (FX_DIV * 6 + 4) @(posedge clock);   // 6 个相位走完
        check_int("C09d explosion released", (u_top.fx_valid != 4'd0), 0);
        release u_top.enemy_terrain_valid;

        // ---------------- C10 玩家中弹 -> 爆炸落在死亡位置（不是出生点）----------------
        // 这条用例守的是 fx_ctrl 的采样时机：玩家挨打后下一拍就被 respawn 拉回出生点 (200,560)，
        // 如果爆炸的坐标晚一拍采样，就会跑回出生点。
        do_reset;
        btn_right = 1'b1;
        repeat (MOVE_DIV * 3) @(posedge clock);
        btn_right = 1'b0;
        repeat (10) @(posedge clock);
        player_hit;
        check_int("C10a lives 3 -> 2",            u_top.lives,    2);
        check_int("C10b respawn back to spawn",   u_top.player_x, 10'd200);
        check_int("C10c explosion x = death pos", u_top.fx_x[3*10 +: 10], 10'd215);
        check_int("C10d explosion y = death pos", u_top.fx_y[3*10 +: 10], 10'd560);

        // ---------------- C11 无敌期间车身闪烁（player_hide）----------------
        // top.v 里 player_blink = player_invuln & blink_cnt[22]，
        // vga.v 用 player_hide_q 把玩家坦克藏起来 —— 玩家一眼就能看出“现在打不中我”。
        // blink_cnt 在板上一拍 10ns、2^22 拍 ≈ 42ms，仿真里等不到那么久，直接 force 它。
        // 注意：xsim 不允许对 reg 的位选 force（VRFC 10-3149），所以整根 23 位一起写，
        // 让第 22 位当“亮/灭”开关。
        do_reset;
        player_hit;                                     // 扣一条命 -> 进入无敌
        if (u_top.player_invuln !== 1'b1) begin
            errors = errors + 1;
            $display("[FAIL] C11a not invulnerable, cannot test the blink");
        end else begin
            $display("[ OK ] C11a invulnerable after respawn");
        end
        force u_top.blink_cnt = 23'h400000;             // bit22 = 1 -> 灭
        repeat (2) @(posedge clock);
        check_int("C11b blink phase = hide", u_top.player_blink, 1);
        check_int("C11c vga hides the tank", u_top.u_vga.player_hide_q, 1);
        force u_top.blink_cnt = 23'h000000;             // bit22 = 0 -> 亮
        repeat (2) @(posedge clock);
        check_int("C11d blink phase = show", u_top.player_blink, 0);
        check_int("C11e vga draws the tank", u_top.u_vga.player_hide_q, 0);
        // 无敌结束后，即使日志位是 1 也不能再藏（否则复活保护结束后车会半透明）
        repeat (INVULN_CYCLES + 10) @(posedge clock);
        force u_top.blink_cnt = 23'h400000;
        repeat (2) @(posedge clock);
        check_int("C11f no hide after invuln ends", u_top.player_blink, 0);
        release u_top.blink_cnt;

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


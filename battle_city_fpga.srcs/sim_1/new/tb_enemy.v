`timescale 1ns / 1ps
// ============================================================================
// 敌方坦克仿真测试台（xsim）
//
// 和 tb_terrain 一样直接例化 top（地图用 bram_stubs 加载真实 map.coe），
// 这样测的是“接线 + 仲裁 + AI + 兵种差异”整体，而不是单独一个模块。
//
// 参数：
//   MOVE_DIV   = 200   -> 玩家 200 拍走一格（板上 4_000_000）
//   TURN_TICKS = 250   -> 拉长“巡逻重选向”周期，用例只关心前几拍的转向，可复现
//   ENEMY_FIRE = 0     -> 敌人不开火：战斗用例在 tb_bullet / tb_combat 里测，
//                         这里只关心移动，不能让随机炮弹把用例搅乱
//
// 兵种差异（enemy_ctrl 里按出生点分配）：
//   0 号 左边 快速 : 步进 = MOVE_DIV（和玩家同速）、每 6 拍开一炮、1 发就碎
//   1 号 中间 火力 : 步进 = MOVE_DIV*2、每 4 拍开一炮、1 发就碎
//   2 号 右边 装甲 : 步进 = MOVE_DIV*3、每 8 拍开一炮、要挨 2 发
//
// 覆盖的场景：
//   E00 出生点 / 朝向 / 兵种 / 全部存活（(40,0)/(300,0)/(560,0)，贴最上面一块）
//   E01 每个移动节拍走一整格（5px），坐标始终在格点上
//   E02 三个 terrain_probe 同时挂在 map_bus 上，各自读到的地形不能串台
//   E03 正前方是砖：不撞墙，且第一个尝试的方向是“朝基地”（不是随机乱转）
//   E04 玩家查询（p_req[0]）在 4 个客户端抢总线时依然正常
//   E05 长时间跑：坐标始终在格点/边界内，车身 4x4 格永远不会压在硬地形上
//   E06 兵种速度差异：三个节拍周期分别是 200 / 400 / 600 拍
//   E07 兵种开火周期差异：6 / 4 / 8 个“自己的移动节拍”
//   E08 装甲要挨两发；全灭 -> victory 相关信号（e_kill 单拍）
//   E09 freeze=1（GAME OVER）之后敌人不再移动
//   E10 四面都不通的口袋：四方向试错按固定顺序循环（顶边也算墙，不会钉死）
//   E11 互斥端口接线：player <- enemy 的坐标、enemy <- player 的坐标都在 top 里接上
//   E12 tank_block 单元测试：20x20 包围盒的“贴边不算重叠 / 5px 就算重叠”
//   E13 集成：玩家挡在下坡通道里，敌人开不过来（不会穿模），玩家让开就能过
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

    // 关卡 ROM 里的“块地址”：第 1 关的基址是 0，一块 = 4x4 格 = 20x20 像素。
    // 复位期间改这里 -> level_loader 会把改过的块展开写进地图 RAM，
    // 于是敌人出场后的第一次地形扫描就已经看到改过的地图（没有“上一拍旧值”的问题）。
    function [11:0] BR;
        input integer bx;      // 块列 0..29
        input integer by;      // 块行 0..29
        begin
            BR = by * 30 + bx;
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
    integer i10, n_chg, n_up, n_dn, n_lf, n_rt;   // E10：方向试错的采样统计
    reg [1:0] prev_dir, got_dir;                  // E10：方向切换的比对
    reg ok_pair;

    task do_reset;
        begin
            reset = 1'b1;
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            repeat (10) @(posedge clock);
            reset = 1'b0;
            // 复位后 stage_ctrl 走 S_LOAD：level_loader 要把第 1 关地图整张重写一遍
            // （900 块 x 18 拍 ≈ 16200 拍）。这段期间 paused=1，玩家/敌人/炮弹全冻结，
            // 敌人的 probe 也一直在复位。必须等它装完才能看到真实地形。
            wait_load;
            // 敌人出场是 paused 落下之后的头几拍，再给 probe 留一轮扫描时间，
            // 这样后面“敌人是不是已经动了”的判断才有意义。
            repeat (150) @(posedge clock);
        end
    endtask

    // 等地图装载结束（stage_paused 落回 0）。冷启动/重开都会走这一趟。
    task wait_load;
        integer n;
        begin
            n = 0;
            while (u_top.stage_paused && n < 200000) begin
                @(posedge clock); n = n + 1;
            end
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

    // 改关卡 ROM 的块图（只在 reset=1 期间用，装载器会把它展开写进地图）
    task poke_blk;
        input [11:0] idx;
        input [3:0]  val;
        begin
            @(negedge clock);
            u_top.u_level_rom.mem[idx] = val;
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

    // ---------------- E12 用到的 tank_block 单元（纯组合，不接 top）----------------
    // 直接搭一份独立实例，把候选坐标 / 障碍物坐标手工喂进去，
    // 这样“重叠”的判定边界（贴边 vs 5px）可以逐个点验证，不依赖地图和 AI。
    reg  [9:0] ub_cx, ub_cy;
    reg  [3:0] ub_v;
    reg [39:0] ub_x, ub_y;
    wire       ub_blocked;

    tank_block #(.N(4)) u_blk_ut (
        .cx(ub_cx), .cy(ub_cy),
        .o_valid(ub_v), .o_x(ub_x), .o_y(ub_y), .blocked(ub_blocked)
    );

    // 设好一组输入 -> 等 1ns（组合逻辑稳定）-> 比对 blocked
    // 障碍物 i 的坐标 / 在场位用“第 i 个槽”的 10 位片段传，未用到的槽给 0 / 不在场。
    task blk_check;
        input [8*46-1:0] name;
        input [9:0]      cx, cy;
        input [3:0]      v;
        input [39:0]     ox, oy;
        input            exp;
        begin
            ub_cx = cx; ub_cy = cy; ub_v = v; ub_x = ox; ub_y = oy;
            #1;
            if (ub_blocked !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : blocked=%b, expected %b (cand %0d,%0d)",
                         name, ub_blocked, exp, cx, cy);
            end else begin
                $display("[ OK ] %0s : blocked=%b", name, ub_blocked);
            end
        end
    endtask

    // 把 4 个障碍物都设成“不在场”，只改动其中指定的槽（省得每次都写 40 位常量）
    task blk_case;
        input [8*46-1:0] name;
        input [9:0]      cx, cy;      // 本车候选位置
        input integer    slot;        // 障碍物放在第几个槽（0..3）
        input [9:0]      ox, oy;      // 障碍物坐标
        input            valid;       // 障碍物是否在场
        input            exp;
        reg [39:0] vx, vy;
        reg [3:0]  vv;
        begin
            vx = 40'd0; vy = 40'd0; vv = 4'd0;
            vx[slot*10 +: 10] = ox;
            vy[slot*10 +: 10] = oy;
            vv[slot]          = valid;
            blk_check(name, cx, cy, vv, vx, vy, exp);
        end
    endtask


    integer kills = 0;
    always @(posedge clock) if (|u_top.enemy_kill) kills = kills + 1;

    integer period0, period1, period2;
    integer k0;
    integer exv, eyv, dxv, dyv;      // E13：敌人/玩家坐标差的绝对值（32 位有符号算，避免 10 位回绕）

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
        check_enemy_pos("E00b spawn left",   0, 10'd40,  10'd0);
        check_enemy_pos("E00c spawn middle", 1, 10'd300, 10'd0);
        check_enemy_pos("E00d spawn right",  2, 10'd560, 10'd0);
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
        check_enemy_pos("E01a down 4 cells", 0, 10'd40,  10'd20);
        check_grid("E01d on 5px grid", 0);

        do_reset; step_enemy(1, 4);
        check_enemy_pos("E01b down 4 cells", 1, 10'd300, 10'd20);
        check_grid("E01e on 5px grid", 1);

        do_reset; step_enemy(2, 4);
        check_enemy_pos("E01c down 4 cells", 2, 10'd560, 10'd20);
        check_grid("E01f on 5px grid", 2);

        // ---------------- E02 三个 probe 读地形不能串台 ----------------
        // 复位期间直接改关卡 ROM 的块图，装载器会把这三块展开写进地图 RAM：
        //   块(2,1)  -> 0 号车（x=40，格列 8~11）正前方 4 格全是砖
        //   块(15,1) -> 1 号车（x=300，格列 60~63）正前方 4 格全是钢
        //   块(28,1) -> 2 号车（x=560，格列 112~115）不 poke，保持空地
        // 这样三辆车出场后的第一次扫描就各读各的格子，地址一旦串了这里立刻炸。
        // （在 reset 期间改 ROM 而不是改地图 RAM：场地是在装载时才写进去的，
        //   装载完再 poke 会让第一拍用“上一拍读到的旧地形”，逻辑上不干净。）
        reset = 1'b1;
        repeat (5) @(posedge clock);
        poke_blk(BR(2,  1), 4'd1);      // 砖
        poke_blk(BR(15, 1), 4'd2);      // 钢
        reset = 1'b0;
        wait_load;
        repeat (150) @(posedge clock);          // 装载完 + 3 个 probe 各扫一遍
        check_front("E02a front=brick", 0, 4'd1);
        check_front("E02b front=steel", 1, 4'd2);
        check_front("E02c front=empty", 2, 4'd0);
        check_enemy_pos("E02d no move before tick", 0, 10'd40, 10'd0);

        // ---------------- E03 前面是砖：不撞墙，循环转动找路 ----------------
        // 车在 (40,0)，基地在 x=300（右侧）、y=560（下方）：want=下。前面（下）是砖，
        // 左/上/右三面里左侧是 40px 的开阔地。循环转动：朝基地 -> 顺时针90° -> 180°
        // -> 270°：
        //   拍1 朝基地=下（还是砖）  拍2 顺时针90°=左（空地）  拍3 走出去
        // 旧版“贴墙滑 + 换边”在这里右左对消、原地 ±5px 抖；新版单向旋转必然脱困。
        step_enemy(0, 1);
        check_dir("E03a rot0 want_dir (down)", 0, 2'b01);
        check_enemy_pos("E03b not inside brick", 0, 10'd40, 10'd0);

        step_enemy(0, 1);
        check_dir("E03c rot1 turns 90cw (left)", 0, 2'b10);
        check_enemy_pos("E03d still at spawn while rotating", 0, 10'd40, 10'd0);

        step_enemy(0, 1);
        check_enemy_pos("E03e escaped left after rotation", 0, 10'd35, 10'd0);

        step_enemy(0, 1);
        check_enemy_pos("E03f keeps rolling left", 0, 10'd30, 10'd0);
        check_not_in_wall("E03g body not on brick", 0);
        check_grid("E03h on 5px grid", 0);

        // ---------------- E04 玩家在 4 个客户端抢总线时依然正常 ----------------
        do_reset;
        btn_up = 1'b1;
        step_player(10);
        btn_up = 1'b0;
        if (u_top.player_x !== 10'd200 || u_top.player_y !== 10'd550) begin
            errors = errors + 1;
            $display("[FAIL] E04a player got (%0d,%0d), expected (200,550)",
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

        // ---------------- E10 四面是墙的口袋：四方向试错必须全覆盖 ----------------
        // 0 号车出生在 (40,0)（车身 = 格列 8~11 x 格行 0~3）。用关卡 ROM 给它造一个
        // “看起来上面是空的、其实是画面外”的口袋：
        //   下：块(2,1) 砖（E02 已经注过，这里再写一次，让本用例不依赖执行顺序）
        //   左：块(1,0) 砖（格列 7）      右：块(3,0) 砖（格列 12）
        //   上：y = 0 -> 车身已经贴住画面顶边，外面那行不存在
        // 撞墙后的循环转动是 朝基地(下) -> 顺时针90°(左) -> 逆时针90°(右) -> 180°(上)
        // -> 回到朝基地……，dir 的周期是 4 拍：
        //   下 -> 左 -> 右 -> 上 -> 下 -> ...（位置一步不动）。
        // 【这条用例守着 terrain_probe 的一个坑】：越界的“前方行列”如果被夹回
        // 车身自己身上（y=0 朝上时 g_front_up 夹到第 0 行），probe 会报“空地”，
        // 车于是选“上”、发现 y==0 走不动 —— 永远钉在顶边朝上。
        reset = 1'b1;
        repeat (5) @(posedge clock);
        poke_blk(BR(2, 1), 4'd1);       // 下
        poke_blk(BR(1, 0), 4'd1);       // 左
        poke_blk(BR(3, 0), 4'd1);       // 右
        reset = 1'b0;
        wait_load;
        repeat (150) @(posedge clock);  // 装载完 + probe 扫一遍
        check_enemy_pos("E10a trapped at spawn", 0, 10'd40, 10'd0);
        // 采样 40 个移动节拍，只看“方向发生切换”的那些拍（probe 重扫时会有一拍
        // 不切换，属于正常现象）。要求：
        //   ① 切换次数够多 —— 旧版撞到顶边会永远朝上（stuck 被清零），几乎不切换；
        //   ② 每次切换都必须是固定的四种试探顺序里的相邻两态；
        //   ③ 四个方向都被试到过。
        n_chg = 0; n_up = 0; n_dn = 0; n_lf = 0; n_rt = 0;
        step_enemy(0, 1);                       // 先走一拍，进入“卡住后的试错”状态
        prev_dir = u_top.enemy_dir[1:0];
        for (i10 = 0; i10 < 40; i10 = i10 + 1) begin
            step_enemy(0, 1);
            got_dir = u_top.enemy_dir[1:0];
            if (got_dir !== prev_dir) begin
                n_chg = n_chg + 1;
                case (got_dir)
                    2'b00: n_up = n_up + 1;
                    2'b01: n_dn = n_dn + 1;
                    2'b10: n_lf = n_lf + 1;
                    default: n_rt = n_rt + 1;
                endcase
                // 允许的相邻两态（循环转动：朝基地 -> 顺时针90° -> 逆时针90° -> 180°；
                // 对 want=下 而言序列是 下 -> 左 -> 右 -> 上 -> 下 ...，全是 90°/180° 的
                // 相位跳变）。真正钉死行为的是下面三条：切换够多 / 四方向全覆盖 / 位置不动。
                case ({prev_dir, got_dir})
                    4'b0110, 4'b1011, 4'b1100, 4'b0001: ok_pair = 1'b1;   // 下->左 左->右 右->上 上->下
                    default:                           ok_pair = 1'b0;
                endcase
                if (!ok_pair) begin
                    errors = errors + 1;
                    $display("[FAIL] E10b illegal turn %b -> %b (four-way trial order)", prev_dir, got_dir);
                end
                prev_dir = got_dir;
            end
        end
        if (n_chg < 12) begin
            errors = errors + 1;
            $display("[FAIL] E10c only %0d turns in 40 ticks -> tank is pinned (top edge not treated as wall?)", n_chg);
        end else begin
            $display("[ OK ] E10c %0d turns in 40 ticks", n_chg);
        end
        if (n_up == 0 || n_dn == 0 || n_lf == 0 || n_rt == 0) begin
            errors = errors + 1;
            $display("[FAIL] E10d four-way trial coverage: up=%0d down=%0d left=%0d right=%0d",
                     n_up, n_dn, n_lf, n_rt);
        end else begin
            $display("[ OK ] E10d all four directions tried: up=%0d down=%0d left=%0d right=%0d",
                     n_up, n_dn, n_lf, n_rt);
        end
        check_enemy_pos("E10e still trapped (no wall punched through)", 0, 10'd40, 10'd0);
        check_not_in_wall("E10f body on passable tiles", 0);

        // ---------------- E11 坦克互斥的接线 ----------------
        // 两处连线是“穿模修复”的一半工作量，接错一头编译照样过：
        //   top: .p_x(player_x) / .p_y(player_y)          -> enemy_ctrl 看到玩家在哪
        //   top: .blk_valid(enemy_valid) / .blk_x(enemy_x) / .blk_y(enemy_y) -> player 看到敌人
        // 这里直接比顶层网线（同一根线，比较的是“有没有接/接错”）。
        @(negedge clock);
        if (u_top.u_enemy_ctrl.p_x !== u_top.player_x ||
            u_top.u_enemy_ctrl.p_y !== u_top.player_y) begin
            errors = errors + 1;
            $display("[FAIL] E11a enemy_ctrl.p_x/p_y not wired to player_x/y (%0d,%0d vs %0d,%0d)",
                     u_top.u_enemy_ctrl.p_x, u_top.u_enemy_ctrl.p_y,
                     u_top.player_x, u_top.player_y);
        end else begin
            $display("[ OK ] E11a enemy_ctrl sees the player at (%0d,%0d)",
                     u_top.player_x, u_top.player_y);
        end
        if (u_top.u_player.blk_valid !== u_top.enemy_valid ||
            u_top.u_player.blk_x     !== u_top.enemy_x     ||
            u_top.u_player.blk_y     !== u_top.enemy_y) begin
            errors = errors + 1;
            $display("[FAIL] E11b player.blk_* not wired to enemy_valid/x/y");
        end else begin
            $display("[ OK ] E11b player sees the %0d enemy boxes", 3);
        end
        // 玩家侧四个方向各有一份判定实例：哪一根漏接，那个方向就能穿过敌人。
        if (u_top.u_player.u_blk_up.o_valid !== u_top.enemy_valid ||
            u_top.u_player.u_blk_dn.o_valid !== u_top.enemy_valid ||
            u_top.u_player.u_blk_lf.o_valid !== u_top.enemy_valid ||
            u_top.u_player.u_blk_rt.o_valid !== u_top.enemy_valid) begin
            errors = errors + 1;
            $display("[FAIL] E11c one of the 4 player tank_block instances is not wired to blk_valid");
        end else begin
            $display("[ OK ] E11c all 4 player tank_block instances see blk_valid");
        end

        // ---------------- E12 tank_block 单元测试 ----------------
        // 判据：车身 20x20，两个车身“重叠”等价于 |dx| < 20 && |dy| < 20。
        // 贴边（dx 或 dy 正好 = 20）必须放行，否则两辆车并排站着都会互相挡。
        blk_case("E12a tail-to-nose (dy=20) ok",  10'd100, 10'd120, 0, 10'd100, 10'd100, 1'b1, 1'b0);
        blk_case("E12b overlap 5px (dy=15)",      10'd100, 10'd115, 0, 10'd100, 10'd100, 1'b1, 1'b1);
        blk_case("E12c nose into tail (dy=-15)",  10'd100, 10'd85,  0, 10'd100, 10'd100, 1'b1, 1'b1);
        blk_case("E12d side-by-side (dx=20) ok",  10'd120, 10'd100, 0, 10'd100, 10'd100, 1'b1, 1'b0);
        blk_case("E12e sideways 5px (dx=15)",     10'd115, 10'd100, 0, 10'd100, 10'd100, 1'b1, 1'b1);
        blk_case("E12f diagonal 15/15 overlaps",  10'd115, 10'd115, 0, 10'd100, 10'd100, 1'b1, 1'b1);
        blk_case("E12g diagonal 25/25 clear",     10'd125, 10'd125, 0, 10'd100, 10'd100, 1'b1, 1'b0);
        blk_case("E12h dead enemy ignored",       10'd100, 10'd100, 0, 10'd100, 10'd100, 1'b0, 1'b0);
        // 第 4 个槽也要参与判定（N 路 OR 少一路，编号最大的那辆敌人就能被穿过）
        blk_case("E12i slot 3 overlaps",          10'd100, 10'd105, 3, 10'd100, 10'd100, 1'b1, 1'b1);
        // 玩家朝上时 position_y - 5 在 y=0 会回绕成 1020 那种大数：不能误判成“有车”
        blk_case("E12j wrapped cand (1020) clear",10'd1020, 10'd1020, 0, 10'd0, 10'd0, 1'b1, 1'b0);

        // ---------------- E13 集成：玩家挡住下坡通道，敌人不能开过来 ----------------
        // 造一条 1 块宽的竖直通道：块列 2（x 40..59）整列向下打通，
        // 左右两侧（块列 1 / 3）整列用砖封死，顶上就是画面外沿 ——
        // 于是 0 号车除了“向下”没有别的出路。玩家先被 force 到 (40,60) 站在通道里：
        //   车到 y=40 时车身 40..59，玩家 60..79 -> 刚好贴边，允许；
        //   再往下候选 y=45 -> 45..64 和玩家重叠 5px -> 必须被挡住。
        // 然后把玩家 force 走（搬到出生点），同一条通道应该立刻恢复畅通。
        // 这就是“坦克互相穿过”的回归用例：拆掉 tank_block 时它会一路开到 y=60 以上。
        // 注意两侧的墙必须自己 poke：真实地图里块列 3 正好是 A 相位的走廊，
        // 不封死的话车会从旁边绕下去（第一版用例就是这样漏过去的）。
        reset = 1'b1;
        repeat (5) @(posedge clock);
        for (j = 0; j <= 5; j = j + 1) begin
            poke_blk(BR(1, j), 4'd1);   // 左墙
            poke_blk(BR(3, j), 4'd1);   // 右墙
            poke_blk(BR(2, j), 4'd0);   // 通道
        end
        reset = 1'b0;
        // 玩家站位在装载完成后才 force：level 装载期间玩家会被 respawn 拉回出生点
        wait_load;
        force u_top.player_x = 10'd40;
        force u_top.player_y = 10'd60;
        repeat (150) @(posedge clock);  // probe 扫一遍
        check_enemy_pos("E13a enemy starts at spawn", 0, 10'd40, 10'd0);
        step_enemy(0, 8);               // 8 拍正好从 y=0 一格一格开到 y=40
        check_enemy_pos("E13b stopped in front of the player", 0, 10'd40, 10'd40);
        // 再抽 20 拍：位置可以变（撞车后它会像撞墙一样换方向），
        // 但 y 绝不能越过 40，也不能和玩家重叠（那 5px 就是穿模）。
        k0 = 0;                          // 违规次数
        for (i10 = 0; i10 < 20; i10 = i10 + 1) begin
            step_enemy(0, 1);
            eyv = u_top.enemy_y[9:0];
            if (eyv > 40) k0 = k0 + 1;   // 越过 y=40 = 从玩家身上开过去了
            exv = u_top.enemy_x[9:0];
            dxv = exv - u_top.player_x;  // |dx| < 20 且 |dy| < 20 就是两车重叠
            dyv = eyv - u_top.player_y;
            if (dxv < 0) dxv = -dxv;
            if (dyv < 0) dyv = -dyv;
            if ((dxv < 20) && (dyv < 20)) k0 = k0 + 1;
        end
        if (k0 != 0) begin
            errors = errors + 1;
            $display("[FAIL] E13c enemy clipped into the player %0d times (enemy %0d,%0d / player %0d,%0d)",
                     k0, u_top.enemy_x[9:0], u_top.enemy_y[9:0],
                     u_top.player_x, u_top.player_y);
        end else begin
            $display("[ OK ] E13c enemy never overlapped the player");
        end
        check_not_in_wall("E13d enemy body on passable tiles", 0);
        // 把玩家搬走（仍然 force，避免 release 之后寄存器回到哪个值的不确定性）：
        // 还是同一条通道，这回必须能开过去 -> 证明上一步是被“车”挡住的，不是地形。
        force u_top.player_x = 10'd200;
        force u_top.player_y = 10'd560;
        k0 = u_top.enemy_y[9:0];
        for (i10 = 0; i10 < 30; i10 = i10 + 1) begin
            step_enemy(0, 1);
            if (u_top.enemy_y[9:0] > k0) k0 = u_top.enemy_y[9:0];
        end
        if (k0 <= 10'd40) begin
            errors = errors + 1;
            $display("[FAIL] E13e enemy still stuck at y=%0d after the player moved away", k0);
        end else begin
            $display("[ OK ] E13e enemy drove past y=40 (max y=%0d) once free", k0);
        end
        release u_top.player_x;
        release u_top.player_y;

        // ---------------- E14 河岸脱困回归：必须从浅滩渡河（不再卡在河上）----------------
        // 这是“敌人卡在河上、对河开炮开路”的回归用例：把 0 号车 force 到河岸
        // 正中 (300,140)，朝下。真实地图第 1 关的河在格行 32~39（y 160..199），
        // 浅滩在块 3~6 / 9~10 / 19~20 / 23~26。
        // 新版 AI：横移滑行中每 3 格朝基地瞄一眼，瞄到浅滩当拍渡河；
        // 旧版“3 拍重瞄 + 每次脱困只试同一侧”会卡在河岸上下弹跳、永远过不去。
        do_reset;
        force u_top.u_enemy_ctrl.g_enemy[0].x         = 10'd300;
        force u_top.u_enemy_ctrl.g_enemy[0].y         = 10'd140;
        force u_top.u_enemy_ctrl.g_enemy[0].dir       = 2'b01;   // 朝下 = 朝基地
        force u_top.u_enemy_ctrl.g_enemy[0].hf_q      = 1'b0;
        force u_top.u_enemy_ctrl.g_enemy[0].rot       = 2'd0;
        force u_top.u_enemy_ctrl.g_enemy[0].slide_save = 2'b01;
        release u_top.u_enemy_ctrl.g_enemy[0].x;
        release u_top.u_enemy_ctrl.g_enemy[0].y;
        release u_top.u_enemy_ctrl.g_enemy[0].dir;
        release u_top.u_enemy_ctrl.g_enemy[0].hf_q;
        release u_top.u_enemy_ctrl.g_enemy[0].rot;
        release u_top.u_enemy_ctrl.g_enemy[0].slide_save;
        repeat (60) @(posedge clock);                 // probe 重扫新位置
        step_enemy(0, 60);                            // 滑到浅滩 + 渡河（含每 3 格一瞄）
        if (u_top.enemy_y[9:0] < 10'd200) begin
            errors = errors + 1;
            $display("[FAIL] E14 enemy0 still north of the river, y=%0d (stuck on the bank)",
                     u_top.enemy_y[9:0]);
        end else begin
            $display("[ OK ] E14 enemy0 crossed the river via a ford, y=%0d",
                     u_top.enemy_y[9:0]);
        end

        // ---------------- E15 左边缘河岸角落：贴边+面河也必须脱困 ----------------
        // 截图回归：一辆快车沿河岸滑到最左角（x=0、河在脚下、左边是画面边缘），
        // 旧版在这里上下弹跳。force 到 (0,140) 朝左（正撞边缘），要求：
        //   ① 旋转后向右横移（x 变大）② 沿河岸扫到浅滩并渡河。
        do_reset;
        force u_top.u_enemy_ctrl.g_enemy[0].x          = 10'd0;
        force u_top.u_enemy_ctrl.g_enemy[0].y          = 10'd140;
        force u_top.u_enemy_ctrl.g_enemy[0].dir        = 2'b10;   // 朝左（撞画面边缘）
        force u_top.u_enemy_ctrl.g_enemy[0].hf_q       = 1'b0;
        force u_top.u_enemy_ctrl.g_enemy[0].rot        = 2'd0;
        force u_top.u_enemy_ctrl.g_enemy[0].slide_save = 2'b01;   // 失效值 = want
        release u_top.u_enemy_ctrl.g_enemy[0].x;
        release u_top.u_enemy_ctrl.g_enemy[0].y;
        release u_top.u_enemy_ctrl.g_enemy[0].dir;
        release u_top.u_enemy_ctrl.g_enemy[0].hf_q;
        release u_top.u_enemy_ctrl.g_enemy[0].rot;
        release u_top.u_enemy_ctrl.g_enemy[0].slide_save;
        repeat (60) @(posedge clock);                 // probe 重扫新位置
        step_enemy(0, 12);
        if (u_top.enemy_x[9:0] < 10'd25) begin
            errors = errors + 1;
            $display("[FAIL] E15a corner tank stuck at x=%0d after 12 ticks", u_top.enemy_x[9:0]);
        end else begin
            $display("[ OK ] E15a corner tank slid right to x=%0d", u_top.enemy_x[9:0]);
        end
        step_enemy(0, 48);
        if (u_top.enemy_y[9:0] < 10'd200) begin
            errors = errors + 1;
            $display("[FAIL] E15b corner tank never crossed, (%0d,%0d)",
                     u_top.enemy_x[9:0], u_top.enemy_y[9:0]);
        end else begin
            $display("[ OK ] E15b corner tank crossed the river, y=%0d", u_top.enemy_y[9:0]);
        end

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


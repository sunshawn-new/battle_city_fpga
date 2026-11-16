`timescale 1ns / 1ps
// ============================================================================
// 炮弹系统仿真测试台（xsim）
//
// 直接例化 bullet_ctrl + map_bus + 地图 BRAM 模型（不经过 top），这样：
//   · 可以精确控制“玩家 + 每辆敌人”的位置/朝向和开火时刻；
//   · map_bus 的 p0 端口接一个“假的地形查询”，用来验证仲裁不会打断炮弹窗口；
//   · 地图 BRAM 用 bram_stubs.v 的模型，可以 poke 任意格子，用例与 map.coe 无关
//     （开始时先把整张地图清 0，再按用例写格子）。
//
// 【几何】600x600 玩区 = 120x120 格。坦克 (300,300) 向上开火：
//   炮口 (305,290) -> 弹体压 列 61..62 x 行 58..59；洞 = 列 60..63 x 行 58..59
// 所有坐标都用 A(列,行) 表示（= 行*120 + 列），换玩区尺寸时只改 MAP_W。
//
// 参数说明（仿真加速用）：
//   SPEED_DIV = 64   -> 每 64 拍炮弹走 1 像素（板上 250000）。
//                       必须大于一次扫描的耗时（4 格 x 7 拍 + 打洞 8 格 ≈ 80 拍
//                       才够；纯飞行时 4 格 = 28 拍），否则两次扫描会叠在一起，
//                       “没换格就不读地图”的去重就测不准。
//   COOLDOWN  = 200  -> 冷却 200 拍（板上 2e7）
//   DB_MAX    = 4    -> 消抖 4 拍（板上 1e6）
//   ONE_AT_A_TIME = 0 -> 允许同屏多发，才能测到对象池的分配/满池行为
// ============================================================================
module tb_bullet;
    localparam SPEED_DIV = 64;
    localparam COOLDOWN  = 200;
    localparam N_B       = 4;
    localparam N_E       = 3;
    localparam MAP_W     = 120;

    // 格地址 = row*MAP_W + col
    function [14:0] A;
        input integer col;
        input integer row;
        begin
            A = row * MAP_W + col;
        end
    endfunction

    reg clock = 1'b0;
    reg reset = 1'b1;

    always #5 clock = ~clock;   // 100MHz

    reg        fire_btn = 1'b0;
    reg        player_alive = 1'b1;
    reg [9:0]  tank_x = 10'd300, tank_y = 10'd300;
    reg [1:0]  tank_dir = 2'b00;

    // ---------------- 敌人（每辆一个位置/朝向，开火用单拍请求）----------------
    reg [N_E-1:0]    e_fire  = {N_E{1'b0}};
    reg [N_E-1:0]    e_alive = {N_E{1'b0}};
    reg [N_E*10-1:0] e_x, e_y;
    reg [N_E*2-1:0]  e_dir;

    // ---------------- 炮弹控制器 ----------------
    wire        b_req, b_we, b_gnt;
    wire        b_base_hit, b_hit_player;
    wire [14:0] b_addr;
    wire [3:0]  b_din;
    wire [3:0]  ram_douta;
    wire [N_B-1:0] b_valid, b_owner;
    wire [N_E-1:0] b_hit_enemy;
    wire [N_B*10-1:0] b_x, b_y;
    wire [N_B*2-1:0]  b_dir;

    bullet_ctrl #(
        .N_B(N_B),
        .N_E(N_E),
        .SPEED_DIV(SPEED_DIV),
        .COOLDOWN(COOLDOWN),
        .ONE_AT_A_TIME(0),
        .DB_MAX(4),
        .BW(10), .BH(10),
        .MAP_W(MAP_W), .MAP_H(120), .TILE(5)
    ) dut (
        .clock(clock), .reset(reset),
        .fire_btn(fire_btn),
        .player_alive(player_alive),
        .freeze(1'b0),
        .tank_x(tank_x), .tank_y(tank_y), .tank_dir(tank_dir),
        .e_fire(e_fire), .e_x(e_x), .e_y(e_y), .e_dir(e_dir), .e_alive(e_alive),
        .hit_player(b_hit_player), .hit_enemy(b_hit_enemy),
        .map_req(b_req), .map_we(b_we), .map_addr(b_addr), .map_din(b_din),
        .map_gnt(b_gnt), .map_dout(ram_douta),
        .base_hit(b_base_hit),
        .b_valid(b_valid), .b_owner(b_owner), .b_x(b_x), .b_y(b_y), .b_dir(b_dir)
    );


    // ---------------- 地图总线（p0 = 假的地形查询）----------------
    reg         fake_req = 1'b0;
    wire        fake_gnt;
    wire [14:0] ram_addra;
    wire        ram_wea;
    wire [3:0]  ram_dina;

    map_bus #(.N_PROBE(1)) u_bus (
        .clock(clock), .reset(reset),
        .p_req(fake_req), .p_addr(15'd0), .p_gnt(fake_gnt),
        .b_req(b_req), .b_we(b_we), .b_addr(b_addr), .b_din(b_din), .b_gnt(b_gnt),
        .ram_addra(ram_addra), .ram_wea(ram_wea), .ram_dina(ram_dina)
    );

    // ---------------- 地图 BRAM（行为模型，可 poke）----------------
    blk_mem_gen_0 u_ram (
        .clka(clock), .wea(ram_wea), .addra(ram_addra),
        .dina(ram_dina), .douta(ram_douta),
        .clkb(clock), .web(1'b0), .addrb(15'd0), .dinb(4'd0), .doutb()
    );

    // ---------------- 第二个小实例：只为了验证“同屏 1 发”规则 ----------------
    // ONE_AT_A_TIME = 1 时，同一个发射者（这里是 0 号敌人）只能有 1 发在飞。
    // 总线直接接常量（地图全空地、永远授权），只关心池里能有几发。
    reg        e1_fire = 1'b0;
    reg [9:0]  e1_x = 10'd40, e1_y = 10'd10;
    reg [1:0]  e1_dir = 2'b01;
    wire       e1_alive = 1'b1;
    wire [1:0] b1_valid;

    bullet_ctrl #(
        .N_B(2), .N_E(1),
        .SPEED_DIV(SPEED_DIV), .COOLDOWN(COOLDOWN), .ONE_AT_A_TIME(1),
        .DB_MAX(4), .BW(10), .BH(10),
        .MAP_W(MAP_W), .MAP_H(120), .TILE(5)
    ) dut1 (
        .clock(clock), .reset(reset),
        .fire_btn(1'b0), .player_alive(1'b0), .freeze(1'b0),
        .tank_x(10'd0), .tank_y(10'd0), .tank_dir(2'b00),
        .e_fire(e1_fire), .e_x(e1_x), .e_y(e1_y), .e_dir(e1_dir), .e_alive(e1_alive),
        .hit_player(), .hit_enemy(),
        .map_req(), .map_we(), .map_addr(), .map_din(),
        .map_gnt(1'b1), .map_dout(4'd0),
        .base_hit(),
        .b_valid(b1_valid), .b_owner(), .b_x(), .b_y(), .b_dir()
    );

    // 总线流水计数器：验证“弹头没换格就不读地图”
    integer req_count = 0;
    reg     b_req_d   = 1'b0;
    always @(posedge clock) begin
        b_req_d <= b_req;
        if (b_req & ~b_req_d) req_count = req_count + 1;
    end

    // 记录最近一次“生成”时的炮口坐标：生成之后炮弹马上就会移动，
    // 所以不能事后去读 x[]/y[]，要在生成当拍抓下来。
    reg [9:0] cap_mx = 10'd0, cap_my = 10'd0;
    always @(posedge clock) begin
        if (dut.spawn) begin
            cap_mx <= dut.muzzle_x;
            cap_my <= dut.muzzle_y;
        end
    end

    // 临时调试监视器（验证完就删）
    integer errors = 0;
    integer k, j;
    integer base_hits = 0;      // 统计 base_hit 单拍脉冲的个数
    integer player_hits = 0;    // 统计 hit_player 单拍脉冲的个数
    integer enemy_hits = 0;     // 统计 hit_enemy 单拍脉冲的个数
    integer bh0, ph0, eh0;

    always @(posedge clock) if (dut.base_hit)   base_hits   = base_hits + 1;
    always @(posedge clock) if (dut.hit_player) player_hits = player_hits + 1;
    always @(posedge clock) if (|dut.hit_enemy) enemy_hits  = enemy_hits + 1;

    // ---------------- 基础激励 ----------------
    // 每次复位都顺手把地图清空：用例之间不会互相污染（上一条用例打剩的砖
    // 会挡住下一条用例的弹道 —— B24 就踩过这个坑）。poke 都在 do_reset 之后。
    task clear_map;
        integer m;
        begin
            @(negedge clock);
            for (m = 0; m < 32768; m = m + 1) u_ram.mem[m] = 4'd0;
        end
    endtask

    task do_reset;
        begin
            clear_map;
            fire_btn = 1'b0;
            e_fire   = {N_E{1'b0}};
            e_alive  = {N_E{1'b0}};      // 默认场上没有敌人（用例按需打开）
            e_x      = {(N_E*10){1'b0}};
            e_y      = {(N_E*10){1'b0}};
            e_dir    = {(N_E*2){1'b0}};
            reset    = 1'b1;
            repeat (10) @(posedge clock);
            reset    = 1'b0;
            repeat (40) @(posedge clock);
        end
    endtask

    // 摆一辆敌人（仿真专用）
    task set_enemy;
        input integer    i;
        input [9:0]      ex;
        input [9:0]      ey;
        input [1:0]      ed;
        begin
            e_alive[i]      = 1'b1;
            e_x[i*10 +: 10] = ex;
            e_y[i*10 +: 10] = ey;
            e_dir[i*2 +: 2] = ed;
            @(posedge clock);
        end
    endtask

    // 按一下开火键：按住 12 拍（远超消抖 4 拍），再松开 12 拍
    task fire;
        begin
            fire_btn = 1'b1;
            repeat (12) @(posedge clock);
            fire_btn = 1'b0;
            repeat (12) @(posedge clock);
        end
    endtask

    // 敌人开火请求（单拍脉冲）
    task enemy_fire;
        input integer i;
        begin
            e_fire[i] = 1'b1;
            @(posedge clock);
            e_fire[i] = 1'b0;
            repeat (4) @(posedge clock);
        end
    endtask

    task wait_cycles;
        input integer n;
        begin
            repeat (n) @(posedge clock);
            #1;
        end
    endtask

    // 等 n 个炮弹移动节拍（每拍走 1 像素）
    // 注意：bullet_tick 是从 spd_cnt 组合出来的，它在时钟沿之后才拉高，
    // 而“移动”发生在 bullet_tick 为 1 的下一个时钟沿，所以要多等一个时钟沿
    // 才能看到移位后的坐标。
    task wait_ticks;
        input integer n;
        begin
            for (k = 0; k < n; k = k + 1) begin
                @(posedge dut.bullet_tick);
                @(posedge clock);
                #1;
            end
        end
    endtask

    // 等出现第一发炮弹（生成脉冲后 act 变非 0）
    task wait_spawn;
        begin
            j = 0;
            while ((dut.act == {N_B{1'b0}}) && (j < 500)) begin
                @(posedge clock);
                j = j + 1;
            end
            #1;
        end
    endtask

    // 等池里正好有 n 发（用来等“第二发”生成）
    task wait_pool;
        input integer n;
        begin
            j = 0;
            while ((popcount(b_valid) != n) && (j < 500)) begin
                @(posedge clock);
                j = j + 1;
            end
            #1;
        end
    endtask

    // 直接改地图内容（仿真专用）
    task poke;
        input [14:0] idx;
        input [3:0]  val;
        begin
            @(negedge clock);
            u_ram.mem[idx] = val;
            @(negedge clock);
        end
    endtask

    function [3:0] peek;
        input [14:0] idx;
        begin
            peek = u_ram.mem[idx];
        end
    endfunction

    function integer popcount;
        input [N_B-1:0] v;
        integer t;
        begin
            popcount = 0;
            for (t = 0; t < N_B; t = t + 1)
                if (v[t]) popcount = popcount + 1;
        end
    endfunction
    // ---------------- 断言 ----------------
    task check_u10;
        input [8*46-1:0] name;
        input [9:0] got;
        input [9:0] exp;
        begin
            if (got !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got %0d, expected %0d", name, got, exp);
            end else begin
                $display("[ OK ] %0s : %0d", name, got);
            end
        end
    endtask

    task check_mask;
        input [8*46-1:0] name;
        input [N_B-1:0]  exp;
        begin
            if (b_valid !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : b_valid = %b, expected %b", name, b_valid, exp);
            end else begin
                $display("[ OK ] %0s : b_valid = %b", name, b_valid);
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

    task check_range;
        input [8*46-1:0] name;
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

    task check_terrain;
        input [8*46-1:0] name;
        input [14:0]     idx;
        input [3:0]      exp;
        begin
            if (peek(idx) !== exp) begin
                errors = errors + 1;
                $display("[FAIL] %0s : map[%0d] = %0d, expected %0d",
                         name, idx, peek(idx), exp);
            end else begin
                $display("[ OK ] %0s : map[%0d] = %0d", name, idx, exp);
            end
        end
    endtask

    // ================= 坐标常量（坦克 (300,300)，格 5 像素，地图 120x120）=================
    // 向上开火：炮口 (305,290) -> 弹体压 列 61..62 x 行 58..59
    //   弹体覆盖的格：(61,58)(62,58)(61,59)(62,59)
    //   打出的洞：列 60..63（坦克那 4 列）x 行 58..59（弹体那 2 行）
    localparam [14:0] CELL_UP1 =  58*120 + 62;   // 弹体右下角那一格（砖块用例）
    localparam [14:0] CELL_UP2 =  57*120 + 62;   // 弹体上方一格（洞外）
    localparam [14:0] ROW_ABOVE = 57*120 + 60;   // 洞外（必须保留）
    localparam [14:0] ROW_BELOW = 60*120 + 60;   // 洞外（必须保留）

    // 水平打砖（向左）：坦克 (300,300) -> 炮口 (290,305) -> 弹体压 列 58..59 x 行 61..62
    //   洞 = 行 60..63（坦克那 4 行）x 列 58..59（弹体那 2 列）
    localparam [14:0] BAND_H0 = 60*120 + 58;     // 行 60 列 58（洞的第一行）

    reg [9:0] y0, x0;

    initial begin
        $display("=========== tb_bullet: 炮弹对象池 / 飞行 / 命中 ===========");

        // 先把整张地图清 0：每条用例自己 poke 需要的格子，结果与 map.coe 无关
        for (j = 0; j < 32768; j = j + 1) u_ram.mem[j] = 4'd0;

        // ---------------- B01 发射：炮口位置（向上）----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_spawn;
        check_mask("B01a fire -> 1 bullet in pool", 4'b0001);
        check_u10 ("B01b muzzle x (up)",  cap_mx, 10'd305);
        check_u10 ("B01c muzzle y (up)",  cap_my, 10'd290);

        // ---------------- B02 冷却：紧接着再按不能多出一发 ----------------
        fire;
        check_mask("B02 cooldown blocks 2nd shot", 4'b0001);

        // ---------------- B03 飞行：每个节拍走 1 像素 ----------------
        @(posedge dut.bullet_tick);
        @(posedge clock); #1;
        y0 = b_y[9:0];
        wait_ticks(5);
        check_u10("B03 flies 1px per tick", b_y[9:0], y0 - 10'd5);

        // ---------------- B04 命中砖块：消失 + 打穿 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd1);
        fire; wait_cycles(90);
        check_mask   ("B04a brick kills bullet", 4'b0000);
        check_terrain("B04b brick erased to empty", CELL_UP1, 4'd0);

        // ---------------- B05 钢墙：消失，地图不变 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd2);
        fire; wait_cycles(90);
        check_mask   ("B05a steel kills bullet", 4'b0000);
        check_terrain("B05b steel not destroyed", CELL_UP1, 4'd2);

        // ---------------- B06 河流：炮弹飞过去（水只挡坦克），地图不变 ----
        // 原版规则就是"河挡车不挡弹"，隔河对射是这张图最经典的攻防；
        // 早期版本把河当成钢墙，结果两岸的车谁也打不到谁，很别扭。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd3);
        fire; wait_cycles(90);
        check_mask   ("B06a river does not stop bullet", 4'b0001);
        check_terrain("B06b river not destroyed", CELL_UP1, 4'd3);

        // ---------------- B07 树林：可以穿过去 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd4);
        fire; wait_cycles(90);
        check_mask("B07a woods is passable", 4'b0001);

        // ---------------- B08 炮口就在图外：立刻回收，不泄漏槽位 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd5; tank_dir = 2'b00;   // 炮口 y = 5-10 -> 回绕
        fire; wait_cycles(90);
        check_mask("B08 spawn off-map -> recycled", 4'b0000);

        // ---------------- B09 飞出地图：回绕前就要回收 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd20; tank_dir = 2'b00;  // 炮口 y = 10
        fire; wait_spawn;
        wait_ticks(5);
        check_mask("B09a still flying inside map", 4'b0001);
        wait_ticks(9);                                        // 共 14 拍 -> 已出界
        check_mask("B09b flew out -> recycled", 4'b0000);

        // ---------------- B10 对象池：最多 4 发，满了就丢弃 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(20);
        check_int("B10a pool filled with 4 bullets", popcount(b_valid), 4);
        fire; wait_cycles(20);
        check_int("B10b 5th shot dropped (pool full)", popcount(b_valid), 4);

        // ---------------- B11 总线仲裁：地形查询占用时炮弹窗口排队，不丢 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd1);
        fake_req = 1'b1;                 // 模拟地形查询一直握着地图总线
        repeat (4) @(posedge clock);
        fire; wait_cycles(120);
        check_int    ("B11a bullet not granted bus", (b_gnt === 1'b0), 1);
        check_terrain("B11b brick intact while busy", CELL_UP1, 4'd1);
        check_mask   ("B11c bullet still waiting", 4'b0001);

        fake_req = 1'b0;                 // 地形查询放手
        wait_cycles(120);
        check_terrain("B11d brick erased after gnt", CELL_UP1, 4'd0);
        check_mask   ("B11e bullet recycled after gnt", 4'b0000);

        // ---------------- B12 同一个 2x2 格组里飞行，不重复读地图 ----------------
        // 10x10 的弹体正好压 2x2 格（格 5 像素），飞 5 像素最多只跨 1 次格：
        // 所以整段只该有 1~2 次地图扫描（出生那次 + 换格那次），
        // 而不是“每个节拍扫一次”（那会是 5 次）。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_spawn;                // 炮口 (305,290) -> 行 58..59
        req_count = 0;
        wait_ticks(5);                   // y: 290 -> 285，只在 289 处换格
        wait_cycles(60);                 // 等最后一轮扫描把 req 发完
        check_range("B12 5px flight -> 1~2 map scans", req_count, 1, 2);

        // ---------------- B13 四个方向的炮口位置 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b10;   // 左
        fire; wait_spawn;
        check_u10("B13a muzzle x (left)",  cap_mx, 10'd290);
        check_u10("B13b muzzle y (left)",  cap_my, 10'd305);

        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b01;   // 下
        fire; wait_spawn;
        check_u10("B13c muzzle y (down)",  cap_my, 10'd320);

        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b11;   // 右
        fire; wait_spawn;
        check_u10("B13d muzzle x (right)", cap_mx, 10'd320);

        // ---------------- B14 打砖：一发清掉 4 格宽 x 2 格深 = 20x10 像素 ----------------
        // 坦克 (300,300) 向上：弹体压在 列 61..62 x 行 58..59，
        // 洞 = 列 60..63（正好是坦克那 4 列）x 行 58..59（正好是弹体那 2 行）。
        // 上下左右各留一圈砖当“不许动”的哨兵。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 59; j <= 64; j = j + 1) begin
            poke(57*120 + j, 4'd1);   // 行 57：洞外
            poke(58*120 + j, 4'd1);   // 行 58：洞的第一行
            poke(59*120 + j, 4'd1);   // 行 59：洞的第二行
            poke(60*120 + j, 4'd1);   // 行 60：洞外
        end
        fire; wait_cycles(200);
        check_mask("B14a bullet dies on brick", 4'b0000);
        for (j = 60; j <= 63; j = j + 1) begin
            check_terrain("B14b hole row58 col cleared", 58*120 + j, 4'd0);
            check_terrain("B14c hole row59 col cleared", 59*120 + j, 4'd0);
        end
        check_terrain("B14d left  col 59 kept", 58*120 + 59, 4'd1);
        check_terrain("B14e right col 64 kept", 58*120 + 64, 4'd1);
        check_terrain("B14f above row 57 kept", ROW_ABOVE + 15'd1, 4'd1);
        check_terrain("B14g below row 60 kept", ROW_BELOW + 15'd1, 4'd1);

        // ---------------- B15 偏心命中：4 格里只有 1 格是砖，也必须挡住 ----------------
        // 只在弹体的右下角那一格 (列 62, 行 59) 放砖。旧版本只看弹心那一格，
        // 子弹会整条穿过去（板上表现为“炮弹穿墙”/“贴脸开火打不穿”）。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(59*120 + 62, 4'd1);
        fire; wait_cycles(200);
        check_mask   ("B15a corner brick kills bullet", 4'b0000);
        check_terrain("B15b corner brick cleared", 59*120 + 62, 4'd0);
        check_terrain("B15c hole corner (60,58) cleared", 58*120 + 60, 4'd0);
        check_terrain("B15d hole corner (63,59) cleared", 59*120 + 63, 4'd0);

        // ---------------- B16 贴墙开火：坦克紧贴砖墙时，弹体一出生就压在砖上 ----------------
        // 只在 行 59（坦克正上方那一行）放砖，弹体的下半截（行 59）就压在砖里。
        // 必须当场判定命中并打出和自己截面一样大的洞，否则坦克永远挤不进去。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 60; j <= 63; j = j + 1) poke(59*120 + j, 4'd1);
        fire; wait_cycles(200);
        check_mask("B16a flush wall kills bullet", 4'b0000);
        check_terrain("B16b flush row 59 col 60 cleared", 59*120 + 60, 4'd0);
        check_terrain("B16c flush row 59 col 63 cleared", 59*120 + 63, 4'd0);
        check_terrain("B16d flush row 58 col 60 cleared", 58*120 + 60, 4'd0);

        // ---------------- B17 水平打砖：4 行 x 2 列 = 20x10，和坦克竖向对齐 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b10;   // 向左
        for (j = 0; j < 4; j = j + 1) begin
            poke(BAND_H0 + j * 120,        4'd1);   // 行 60..63 列 58
            poke(BAND_H0 + j * 120 + 15'd1, 4'd1);  // 行 60..63 列 59
        end
        poke(BAND_H0 - 15'd1,          4'd1);   // 行 60 列 57：洞外
        poke(BAND_H0 + 15'd480,        4'd1);   // 行 64 列 58：洞外（4 行之后）
        poke(BAND_H0 + 15'd481,        4'd1);   // 行 64 列 59：洞外
        fire; wait_cycles(200);
        for (j = 0; j < 4; j = j + 1) begin
            check_terrain("B17a hole col 58 cleared", BAND_H0 + j * 120,        4'd0);
            check_terrain("B17b hole col 59 cleared", BAND_H0 + j * 120 + 15'd1, 4'd0);
        end
        check_terrain("B17c left  col 57 kept", BAND_H0 - 15'd1, 4'd1);
        check_terrain("B17d below row 64 kept", BAND_H0 + 15'd480, 4'd1);

        // ---------------- B18 连打两发：隧道每次正好推进 2 格（10 像素）----------------
        // 第一发打通 行 58..59，坦克往前开 2 格（10 像素）后再打，第二发打通 行 56..57：
        // 洞和坦克的脚下一格不差，不会留下“半格残砖”把坦克卡住。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 59; j <= 64; j = j + 1) begin
            poke(55*120 + j, 4'd1);   // 行 55：洞外
            poke(56*120 + j, 4'd1);   // 行 56
            poke(57*120 + j, 4'd1);   // 行 57
            poke(58*120 + j, 4'd1);   // 行 58
            poke(59*120 + j, 4'd1);   // 行 59
        end
        fire; wait_cycles(200);               // 第一发
        check_terrain("B18a shot1 row 58 cleared", 58*120 + 61, 4'd0);
        check_terrain("B18b shot1 row 59 cleared", 59*120 + 61, 4'd0);
        check_terrain("B18c shot1 row 57 kept",    57*120 + 61, 4'd1);

        wait_cycles(COOLDOWN);                // 等冷却
        tank_y = 10'd290;                     // 坦克往前开 2 格
        fire; wait_cycles(200);               // 第二发
        check_terrain("B18d shot2 row 57 cleared", 57*120 + 61, 4'd0);
        check_terrain("B18e shot2 row 56 cleared", 56*120 + 61, 4'd0);
        check_terrain("B18f shot2 row 55 kept",    55*120 + 61, 4'd1);
        check_terrain("B18g tunnel col 59 kept",   57*120 + 59, 4'd1);
        check_terrain("B18h tunnel col 64 kept",   57*120 + 64, 4'd1);

        // ---------------- B19 基地：炮弹消失 + 单拍 base_hit，地图格保持 5 ----------------
        // 基地（tile_id == 5）和钢墙一样挡住炮弹，但要多发一个 base_hit 脉冲，
        // top 用它把 game-over 锁存起来（VGA 换成白旗贴图）。
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd5);                 // 弹体第一格就是基地
        bh0 = base_hits;
        fire; wait_cycles(90);
        check_mask   ("B19a base absorbs bullet", 4'b0000);
        check_terrain("B19b base tile stays 5", CELL_UP1, 4'd5);
        check_int    ("B19c exactly one base_hit pulse", base_hits - bh0, 1);

        // 打砖不能触发 base_hit（把“命中基地”和“撞到任何硬地形”区分开）
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd1);
        bh0 = base_hits;
        fire; wait_cycles(90);
        check_int("B19d brick does not trigger base_hit", base_hits - bh0, 0);

        // ================= 以下用例覆盖“两种炮弹”的玩法 =================

        // ---------------- B20 敌人开火：炮口按它自己的位置/朝向算 ----------------
        do_reset;
        set_enemy(0, 10'd40, 10'd10, 2'b01);        // 左上角那辆，朝下
        enemy_fire(0);
        wait_spawn;
        check_mask("B20a enemy shot spawns", 4'b0001);
        check_int ("B20b bullet is owned by enemy", b_owner, 4'b0001);
        check_u10 ("B20c enemy muzzle x", cap_mx, 10'd45);
        check_u10 ("B20d enemy muzzle y", cap_my, 10'd30);

        // ---------------- B21 敌人的弹打中玩家 ----------------
        // 敌人在玩家正上方 30px 处朝下开火：炮口在 y=290，1 拍之后就压到玩家身上
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300;
        set_enemy(0, 10'd300, 10'd270, 2'b01);
        ph0 = player_hits;
        enemy_fire(0);
        wait_spawn;
        wait_ticks(3);
        wait_cycles(20);
        check_int ("B21a player hit once", player_hits - ph0, 1);
        check_mask("B21b bullet recycled on hit", 4'b0000);

        // ---------------- B22 玩家的弹打中敌人 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        set_enemy(0, 10'd300, 10'd270, 2'b01);
        eh0 = enemy_hits;
        fire; wait_spawn;
        wait_ticks(3);
        wait_cycles(20);
        check_int ("B22a enemy hit once", enemy_hits - eh0, 1);
        check_mask("B22b bullet recycled on hit", 4'b0000);

        // ---------------- B23 敌人之间不会误伤（不打自己人）----------------
        // 0 号朝下开火，1 号正好站在弹道上；飞过去的时候不能报 hit_enemy
        do_reset;
        tank_x = 10'd300; tank_y = 10'd500;          // 玩家离得远远的
        set_enemy(0, 10'd300, 10'd150, 2'b01);       // 炮口 (305,170)
        set_enemy(1, 10'd300, 10'd190, 2'b01);       // 弹道正下方
        eh0 = enemy_hits;
        enemy_fire(0);
        wait_spawn;
        wait_ticks(15);                              // y: 170 -> 185，已经压进 1 号
        wait_cycles(20);
        check_int ("B23a no friendly fire", enemy_hits - eh0, 0);
        check_mask("B23b bullet still flying", 4'b0001);

        // ---------------- B24 弹对弹：敌我炮弹相撞同归于尽 ----------------
        // 玩家的弹从 y=290 往上飞，敌人的弹从 y=220 往下飞，约 31 拍后相遇
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        set_enemy(0, 10'd300, 10'd200, 2'b01);
        ph0 = player_hits;
        eh0 = enemy_hits;
        fire; wait_spawn;                            // 玩家的弹
        enemy_fire(0);                               // 敌人的弹
        wait_pool(2);
        for (j = 0; j < 60 && (b_valid != {N_B{1'b0}}); j = j + 1) wait_ticks(1);
        check_mask("B24a both bullets destroyed", 4'b0000);
        check_int ("B24b no player hit", player_hits - ph0, 0);
        check_int ("B24c no enemy hit",  enemy_hits  - eh0, 0);

        // ---------------- B25 “同屏 1 发”规则（每辆敌人单独限 1 发）----------------
        // 用一个 ONE_AT_A_TIME=1 的小实例：连按两次，池里也只能有 1 发
        e1_fire = 1'b1;  @(posedge clock);  e1_fire = 1'b0;
        wait_cycles(120);
        check_int("B25a first enemy shot in flight", popcount(b1_valid), 1);
        e1_fire = 1'b1;  @(posedge clock);  e1_fire = 1'b0;
        wait_cycles(120);
        check_int("B25b 2nd request dropped (1 at a time)", popcount(b1_valid), 1);

        // ---------------- B26 GAME OVER：freeze 时炮弹停在原地 ----------------
        do_reset;
        tank_x = 10'd300; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_spawn;
        wait_ticks(2);
        y0 = b_y[9:0];
        force dut.freeze = 1'b1;
        wait_cycles(SPEED_DIV * 4 + 20);        // freeze 时 bullet_tick 恒为 0，只能等固定拍数
        check_u10("B26a bullet frozen in place", b_y[9:0], y0);
        release dut.freeze;
        wait_ticks(2);
        if (b_y[9:0] === y0) begin
            errors = errors + 1;
            $display("[FAIL] B26b bullet did not resume after unfreeze");
        end else begin
            $display("[ OK ] B26b bullet resumes after unfreeze (y=%0d)", b_y[9:0]);
        end
        check_mask("B26c bullet still alive", 4'b0001);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule


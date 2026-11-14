`timescale 1ns / 1ps
// ============================================================================
// 炮弹系统仿真测试台（xsim）
//
// 直接例化 bullet_ctrl + map_bus + 地图 BRAM 模型（不经过 top），这样：
//   · 可以精确控制坦克位置/朝向和开火时刻；
//   · map_bus 的 p0 端口接一个“假的地形查询”，用来验证仲裁不会打断炮弹窗口；
//   · 地图 BRAM 用 bram_stubs.v 的模型，可以 poke 任意格子，用例与 map.coe 无关
//     （开始时先把整张地图清 0，再按用例写格子）。
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

    reg clock = 1'b0;
    reg reset = 1'b1;

    always #5 clock = ~clock;   // 100MHz

    reg        fire_btn = 1'b0;
    reg [9:0]  tank_x = 10'd400, tank_y = 10'd300;
    reg [1:0]  tank_dir = 2'b00;

    // ---------------- 炮弹控制器 ----------------
    wire        b_req, b_we, b_gnt;
    wire [14:0] b_addr;
    wire [3:0]  b_din;
    wire [3:0]  ram_douta;
    wire [N_B-1:0] b_valid;
    wire [N_B*10-1:0] b_x, b_y;
    wire [N_B*2-1:0]  b_dir;

    bullet_ctrl #(
        .N_B(N_B),
        .SPEED_DIV(SPEED_DIV),
        .COOLDOWN(COOLDOWN),
        .ONE_AT_A_TIME(0),
        .DB_MAX(4),
        .BW(10), .BH(10),
        .MAP_W(160), .MAP_H(120), .TILE(5)
    ) dut (
        .clock(clock), .reset(reset),
        .fire_btn(fire_btn),
        .tank_x(tank_x), .tank_y(tank_y), .tank_dir(tank_dir),
        .map_req(b_req), .map_we(b_we), .map_addr(b_addr), .map_din(b_din),
        .map_gnt(b_gnt), .map_dout(ram_douta),
        .b_valid(b_valid), .b_x(b_x), .b_y(b_y), .b_dir(b_dir)
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

    integer errors = 0;
    integer k, j;

    // ---------------- 基础激励 ----------------
    task do_reset;
        begin
            fire_btn = 1'b0;
            reset    = 1'b1;
            repeat (10) @(posedge clock);
            reset    = 1'b0;
            repeat (40) @(posedge clock);
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
            while ((dut.act == {N_B{1'b0}}) && (j < 200)) begin
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

    // ================= 坐标常量（坦克 (400,300)，格 5 像素，地图 160x120）=================
    // 向上开火：炮口 (405,290) -> 弹体压 列 81..82 x 行 58..59
    localparam [14:0] CELL_UP1 = 15'd9362;   // 行 58 列 82：弹体覆盖的一格（砖块用例）
    localparam [14:0] CELL_UP2 = 15'd9202;   // 行 57 列 82：弹体上方一格（洞外）

    // 行基址（只含 row*160），列号单独加：ROWxx + col
    localparam [14:0] ROW55 = 15'd8800;      // 55*160
    localparam [14:0] ROW56 = 15'd8960;      // 56*160
    localparam [14:0] ROW57 = 15'd9120;      // 57*160
    localparam [14:0] ROW58 = 15'd9280;      // 58*160
    localparam [14:0] ROW59 = 15'd9440;      // 59*160
    localparam [14:0] ROW60 = 15'd9600;      // 60*160

    // 打砖洞（向上）：列 80..83（= 坦克那 4 列）x 行 58..59（= 弹体那 2 行）= 20x10 像素
    localparam [14:0] BAND_V0   = 15'd9360;    // 行 58 列 80（洞的第一行）
    localparam [14:0] BAND_V1   = 15'd9520;    // 行 59 列 80（洞的第二行）
    localparam [14:0] ROW_ABOVE = 15'd9120;    // 行 57 列 80（洞外，必须保留）
    localparam [14:0] ROW_BELOW = 15'd9600;    // 行 60 列 80（洞外，必须保留）

    // 打砖洞（向左）：坦克 (400,300) 向左 -> 炮口 (390,305) -> 弹体压 列 78..79 x 行 61..62
    //   洞 = 行 60..63（= 坦克那 4 行）x 列 78..79（= 弹体那 2 列）
    localparam [14:0] BAND_H0   = 15'd9678;    // 行 60 列 78（洞的第一行）

    reg [9:0] y0, x0;

    initial begin
        $display("=========== tb_bullet: 炮弹对象池 / 飞行 / 命中 ===========");

        // 先把整张地图清 0：每条用例自己 poke 需要的格子，结果与 map.coe 无关
        for (j = 0; j < 32768; j = j + 1) u_ram.mem[j] = 4'd0;

        // ---------------- B01 发射：炮口位置（向上）----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_spawn;
        check_mask("B01a fire -> 1 bullet in pool", 4'b0001);
        check_u10 ("B01b muzzle x (up)",  cap_mx, 10'd405);
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
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd1);
        fire; wait_cycles(90);
        check_mask   ("B04a brick kills bullet", 4'b0000);
        check_terrain("B04b brick erased to empty", CELL_UP1, 4'd0);

        // ---------------- B05 钢墙：消失，地图不变 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd2);
        fire; wait_cycles(90);
        check_mask   ("B05a steel kills bullet", 4'b0000);
        check_terrain("B05b steel not destroyed", CELL_UP1, 4'd2);

        // ---------------- B06 河流：消失，地图不变 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd3);
        fire; wait_cycles(90);
        check_mask   ("B06a river kills bullet", 4'b0000);
        check_terrain("B06b river not destroyed", CELL_UP1, 4'd3);

        // ---------------- B07 树林：可以穿过去 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        poke(CELL_UP1, 4'd4);
        fire; wait_cycles(90);
        check_mask   ("B07a woods is passable", 4'b0001);
        // ---------------- B08 炮口就在图外：立刻回收，不泄漏槽位 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd5; tank_dir = 2'b00;   // 弹口 y = 5-10 -> 回绕
        fire; wait_cycles(90);
        check_mask("B08 spawn off-map -> recycled", 4'b0000);

        // ---------------- B09 飞出地图：回绕前就要回收 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd20; tank_dir = 2'b00;  // 弹口 y = 10
        fire; wait_spawn;
        wait_ticks(5);
        check_mask("B09a still flying inside map", 4'b0001);
        wait_ticks(9);                                        // 共 14 拍 -> 已出界
        check_mask("B09b flew out -> recycled", 4'b0000);

        // ---------------- B10 对象池：最多 4 发，满了就丢弃 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(COOLDOWN + 20);
        fire; wait_cycles(20);
        check_int("B10a pool filled with 4 bullets", popcount(b_valid), 4);
        fire; wait_cycles(20);
        check_int("B10b 5th shot dropped (pool full)", popcount(b_valid), 4);

        // ---------------- B11 总线仲裁：地形查询占用时炮弹窗口排队，不丢 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
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
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        fire; wait_spawn;                // 炮口 (405,290) -> 行 58..59
        req_count = 0;
        wait_ticks(5);                   // y: 290 -> 285，只在 289 处换格
        wait_cycles(60);                 // 等最后一轮扫描把 req 发完（< 一个节拍周期）
        check_range("B12 5px flight -> 1~2 map scans", req_count, 1, 2);

        // ---------------- B13 四个方向的炮口位置 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b10;   // 左
        fire; wait_spawn;
        check_u10("B13a muzzle x (left)",  cap_mx, 10'd390);
        check_u10("B13b muzzle y (left)",  cap_my, 10'd305);

        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b01;   // 下
        fire; wait_spawn;
        check_u10("B13c muzzle y (down)",  cap_my, 10'd320);

        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b11;   // 右
        fire; wait_spawn;
        check_u10("B13d muzzle x (right)", cap_mx, 10'd420);

        // ---------------- B14 打砖：一发清掉 4 格宽 x 2 格深 = 20x10 像素 ----------------
        // 坦克 (400,300) 向上：弹体压在 列 81..82 x 行 58..59，
        // 洞 = 列 80..83（正好是坦克那 4 列）x 行 58..59（正好是弹体那 2 行）。
        // 上下左右各留一圈砖当“不许动”的哨兵。
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 79; j <= 84; j = j + 1) begin
            poke(ROW57 + j[14:0],      4'd1);   // 行 57：洞外
            poke(ROW58 + j[14:0],      4'd1);   // 行 58：洞的第一行
            poke(ROW59 + j[14:0],      4'd1);   // 行 59：洞的第二行
            poke(ROW60 + j[14:0],      4'd1);   // 行 60：洞外
        end
        fire; wait_cycles(200);
        check_mask("B14a bullet dies on brick", 4'b0000);
        for (j = 80; j <= 83; j = j + 1) begin
            check_terrain("B14b hole row58 col cleared", ROW58 + j[14:0], 4'd0);
            check_terrain("B14c hole row59 col cleared", ROW59 + j[14:0], 4'd0);
        end
        check_terrain("B14d left  col 79 kept", ROW58 + 15'd79, 4'd1);
        check_terrain("B14e right col 84 kept", ROW58 + 15'd84, 4'd1);
        check_terrain("B14f above row 57 kept", ROW_ABOVE + 15'd81, 4'd1);
        check_terrain("B14g below row 60 kept", ROW_BELOW + 15'd81, 4'd1);

        // ---------------- B15 偏心命中：4 格里只有 1 格是砖，也必须挡住 ----------------
        // 只在弹体的右下角那一格 (列 82, 行 59) 放砖。旧版本只看弹心那一格，
        // 子弹会整条穿过去（板上表现为“炮弹穿墙”/“贴脸开火打不穿”）。
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        poke(ROW59 + 15'd82, 4'd1);
        fire; wait_cycles(200);
        check_mask   ("B15a corner brick kills bullet", 4'b0000);
        check_terrain("B15b corner brick cleared", ROW59 + 15'd82, 4'd0);
        check_terrain("B15c hole corner (80,58) cleared", ROW58 + 15'd80, 4'd0);
        check_terrain("B15d hole corner (83,59) cleared", ROW59 + 15'd83, 4'd0);

        // ---------------- B16 贴墙开火：坦克紧贴砖墙时，弹体一出生就压在砖上 ----------------
        // 只在 行 59（坦克正上方那一行）放砖，弹体的下半截（行 59）就压在砖里。
        // 必须当场判定命中并打出和自己截面一样大的洞，否则坦克永远挤不进去。
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 80; j <= 83; j = j + 1) poke(ROW59 + j[14:0], 4'd1);
        fire; wait_cycles(200);
        check_mask("B16a flush wall kills bullet", 4'b0000);
        check_terrain("B16b flush row 59 col 80 cleared", ROW59 + 15'd80, 4'd0);
        check_terrain("B16c flush row 59 col 83 cleared", ROW59 + 15'd83, 4'd0);
        check_terrain("B16d flush row 58 col 80 cleared", ROW58 + 15'd80, 4'd0);

        // ---------------- B17 水平打砖：4 行 x 2 列 = 20x10，和坦克竖向对齐 ----------------
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b10;   // 向左
        for (j = 0; j < 4; j = j + 1) begin
            poke(BAND_H0 + j[14:0] * 160,        4'd1);   // 行 60..63 列 78
            poke(BAND_H0 + j[14:0] * 160 + 15'd1, 4'd1);  // 行 60..63 列 79
        end
        poke(BAND_H0 - 15'd1,          4'd1);   // 行 60 列 77：洞外
        poke(BAND_H0 + 15'd640,        4'd1);   // 行 64 列 78：洞外
        poke(BAND_H0 + 15'd641,        4'd1);   // 行 64 列 79：洞外
        fire; wait_cycles(200);
        for (j = 0; j < 4; j = j + 1) begin
            check_terrain("B17a hole col 78 cleared", BAND_H0 + j[14:0] * 160,        4'd0);
            check_terrain("B17b hole col 79 cleared", BAND_H0 + j[14:0] * 160 + 15'd1, 4'd0);
        end
        check_terrain("B17c left  col 77 kept", BAND_H0 - 15'd1,  4'd1);
        check_terrain("B17d below row 64 kept", BAND_H0 + 15'd640, 4'd1);

        // ---------------- B18 连打两发：隧道每次正好推进 2 格（10 像素）----------------
        // 第一发打通 行 58..59，坦克往前开 2 格（10 像素）后再打，第二发打通 行 56..57：
        // 洞和坦克的脚下一格不差，不会留下“半格残砖”把坦克卡住。
        do_reset;
        tank_x = 10'd400; tank_y = 10'd300; tank_dir = 2'b00;
        for (j = 79; j <= 84; j = j + 1) begin
            poke(15'd8800 + j[14:0], 4'd1);   // 行 55：洞外
            poke(15'd8960 + j[14:0], 4'd1);   // 行 56
            poke(15'd9120 + j[14:0], 4'd1);   // 行 57
            poke(15'd9280 + j[14:0], 4'd1);   // 行 58
            poke(15'd9440 + j[14:0], 4'd1);   // 行 59
        end
        fire; wait_cycles(200);               // 第一发
        check_terrain("B18a shot1 row 58 cleared", 15'd9280 + 15'd81, 4'd0);
        check_terrain("B18b shot1 row 59 cleared", 15'd9440 + 15'd81, 4'd0);
        check_terrain("B18c shot1 row 57 kept",    15'd9120 + 15'd81, 4'd1);

        wait_cycles(COOLDOWN);                // 等冷却
        tank_y = 10'd290;                     // 坦克往前开 2 格
        fire; wait_cycles(200);               // 第二发
        check_terrain("B18d shot2 row 57 cleared", 15'd9120 + 15'd81, 4'd0);
        check_terrain("B18e shot2 row 56 cleared", 15'd8960 + 15'd81, 4'd0);
        check_terrain("B18f shot2 row 55 kept",    15'd8800 + 15'd81, 4'd1);
        check_terrain("B18g tunnel col 79 kept",   15'd9120 + 15'd79, 4'd1);
        check_terrain("B18h tunnel col 84 kept",   15'd9120 + 15'd84, 4'd1);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule
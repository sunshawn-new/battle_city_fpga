`timescale 1ns / 1ps
// ============================================================================
// 地形碰撞仿真测试台（xsim）
//
// 地图不是手写的：run_sim.ps1 会把工程根目录的 map.coe 转成 map_mem.hex，
// bram_stubs.v 用 $readmemh 加载 —— 仿真的就是板子里那张真地图。
// 真实地图要素（从 blk_mem_gen_0.mif 逐格核对过）：
//   外墙 : 行 0 / 行 119 / 列 0 / 列 159
//   砖块 : 行 40~54 ，列 30~49
//   河流 : 行 60~65 ，列 20~69 和 91~139（缺口 = 列 70~90，也就是桥）
//   树林 : 行 20~39 ，列 120~149
//   基地 : 行 108~118，列 72~87（内部行 112~117 / 列 76~83 是基地本体）
//
// 仿真用 MOVE_DIV=200 代替板上的 4_000_000。坦克现在是【整格移动】：
// 每个 move_tick 走一整格 TILE=5 像素（见 player.v 的说明），地形扫描约 22 拍，
// 200 拍足够它完成。所以下面的 step_ticks(n) 表示“走 n 像素”，内部换算成 n/5 格。
// ============================================================================
module tb_terrain;
    localparam MOVE_DIV = 200;

    reg clock = 1'b0;
    reg reset = 1'b1;
    reg btn_up = 1'b0, btn_down = 1'b0, btn_left = 1'b0, btn_right = 1'b0;
    reg btn_fire = 1'b0;    // 本测试台不开火（炮弹逻辑由 tb_bullet 覆盖）

    wire [11:0] disp_RGB;
    wire hsync, vsync;

    always #5 clock = ~clock;   // 100MHz

    top #(.MOVE_DIV(MOVE_DIV)) u_top(
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
        begin
            reset = 1'b1;
            btn_up = 0; btn_down = 0; btn_left = 0; btn_right = 0;
            repeat (10) @(posedge clock);
            reset = 1'b0;
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

        // ---- 出生点四方向：这就是“空气墙”bug 的回归测试 ----
        do_reset;                                  // 出生点 (400,300)
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T01 spawn -> up (was stuck)", 10'd400, 10'd290);

        do_reset;
        btn_down = 1'b1;  step_ticks(10); btn_down = 1'b0;
        check_pos("T02 spawn -> down (river gap)", 10'd400, 10'd310);

        do_reset;
        btn_left = 1'b1;  step_ticks(10); btn_left = 1'b0;
        check_pos("T03 spawn -> left", 10'd390, 10'd300);

        do_reset;
        btn_right = 1'b1; step_ticks(10); btn_right = 1'b0;
        check_pos("T04 spawn -> right", 10'd410, 10'd300);

        // ---- 连续前进 60 像素：中途不能卡住 ----
        do_reset;
        btn_up = 1'b1;    step_ticks(60); btn_up = 1'b0;
        check_pos("T05 spawn -> up 60px continuous", 10'd400, 10'd240);

        // ---- 河流挡住右边（缺口是列 70~90，列 91 已经是河）----
        do_reset; place_tank(10'd430, 10'd300);
        btn_right = 1'b1; step_ticks(20); btn_right = 1'b0;
        check_pos("T06 right blocked by river", 10'd435, 10'd300);

        // ---- 桥：从缺口上下横穿河流 ----
        do_reset; place_tank(10'd400, 10'd290);
        btn_down = 1'b1;  step_ticks(20); btn_down = 1'b0;
        check_pos("T07 down across river via bridge", 10'd400, 10'd310);

        // ---- 砖块切角：正前方 5 格里只有最左一格是砖，也必须挡住 ----
        do_reset; place_tank(10'd245, 10'd280);
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T08 up blocked by brick corner", 10'd245, 10'd275);

        // ---- 河流：下方一格都不能进 ----
        do_reset; place_tank(10'd250, 10'd280);
        btn_down = 1'b1;  step_ticks(10); btn_down = 1'b0;
        check_pos("T09 down blocked by river", 10'd250, 10'd280);

        // ---- 树林可以通行 ----
        do_reset; place_tank(10'd610, 10'd200);
        btn_up = 1'b1;    step_ticks(10); btn_up = 1'b0;
        check_pos("T10 up into woods (passable)", 10'd610, 10'd190);

        // ---- 向左撞砖块 ----
        do_reset; place_tank(10'd245, 10'd270);
        btn_left = 1'b1;  step_ticks(10); btn_left = 1'b0;
        check_pos("T11 left blocked by brick", 10'd245, 10'd270);

        // ---- 钢铁（本地图没有，直接写进 BRAM）：挡住；擦掉后能走 ----
        // 地址 = 行*160 + 列；行 59 = 9440，坦克所在的列是 80~83
        do_reset;                                   // (400,300)
        for (j = 80; j <= 84; j = j + 1) poke(15'd9440 + j[14:0], 4'd2);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T12a steel injected blocks", 10'd400, 10'd300);

        for (j = 80; j <= 84; j = j + 1) poke(15'd9440 + j[14:0], 4'd0);
        wait_refresh;
        btn_up = 1'b1;    step_ticks(5); btn_up = 1'b0;
        check_pos("T12b steel removed -> moves", 10'd400, 10'd295);

        // ---- 基地砖墙（行 108 起）挡住向下的路 ----
        do_reset; place_tank(10'd400, 10'd480);
        btn_down = 1'b1;  step_ticks(50); btn_down = 1'b0;
        check_pos("T13 down blocked by base brick", 10'd400, 10'd520);

        // ---- T14 格点不变量：坐标必须永远是 TILE(5) 的倍数 ----
        // 这是炮弹系统（bullet-ctrl.v）按格判定的前提：坦克一旦停在非格点上，
        // 炮口就不再落在格边界，10x10 的弹体就会跨 3 格，打出的洞也会偏心。
        do_reset;                                   // (400,300)
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

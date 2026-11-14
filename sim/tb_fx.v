`timescale 1ns / 1ps
// ============================================================================
// 爆炸特效仿真测试台（xsim）：fx_ctrl 的池 / 分配 / 相位 / 帧 / 边界
//
// 只测 fx_ctrl 本身（不测像素）。VGA 那边的叠加在预览图里看。
// 为了跑得快，FX_DIV 缩到 8 拍、FX_PHASES 保持 6（和 top.v 里写死的一致）。
//
// 期望的分配顺序（改了分配规则这里要跟着改）：
//   请求 rq：0..N_E-1 = 敌人 0..N_E-1，N_E = 玩家
//   分配循环从 rq = N_E 往 rq = 0 扫，每个请求占“当前最靠后的空闲槽”
//   -> 同一拍全死时：玩家 -> 槽 3，敌人 2 -> 槽 2，敌人 1 -> 槽 1，敌人 0 -> 槽 0
// ============================================================================
module tb_fx;
    localparam N_E       = 3;
    localparam N_FX      = 4;
    localparam FX_DIV    = 8;
    localparam FX_PHASES = 6;

    reg clock = 1'b0;
    reg reset = 1'b1;

    reg [N_E-1:0]    e_kill = {N_E{1'b0}};
    reg [N_E*10-1:0] e_x = {(N_E*10){1'b0}};
    reg [N_E*10-1:0] e_y = {(N_E*10){1'b0}};
    reg              p_kill = 1'b0;
    reg [9:0]        p_x = 10'd0;
    reg [9:0]        p_y = 10'd0;

    wire [N_FX-1:0]    fx_valid;
    wire [N_FX*10-1:0] fx_x, fx_y;
    wire [N_FX*2-1:0]  fx_frame;

    always #5 clock = ~clock;   // 100MHz

    fx_ctrl #(
        .N_FX(N_FX), .N_E(N_E),
        .FX_DIV(FX_DIV), .FX_PHASES(FX_PHASES)
    ) dut (
        .clock(clock), .reset(reset),
        .e_kill(e_kill), .e_x(e_x), .e_y(e_y),
        .p_kill(p_kill), .p_x(p_x), .p_y(p_y),
        .fx_valid(fx_valid), .fx_x(fx_x), .fx_y(fx_y), .fx_frame(fx_frame)
    );

    integer errors = 0;

    // ---------------- 通用检查 ----------------
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

    // 检查某个槽的坐标
    task check_slot;
        input [8*46-1:0] name;
        input integer    slot;
        input [9:0]      exp_x;
        input [9:0]      exp_y;
        begin
            if (fx_x[slot*10 +: 10] !== exp_x || fx_y[slot*10 +: 10] !== exp_y) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got (%0d,%0d), expected (%0d,%0d)", name,
                         fx_x[slot*10 +: 10], fx_y[slot*10 +: 10], exp_x, exp_y);
            end else begin
                $display("[ OK ] %0s : slot %0d = (%0d,%0d)", name, slot,
                         fx_x[slot*10 +: 10], fx_y[slot*10 +: 10]);
            end
        end
    endtask

    // 检查某个槽的当前帧（0 = 亮爆团，1 = 星形环）
    task check_frame;
        input [8*46-1:0] name;
        input integer    slot;
        input integer    exp;
        begin
            if (fx_frame[slot*2 +: 2] !== exp[1:0]) begin
                errors = errors + 1;
                $display("[FAIL] %0s : got %0d, expected %0d", name,
                         fx_frame[slot*2 +: 2], exp);
            end else begin
                $display("[ OK ] %0s : %0d", name, fx_frame[slot*2 +: 2]);
            end
        end
    endtask


    // ---------------- 单拍脉冲：第 i 辆敌人在 (x,y) 被击毁 ----------------
    task kill_enemy;
        input integer i;
        input [9:0]   x;
        input [9:0]   y;
        begin
            @(negedge clock);
            e_x[i*10 +: 10] = x;
            e_y[i*10 +: 10] = y;
            e_kill          = {N_E{1'b0}};
            e_kill[i]       = 1'b1;
            @(negedge clock);
            e_kill          = {N_E{1'b0}};
        end
    endtask

    // ---------------- 单拍脉冲：玩家在 (x,y) 被打中 ----------------
    task kill_player;
        input [9:0] x;
        input [9:0] y;
        begin
            @(negedge clock);
            p_x    = x;
            p_y    = y;
            p_kill = 1'b1;
            @(negedge clock);
            p_kill = 1'b0;
        end
    endtask

    // 等 n 个时钟再检查。注意用 negedge 返回：在 @(posedge) 的同一时间点读信号
    // 会读到"这一拍打拍之前"的老值（NBA 还没生效），测试台会整体差一拍。
    task wait_clk;
        input integer n;
        begin
            repeat (n) @(negedge clock);
        end
    endtask

    task do_reset;
        begin
            reset  = 1'b1;
            e_kill = {N_E{1'b0}};
            p_kill = 1'b0;
            repeat (4) @(posedge clock);
            reset = 1'b0;
            repeat (2) @(negedge clock);
        end
    endtask


    initial begin
        $display("=========== explosion fx test (pool / phase / frame) ===========");

        // ---------------- X01 复位后没有爆炸 ----------------
        do_reset;
        check_int("X01 no explosion after reset", fx_valid, 0);

        // ---------------- X02 击毁一辆敌人：占最高槽，坐标就是死亡位置 ----------------
        kill_enemy(0, 10'd40, 10'd10);
        check_int("X02a one slot busy", fx_valid, 4'b1000);
        check_slot("X02b slot3 at dead tank pos", 3, 10'd40, 10'd10);

        // ---------------- X03 前三个相位放"亮爆团"，第 4 个相位换"星形环" ----------------
        // n = 分配之后经过了多少个 posedge；相位 = n/FX_DIV，帧 0 = 相位 0..2
        wait_clk(FX_DIV * 3 - 1);                       // n = 23 = 相位 2 的最后一拍
        check_frame("X03a phase2 still frame0", 3, 0);
        wait_clk(1);                                    // n = 24 -> 相位 3
        check_frame("X03b phase3 -> frame1",    3, 1);

        // ---------------- X04 相位 5 还是星形环，走完这一拍就释放 ----------------
        wait_clk(FX_DIV * 3 - 1);                       // n = 47
        check_frame("X04a phase5 still frame1", 3, 1);
        check_int("X04b busy until the last cycle", fx_valid, 4'b1000);
        wait_clk(1);                                    // n = 48 = 6 个相位走完
        check_int("X04c released after 6 phases", fx_valid, 0);

        // ---------------- X05 玩家被打中：爆炸落在玩家位置 ----------------
        kill_player(10'd300, 10'd300);
        check_int("X05a player explosion started", fx_valid, 4'b1000);
        check_slot("X05b slot3 at player pos", 3, 10'd300, 10'd300);
        wait_clk(FX_DIV * FX_PHASES);

        // ---------------- X06 同一拍两辆敌人被击毁：两个槽，各自坐标 ----------------
        do_reset;
        @(negedge clock);
        e_x[0*10 +: 10] = 10'd40;  e_y[0*10 +: 10] = 10'd10;
        e_x[1*10 +: 10] = 10'd300; e_y[1*10 +: 10] = 10'd10;
        e_kill = 3'b011;
        @(negedge clock);
        e_kill = 3'b000;
        check_int("X06a two slots busy", fx_valid, 4'b1100);
        check_slot("X06b slot3 = enemy1",  3, 10'd300, 10'd10);
        check_slot("X06c slot2 = enemy0",  2, 10'd40,  10'd10);
        wait_clk(FX_DIV * FX_PHASES);
        check_int("X06d both released", fx_valid, 0);

        // ---------------- X07 最坏情况：3 辆敌人 + 玩家同拍全死 -> 4 个槽 ----------------
        do_reset;
        @(negedge clock);
        e_x[0*10 +: 10] = 10'd40;  e_y[0*10 +: 10] = 10'd80;
        e_x[1*10 +: 10] = 10'd300; e_y[1*10 +: 10] = 10'd80;
        e_x[2*10 +: 10] = 10'd560; e_y[2*10 +: 10] = 10'd80;
        p_x    = 10'd300;
        p_y    = 10'd400;
        e_kill = 3'b111;
        p_kill = 1'b1;
        @(negedge clock);
        e_kill = 3'b000;
        p_kill = 1'b0;
        check_int("X07a all four slots busy", fx_valid, 4'b1111);
        check_slot("X07b slot3 = player",  3, 10'd300, 10'd400);
        check_slot("X07c slot2 = enemy2",  2, 10'd560, 10'd80);
        check_slot("X07d slot1 = enemy1",  1, 10'd300, 10'd80);
        check_slot("X07e slot0 = enemy0",  0, 10'd40,  10'd80);

        // ---------------- X08 池满时再来的请求被丢掉（不覆盖正在放的爆炸）----------------
        kill_enemy(0, 10'd5, 10'd5);
        check_int("X08a still four busy", fx_valid, 4'b1111);
        check_slot("X08b slot0 keeps its coords", 0, 10'd40, 10'd80);

        // ---------------- X09 放完之后槽可以复用 ----------------
        wait_clk(FX_DIV * FX_PHASES);
        check_int("X09a pool drained", fx_valid, 0);
        kill_enemy(2, 10'd560, 10'd10);
        check_int("X09b slot reusable", fx_valid, 4'b1000);
        check_slot("X09c new coords in slot3", 3, 10'd560, 10'd10);

        // ---------------- X10 放到一半复位：全部清掉 ----------------
        wait_clk(FX_DIV);
        do_reset;
        check_int("X10 reset clears explosion", fx_valid, 0);

        // ---------------- X11 两个槽的相位各自独立（后开的从第 0 相位起）----------------
        kill_enemy(0, 10'd40, 10'd10);            // -> 槽 3
        wait_clk(FX_DIV * 4);                     // 槽 3 进到相位 4（第二帧）
        check_frame("X11a first explosion at frame1", 3, 1);
        kill_player(10'd300, 10'd300);            // 槽 3 还被占 -> 自动落到槽 2
        check_int("X11b second explosion in slot2", fx_valid, 4'b1100);
        check_slot("X11c slot2 at player pos", 2, 10'd300, 10'd300);
        check_frame("X11d second starts at frame0", 2, 0);
        check_frame("X11e first keeps its own phase", 3, 1);

        $display("==============================================");
        if (errors == 0) $display("ALL TESTS PASSED");
        else             $display("%0d TEST(S) FAILED", errors);
        $finish;
    end

endmodule

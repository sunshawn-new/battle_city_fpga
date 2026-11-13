`timescale 1ns / 1ps

module top #(
    parameter MOVE_DIV = 400_000   // 坦克移动节拍分频，仿真里会改小以加速
)(
    input clock,       // 100MHz
    input reset,
    input btn_up, btn_down, btn_left, btn_right,
    output [11:0] disp_RGB,
    output hsync,
    output vsync
);
    // ---------------- 地图 / 坦克尺寸 ----------------
    localparam MAP_W  = 160;    // 地图横向 160 格
    localparam MAP_H  = 120;    // 地图纵向 120 格
    localparam TILE   = 5;      // 每格 5x5 像素
    localparam TANK_W = 20;     // 坦克 20x20 像素（= 4x4 格）
    localparam TANK_H = 20;

    // 地形编号（和 pysrc/map_generator.py 保持一致）
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    wire [9:0] player_x, player_y;
    wire [3:0] player_terrain_in_front;
    wire       terrain_valid;
    wire       move_tick;              // 坦克的移动节拍（250Hz），用来定期刷新地形查询

    player #(.MOVE_DIV(MOVE_DIV)) u_player(
        .clock(clock), .reset(reset),
        .up_enable(btn_up), .down_enable(btn_down),
        .left_enable(btn_left), .right_enable(btn_right),
        .position_x(player_x), .position_y(player_y),
        .terrain_in_front(player_terrain_in_front),
        .terrain_valid(terrain_valid),
        .move_tick(move_tick)
    );

    wire [14:0] vga_map_addr;
    wire [3:0]  vga_tile_id;
    wire vga_clk;

    wire ram_wea  = 1'b0;
    wire [3:0] ram_dina = 4'd0;      // 需要等待炮弹来修改
    wire [3:0] ram_douta;            // Port A 读出的一格地形
    wire [14:0] ram_addra;           // 由下面的“前方地形查询”逻辑驱动

    // ---------------- 坦克朝向 ----------------
    // 00 上，01 下，10 左，11 右；优先级和 player 里的移动判断保持一致
    reg [1:0] player_direction = 2'b00;
    always @(posedge clock) begin
        if (reset)          player_direction <= 2'b00;
        else if (btn_up)    player_direction <= 2'b00;
        else if (btn_down)  player_direction <= 2'b01;
        else if (btn_left)  player_direction <= 2'b10;
        else if (btn_right) player_direction <= 2'b11;
    end

    // ---------------- 除 5 的快速写法 ----------------
    // 直接写 v / 5 会被 Vivado 综合成“移位-减法”除法器：实测 14 级 CARRY4、
    // 23 级逻辑、17ns 延迟（100MHz 下 WNS = -7.09ns，正是本设计最长的一条路径）。
    // 改成 “乘 205 再右移 10 位”：205/1024 = 1/5 + 1/5120，对 v <= 1023 恒定精确
    // （误差 v/5120 <= 0.1998 < 1 - (v mod 5)/5 的最小值 0.2），综合出来是
    // 几层移位加法 —— 实测 Vivado 直接把它映射成了 DSP48E1，8 个只占 8 个 DSP。
    // 本设计里参与除 5 的坐标最大是 800（snap_x + TANK_W），满足 <= 1023。
    function [7:0] div5;
        input [9:0] v;          // 0..1023
        reg [17:0] p;           // 1023*205 = 209715，18 位足够
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    // ---------------- 前方地形查询 ----------------
    // 坦克 20x20 像素（4x4 格），每次只移动 1 像素。向某个方向走一步时，
    // 前进方向上只会新进入 1 行（上下）或 1 列（左右），但这一行/列要横跨
    // 坦克的整个宽度/高度，最多 5 格（坐标不是 5 的倍数时是 5 格）。
    // 必须把这几个格子都查一遍：只要有一格不能通行，就认为前方被挡住。
    //
    // 这个查询曾经是“组合逻辑直接算地址”：
    //     snap_x(FF) -> /5 -> +cell -> 与 (snap_x+19)/5 比较 -> mux -> 移位加法 -> BRAM
    // 这条链上有两个除 5、一个比较器、一个 16 位加法，是本设计里最长的一条
    // 组合路径。而 constr.xdc 原本没有任何时钟约束，Vivado 既不分析也不为它
    // 做时序优化，100MHz 下很可能跑不动 —— BRAM 抓到的地址是错的，于是读到
    // 错的地图格子（多半是地址 0 的外墙砖），四个方向就全被“空气墙”挡住。
    //
    // 现在的结构（两级流水 + 每格 4 拍）：
    //   S_GEOM：用 1 拍把几何量算好写进寄存器（8 个 /5 并行，每路只有一个除法）
    //   S_SCAN：只用寄存器值拼地址（比较 + mux + 移位加法，很短），
    //           每格把地址保持 4 拍、第 3 拍采样 —— BRAM 读延迟 0/1/2/3 拍都能采对。
    // 另外每个移动节拍都会无条件重扫一次（front_valid 不清零，不影响本拍移动），
    // 这样即使某次读到了脏数据，最多 4ms 也会自动纠正，不会再被永久锁死。
    localparam S_IDLE = 2'd0,   // 空闲：等条件变化或刷新节拍
               S_GEOM = 2'd1,   // 1 拍：算格子范围 / 前进方向上的行或列
               S_SCAN = 2'd2;   // 5 格 x 5 拍：依次把地址送给 BRAM 并采样

    reg [1:0]  scan_state = S_IDLE;
    reg [2:0]  scan_phase = 3'd0;   // 0: 装地址；1~3: 保持；4: 采样本格 douta
    reg [2:0]  scan_cell  = 3'd0;   // 当前查询第几格（0~4）
    reg [3:0]  scan_worst = 4'd0;   // 已查到的“最硬”地形
    reg [9:0]  snap_x = 10'd0, snap_y = 10'd0; // 查询开始时锁存的坦克位置
    reg [1:0]  snap_dir = 2'b00;               // 查询开始时锁存的朝向
    reg [3:0]  front_terrain = 4'd0;           // 查询结果
    reg        front_valid   = 1'b0;           // 查询结果有效

    // 几何量锁存：由 S_GEOM 一拍算好，S_SCAN 阶段只读这些寄存器
    reg [7:0] g_tx_first = 8'd0, g_tx_last = 8'd0;   // 坦克覆盖的列范围
    reg [7:0] g_ty_first = 8'd0, g_ty_last = 8'd0;   // 坦克覆盖的行范围
    reg [7:0] g_front_up = 8'd0, g_front_down = 8'd0;    // 上前方行 / 下前方行
    reg [7:0] g_front_left = 8'd0, g_front_right = 8'd0; // 左前方列 / 右前方列

    wire scan_busy = (scan_state != S_IDLE);

    // 位置或朝向变了，之前的结果就作废，需要重新查
    wire query_changed = (player_x != snap_x) || (player_y != snap_y) ||
                         (player_direction != snap_dir);

    assign player_terrain_in_front = front_terrain;
    // 只有“查询完成”且“查询条件就是当前的位置/朝向”时，结果才可信
    assign terrain_valid           = front_valid && !query_changed;

    wire [7:0] cell_idx = {5'd0, scan_cell};
    // 沿坦克宽度/高度依次取格；超出坦克范围就夹到最后一行/列（重复读同一格无害）。
    // 注意这里只读 S_GEOM 锁存好的 g_* 寄存器，地址路径很短。
    wire [7:0] scan_col_i = (g_tx_first + cell_idx > g_tx_last) ? g_tx_last
                                                                : g_tx_first + cell_idx;
    wire [7:0] scan_row_i = (g_ty_first + cell_idx > g_ty_last) ? g_ty_last
                                                                : g_ty_first + cell_idx;

    reg [7:0] scan_row, scan_col;
    always @(*) begin
        case (snap_dir)
            // 上下：整行横跨坦克宽度
            2'b00: begin scan_row = g_front_up;    scan_col = scan_col_i;     end
            2'b01: begin scan_row = g_front_down;  scan_col = scan_col_i;     end
            // 左右：整列纵跨坦克高度
            2'b10: begin scan_row = scan_row_i;    scan_col = g_front_left;   end
            default: begin scan_row = scan_row_i;  scan_col = g_front_right;  end
        endcase
    end

    // row * 160 + col（160 = 128 + 32，用移位代替乘法）
    // 最大 119*160 + 159 = 19199，15 位地址足够，不会像 player_y*160 那样溢出
    wire [15:0] scan_row_base = ({8'd0, scan_row} << 7) + ({8'd0, scan_row} << 5);
    wire [15:0] scan_addr     = scan_row_base + {8'd0, scan_col};

    // 地址多打一拍再送 BRAM。
    // 直接组合送出去时，这条路径（scan_cell -> 比较/mux -> 移位加法 -> BRAM 地址）
    // 实测 7.97ns：逻辑 7 级 + 到 RAMB36 的长走线，虽然 100MHz 能过但只剩 1.2ns 余量，
    // 而且是全设计最紧的一簇。打一拍后 BRAM 地址直接来自 FF，S_SCAN 每格有 5 拍，
    // 完全可以容纳这额外的 1 拍（第 0 拍装地址，1~3 拍保持，第 4 拍采样）。
    reg [14:0] scan_addr_r = 15'd0;
    assign ram_addra = scan_addr_r;

    // 取两个地形中“最硬”的一个：只要有一格不能通行，就按不能通行处理
    function [3:0] merge_terrain;
        input [3:0] a;
        input [3:0] b;
        begin
            if      (a == T_BRICK || a == T_STEEL || a == T_RIVER || a == T_BASE)
                merge_terrain = a;
            else if (b == T_BRICK || b == T_STEEL || b == T_RIVER || b == T_BASE)
                merge_terrain = b;
            else if (a == T_WOODS || b == T_WOODS)
                merge_terrain = T_WOODS;   // 树林可以通行
            else
                merge_terrain = T_EMPTY;
        end
    endfunction

    always @(posedge clock) begin
        if (reset) begin
            scan_state    <= S_IDLE;
            scan_phase    <= 3'd0;
            scan_cell     <= 3'd0;
            scan_worst    <= 4'd0;
            snap_x        <= 10'd0;
            snap_y        <= 10'd0;
            snap_dir      <= 2'b00;
            g_tx_first    <= 8'd0;
            g_tx_last     <= 8'd0;
            g_ty_first    <= 8'd0;
            g_ty_last     <= 8'd0;
            g_front_up    <= 8'd0;
            g_front_down  <= 8'd0;
            g_front_left  <= 8'd0;
            g_front_right <= 8'd0;
            scan_addr_r   <= 15'd0;
            front_terrain <= 4'd0;
            front_valid   <= 1'b0;
        end else case (scan_state)
            S_IDLE: begin
                // 结果还没有 / 位置或朝向变了 / 到了移动节拍（定期刷新，自愈）
                if (!front_valid || query_changed || move_tick) begin
                    snap_x     <= player_x;
                    snap_y     <= player_y;
                    snap_dir   <= player_direction;
                    scan_cell  <= 3'd0;
                    scan_worst <= 4'd0;
                    scan_phase <= 2'd0;
                    scan_state <= S_GEOM;
                    // 只有“查询条件真的变了”才把旧结果作废；
                    // 定时刷新时保留旧结果，这样本拍的移动不会被拖住
                    if (query_changed) front_valid <= 1'b0;
                end
            end
            S_GEOM: begin
                // 除 5 用 div5()（乘 205 右移 10），Vivado 综合成移位加法，
                // 直接写 / 5 会被综合成 17ns 的移位减法除法器
                g_tx_first <= div5(snap_x);                     // 左边缘所在列
                g_tx_last  <= div5(snap_x + TANK_W - 1);        // 右边缘所在列
                g_ty_first <= div5(snap_y);                     // 上边缘所在行
                g_ty_last  <= div5(snap_y + TANK_H - 1);        // 下边缘所在行
                // 前进方向上“新进入”的那一行/列
                g_front_up    <= (snap_y == 10'd0) ? 8'd0
                               : div5(snap_y - 10'd1);
                g_front_down  <= (snap_y + TANK_H >= MAP_H * TILE) ? (MAP_H - 1)
                               : div5(snap_y + TANK_H);
                g_front_left  <= (snap_x == 10'd0) ? 8'd0
                               : div5(snap_x - 10'd1);
                g_front_right <= (snap_x + TANK_W >= MAP_W * TILE) ? (MAP_W - 1)
                               : div5(snap_x + TANK_W);
                scan_phase <= 3'd0;
                scan_state <= S_SCAN;
            end
            default: begin // S_SCAN
                if (scan_phase != 3'd4) begin
                    // 每格第 0 拍把这一格的地址锁进 scan_addr_r（下一拍起 BRAM 就读它）
                    if (scan_phase == 3'd0) scan_addr_r <= scan_addr[14:0];
                    scan_phase <= scan_phase + 3'd1;   // 地址保持 5 拍，等 BRAM 读稳
                end else if (scan_cell == 3'd4) begin
                    // 5 个格子查完（第 5 格可能和第 4 格重复，读到同一个值无害）
                    front_terrain <= merge_terrain(scan_worst, ram_douta);
                    front_valid   <= 1'b1;
                    scan_state    <= S_IDLE;
                    scan_phase    <= 3'd0;
                end else begin
                    scan_worst <= merge_terrain(scan_worst, ram_douta);
                    scan_cell  <= scan_cell + 3'd1;
                    scan_phase <= 3'd0;
                end
            end
        endcase
    end

    vga u_vga(
        .clock(clock), .reset(reset),
        .position_x(player_x), .position_y(player_y),
        .map_addr(vga_map_addr),
        .tile_id(vga_tile_id),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync),
        .vga_clk(vga_clk),
        .player_direction(player_direction),
        .terrain_valid(terrain_valid),
        .terrain_in_front(player_terrain_in_front)
    );

    blk_mem_gen_0 u_map_ram (
        // ========== Port A (系统总线：玩家查询，未来子弹写) ==========
        .clka  (clock),           
        .wea   (ram_wea),         // 仲裁器给出的写使能
        .addra (ram_addra),       // 前方地形查询地址
        .dina  (ram_dina),        // 仲裁器给出的写入数据
        .douta (ram_douta),       // A端口的读出数据（前方地形查询用）
        
        // ========== Port B (VGA 渲染：纯粹只读) ==========
        .clkb  (vga_clk),         
        .web   (1'b0),            // VGA 永远不写
        .addrb (vga_map_addr),    
        .dinb  (4'd0),            // 永远不写，补 0
        .doutb (vga_tile_id)      // 给 VGA 模块渲染画面
    );

endmodule
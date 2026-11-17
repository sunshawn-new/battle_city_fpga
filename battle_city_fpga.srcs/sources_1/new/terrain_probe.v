`timescale 1ns / 1ps

// ============================================================================
//  terrain_probe —— 可复用的「前方地形」查询引擎
//
//  本模块是把原来写死在 top.v 里的三级状态机原样抽出来的：
//    S_GEOM : 1 拍内算好“坦克覆盖的格子范围”和“前进方向上那一行/列”
//    S_SCAN : 5 格 x 5 拍，逐格把地址送给地图 BRAM，并在第 4 拍采样 douta
//
//  为什么要抽成模块：
//    敌方坦克以后要做和玩家完全一样的“前进方向跨边缘扫描”。与其复制一份
//    状态机（两份代码各自演进，早晚不一致），不如做成带 req/gnt 语义的模块：
//    每个实例自己维护 snapshot 和“结果是否过期”，顶层只要把实时的坐标/朝向
//    接进来，读 terrain/valid 就行。敌方坦克 = 再 new 一个实例，在 map_bus
//    的 p_req 上多占一位。
//
//  为什么需要 map_req / map_gnt：
//    地图 BRAM 的 Port A 是共享资源（地形查询 + 炮弹命中去读/改写同一块地图）。
//    这里不直接驱动地址，而是向 map_bus 申请一段“独占窗口”：从进入 S_GEOM
//    到 S_SCAN 结束，map_req 一直保持为 1，仲裁器在窗口内不会把地址切给别人，
//    因此扫描过程中 douta 一定是自己那 5 格的数据 —— 与 BRAM 读延迟 0~3 拍
//    无关（每格地址保持 5 拍、第 4 拍采样，容忍 <= 3 拍延迟）。
//    总线空闲时 map_gnt 是组合给出的，所以正常情况下不会比原来多花任何拍数。
//
//  时序（和抽出来之前完全一致，原来的 15 条仿真断言仍然成立）：
//    地址路径被刻意切成“FF -> 比较/mux -> 移位加法 -> BRAM”，
//    S_SCAN 第 0 拍把地址锁进 map_addr，1~3 拍保持，第 4 拍采样。
//
//  资源（C 方案）：坐标恒为 TILE=5 的整数倍，所以 S_GEOM 里原来 8 次 div5
//    （乘 205 右移 10，每次被吸收成 1 个 DSP48E1）收敛成 2 次（col0 = x/5、
//    row0 = y/5），其余 6 个边界值由 ±常数得到：本实例 8 DSP -> 2 DSP，
//    全设计 34 -> 10 个 DSP（4 个实例 + 炮弹的 2 个）。功能逐格等价。
// ============================================================================
module terrain_probe #(
    parameter MAP_W  = 120,     // 地图横向格数（600px / 5）
    parameter MAP_H  = 120,     // 地图纵向格数
    parameter TILE   = 5,       // 每格像素
    parameter TANK_W = 20,      // 宿主（坦克）宽
    parameter TANK_H = 20       // 宿主（坦克）高
)(
    input             clock,
    input             reset,
    // ---------------- 宿主（坦克）的实时状态 ----------------
    input      [9:0]  x,
    input      [9:0]  y,
    input      [1:0]  dir,          // 00 上，01 下，10 左，11 右
    input             refresh,      // 周期性刷新脉冲（顶层接 move_tick，用于自愈）
    // ---------------- 地图总线（窗口式握手）----------------
    output            map_req,      // 事务窗口内保持为 1
    output     [14:0] map_addr,
    input             map_gnt,
    input      [3:0]  map_dout,
    // ---------------- 查询结果 ----------------
    output     [3:0]  terrain,
    output            valid          // 结果有效，且查询条件等于当前的 x/y/dir
);
    // 地形编号（和 pysrc/map_generator.py 保持一致）
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    localparam S_IDLE = 2'd0,   // 空闲：等条件变化或刷新节拍
               S_GEOM = 2'd1,   // 1 拍：算格子范围 / 前进方向上的行或列
               S_SCAN = 2'd2;   // 5 格 x 5 拍：依次把地址送给 BRAM 并采样

    reg [1:0]  scan_state = S_IDLE;
    reg [2:0]  scan_phase = 3'd0;   // 0: 装地址；1~3: 保持；4: 采样本格 douta
    reg [2:0]  scan_cell  = 3'd0;   // 当前查询第几格（0~4）
    reg [3:0]  scan_worst = 4'd0;   // 已查到的“最硬”地形
    reg [9:0]  snap_x = 10'd0, snap_y = 10'd0;  // 查询开始时锁存的宿主位置
    reg [1:0]  snap_dir = 2'b00;                // 查询开始时锁存的朝向
    reg [3:0]  front_terrain = 4'd0;            // 查询结果
    reg        front_valid   = 1'b0;            // 查询结果有效

    // 几何量锁存：由 S_GEOM 一拍算好，S_SCAN 阶段只读这些寄存器
    reg [7:0] g_tx_first = 8'd0, g_tx_last = 8'd0;       // 坦克覆盖的列范围
    reg [7:0] g_ty_first = 8'd0, g_ty_last = 8'd0;       // 坦克覆盖的行范围
    reg [7:0] g_front_up = 8'd0, g_front_down = 8'd0;    // 上前方行 / 下前方行
    reg [7:0] g_front_left = 8'd0, g_front_right = 8'd0; // 左前方列 / 右前方列
    reg [14:0] scan_addr_r = 15'd0;                      // 送 BRAM 的地址（寄存一拍）

    // 扫描窗口 = 占用地图总线的时间窗
    assign map_req  = (scan_state != S_IDLE);
    assign map_addr = scan_addr_r;

    // 位置或朝向变了，之前的结果就作废，需要重新查
    wire query_changed = (x != snap_x) || (y != snap_y) || (dir != snap_dir);

    // 前进方向已经贴着玩区边缘：那一行/列根本不存在，按“挡住”处理。
    // 不这么做的话下面的 g_front_up/g_front_down/... 会把越界的行列夹回车身
    // 自己身上，探针于是报“空地”，而坦克的移动又会被 y/x 的边界判断拦住 ——
    // 表现是敌人选了“上”、发现一步也走不动、stuck 还清零，最后钉在顶边朝上。
    // （敌人出生点就在 y=0，这条路径在正常游戏里一定会被走到。）
    wire edge_blocked =
        (snap_dir == 2'b00) && (snap_y == 10'd0) ||
        (snap_dir == 2'b01) && (snap_y + TANK_H >= MAP_H * TILE) ||
        (snap_dir == 2'b10) && (snap_x == 10'd0) ||
        (snap_dir == 2'b11) && (snap_x + TANK_W >= MAP_W * TILE);

    assign terrain = front_terrain;
    // 只有“查询完成”且“查询条件就是当前的位置/朝向”时，结果才可信
    assign valid   = front_valid && !query_changed;

    wire [7:0] cell_idx = {5'd0, scan_cell};
    // 沿坦克宽度/高度依次取格；超出坦克范围就夹到最后一行/列（重复读同一格无害）。
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

    // row * MAP_W + col。当前 MAP_W = 120 = 128 - 8，写成 (row<<7) - (row<<3)，
    // 只有两级移位 + 一级加法（比 *160 的 128+32 还少一次进位链）。
    // 最大 119*120 + 119 = 14399，15 位地址足够（BRAM 深度 19200，尾部空着）。
    // 注意：改地图宽度时这里必须跟着改 —— 别处不要再出现 *160 这类魔法数。
    wire [15:0] scan_row_base = ({8'd0, scan_row} << 7) - ({8'd0, scan_row} << 3);
    wire [15:0] scan_addr     = scan_row_base + {8'd0, scan_col};
    // 除 5 的快速写法：直接写 v / 5 会被 Vivado 综合成“移位-减法”除法器
    // （实测 14 级 CARRY4、23 级逻辑、17ns）。改用“乘 205 再右移 10 位”：
    // 205/1024 = 1/5 + 1/5120，对 v <= 1023 恒定精确，综合成几层移位加法
    // （实测 Vivado 直接把它映射成了 DSP48E1）。
    function [7:0] div5;
        input [9:0] v;          // 0..1023
        reg [17:0] p;           // 1023*205 = 209715，18 位足够
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    // ---- 车身覆盖的格数（TANK_W/TANK_H = 20、TILE = 5 -> 正好 4 格）----
    // 坐标恒为 TILE 的整数倍（player/enemy_ctrl 整格移动，见文件顶部的“不变量”），
    // 因此边界值只需要一次除法再加常数：
    //   div5(x + TANK_W - 1) = col0 + 3    div5(x - 1) = col0 - 1    div5(x + TANK_W) = col0 + 4
    //   div5(y + TANK_H - 1) = row0 + 3    div5(y - 1) = row0 - 1    div5(y + TANK_H) = row0 + 4
    // 以前这里调用了 8 次 div5，Vivado 把它们全部吸收进 DSP48E1（4 个实例 = 32 个 DSP）；
    // 收敛成 2 次之后每个实例只占 2 个 DSP（全设计 34 -> 10），组合锥也短了。
    localparam [7:0] COL_LAST = (TANK_W - 1) / TILE;   // 右边缘相对列偏移 = 3
    localparam [7:0] ROW_LAST = (TANK_H - 1) / TILE;   // 下边缘相对行偏移 = 3
    localparam [7:0] COL_NEXT = TANK_W / TILE;         // 前进方向多探一格 = 4
    localparam [7:0] ROW_NEXT = TANK_H / TILE;

    wire [7:0] col0 = div5(x);      // 车身左边缘所在列
    wire [7:0] row0 = div5(y);      // 车身上边缘所在行

    // 上面这套“±常数”的等价替换依赖【坐标恒为 TILE 的整数倍】这条不变量
    // （player/enemy_ctrl 每次移动走整格；出生点 290/580、40/300/560 也都是 5 的倍数）。
    // 仿真时兜一层：万一以后有测试台把坦克摆到不对齐的坐标，这里会直接报出来，
    // 免得“前方地形查错格”这种 bug 变成难查的现象。综合时整段被去掉。
`ifndef SYNTHESIS
    always @(posedge clock)
        if (!reset && (((x % TILE) != 0) || ((y % TILE) != 0)))
            $display("[terrain_probe] ERROR: x=%0d y=%0d 不是 TILE=%0d 的整数倍", x, y, TILE);
`endif

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
                if (!front_valid || query_changed || refresh) begin
                    snap_x     <= x;
                    snap_y     <= y;
                    snap_dir   <= dir;
                    scan_cell  <= 3'd0;
                    scan_worst <= 4'd0;
                    scan_phase <= 3'd0;
                    scan_state <= S_GEOM;
                    // 只有“查询条件真的变了”才把旧结果作废；
                    // 定时刷新时保留旧结果，这样本拍的移动不会被拖住
                    if (query_changed) front_valid <= 1'b0;
                end
            end
            S_GEOM: begin
                // 等总线的独占窗口：总线空闲时 map_gnt 与本拍的 map_req 同时成立，
                // 完全不额外花拍数；被炮弹占用时在这里等（最长几十拍，62.5Hz 无感）。
                if (map_gnt) begin
                    // 【只除 2 次】其余 6 个边界值由 col0/row0 加常数得到（见上面的说明）
                    g_tx_first <= col0;                     // 左边缘所在列
                    g_tx_last  <= col0 + COL_LAST;          // 右边缘所在列
                    g_ty_first <= row0;                     // 上边缘所在行
                    g_ty_last  <= row0 + ROW_LAST;          // 下边缘所在行
                    // 前进方向上“新进入”的那一行/列
                    g_front_up    <= (y == 10'd0) ? 8'd0
                                   : (row0 - 8'd1);
                    g_front_down  <= (y + TANK_H >= MAP_H * TILE) ? (MAP_H - 1)
                                   : (row0 + ROW_NEXT);
                    g_front_left  <= (x == 10'd0) ? 8'd0
                                   : (col0 - 8'd1);
                    g_front_right <= (x + TANK_W >= MAP_W * TILE) ? (MAP_W - 1)
                                   : (col0 + COL_NEXT);
                    scan_phase <= 3'd0;
                    scan_state <= S_SCAN;
                end
            end
            default: begin // S_SCAN
                if (scan_phase != 3'd4) begin
                    // 每格第 0 拍把这一格的地址锁进 scan_addr_r（下一拍起 BRAM 就读它）
                    if (scan_phase == 3'd0) scan_addr_r <= scan_addr[14:0];
                    scan_phase <= scan_phase + 3'd1;   // 地址保持 5 拍，等 BRAM 读稳
                end else if (scan_cell == 3'd4) begin
                    // 5 个格子查完（第 5 格可能和第 4 格重复，读到同一个值无害）
                    front_terrain <= edge_blocked ? T_BRICK
                                                  : merge_terrain(scan_worst, map_dout);
                    front_valid   <= 1'b1;
                    scan_state    <= S_IDLE;
                    scan_phase    <= 3'd0;
                end else begin
                    scan_worst <= merge_terrain(scan_worst, map_dout);
                    scan_cell  <= scan_cell + 3'd1;
                    scan_phase <= 3'd0;
                end
            end
        endcase
    end
endmodule

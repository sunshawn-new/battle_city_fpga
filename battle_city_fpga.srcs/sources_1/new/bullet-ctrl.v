`timescale 1ns / 1ps

// ============================================================================
//  bullet_ctrl —— 炮弹的「对象池」控制器
//
//  1) 对象池（Object Pool）
//     和 C 里预先 malloc 一个数组、用 free/used 标记复用是同一个思路，只是
//     在硬件里不能动态分配，所以：
//        · act[i]      : 槽位是否占用（对象池唯一的“位图”）
//        · x/y/dir[i]  : 每个槽的坐标和朝向（SoA，结构体数组的硬件等价物）
//        · free_mask   = ~act
//        · alloc_oh    = free_mask & (~free_mask + 1)   // 取最低位的空槽
//                         ^ 这是“最低位 one-hot”的经典写法，纯组合、1 拍出结果
//        · alloc_idx   : one-hot -> 二进制索引
//     这样“分配”和“回收”都只是置/清一位，没有任何搜索或移位循环。
//     敌方坦克以后可以直接照抄这套 idiom（新建 tank_pool，字段宽度不同，
//     不要硬塞进同一个池 —— 20x20 的坦克和 10x10 的炮弹字段不一样）。
//
//  2) 移动：所有槽并行更新。每个槽在自己的朝向轴上 +1 像素，
//     节拍由 SPEED_DIV 决定（默认 250Hz，是坦克 62.5Hz 的 4 倍）。
//
//  3) 命中判定：串行化（时间复用）+ 网格原生
//     8 个槽各配一个除法器太浪费，所以只做一个“扫描引擎”：每次移动节拍后
//     依次检查每个占用槽，只有“弹体压着的格子组合”变了才去访问地图 BRAM
//     （绝大多数节拍完全不占总线）。
//
//     【按格判定，不是按弹心判定】
//     player.v 保证坦克坐标永远是 TILE=5 的整数倍，炮口坐标因此也是，
//     10x10 的炮弹正好压在 2x2 个格子上（div5 是精确整除）。
//     所以判定 = 「弹体覆盖的 4 格里有任何一格是砖吗」，而不是只看弹头中心
//     那一个像素所在的格。原来的写法只测 1 格，弹体侧面压着砖、中心线却从
//     缺口/缝里过去时，子弹就整条穿过去了（板子上表现为“炮弹穿墙”）。
//        · 砖墙(1)        -> 炮弹消失，并把这 4 格按坦克宽度扩成 4x2 的洞全清掉
//        · 钢/河(2,3)     -> 炮弹消失（不改地图）
//        · 基地(5)        -> 炮弹消失，并发一个单拍 base_hit 给 top：top 锁存
//                            game-over，VGA 把基地换成“白旗”贴图。地图格仍是 5，
//                            所以基地那块地方永远进不去。
//        · 空/树林(0,4)   -> 穿过去（树林本来就是可穿透的）
//     格子编号复用 div5（乘 205 右移 10），全模块只用 2 个乘法器。
//
//     【洞的形状：4 格宽 x 2 格深 = 20x10 像素 = 正好一个坦克的“截面”】
//     炮口在坦克正中的那条边上，div5(炮口) 正好是“坦克这条边往里第 1 格”：
//        · 竖直飞（上/下）：列 = box_cx-1 .. box_cx+2（= 坦克那 4 列）
//                           行 = box_cy, box_cy+1（= 弹体压的那 2 行）
//        · 水平飞（左/右）：行 = box_cy-1 .. box_cy+2（= 坦克那 4 行）
//                           列 = box_cx, box_cx+1（= 弹体压的那 2 列）
//     洞和坦克的脚下【一格不差】：坦克每发往前推进 2 格（10 像素），
//     不会出现“剩一列砖把坦克卡在洞口进不去”，也不会出现阶梯状缺口。
//     逐格读回来判断，只有砖才写 0（钢墙挡在洞里也不会被误清）。
//
//  4) 共享地图 Port A
//     bullet_ctrl 不直接驱动 ram_addra，而是通过 map_req/map_gnt 向 map_bus
//     申请独占窗口（读-判定-改写都在同一个窗口里完成）。
//
//  5) 谁打的？—— own[] 一位三态（0 = 玩家，1..N_E = 第 (i-1) 辆敌人）
//     战场上有两种炮弹，但只用一套池 + 一套扫描引擎，靠 own[] 区分：
//       · 发射：玩家按键 + 每辆敌人的 e_fire 脉冲都进同一个仲裁器
//               （玩家优先，然后编号小的敌人），一次只生成一发
//       · 同屏 1 发：按 own 分组统计 busy_p / busy_e[]，每个人各自限 1 发
//       · 命中：玩家的弹只打敌人（打中 -> hit_enemy[i]，由 enemy_ctrl 扣血），
//               敌人的弹只打玩家（打中 -> hit_player，由 top 扣命/复活）
//       · 弹对弹：归属不同 + 10x10 包围盒相交 -> 两发同归于尽
//       · 配色：b_owner 给 vga.v，敌人的弹画成偏品红，玩家的保持白色
//     这样“加一种子弹”不用动扫描引擎，只要再给一个发射者和一个 own 编号。
// ============================================================================
module bullet_ctrl #(
    parameter N_B       = 4,            // 对象池槽位数（>= N_E + 1：玩家 1 发 + 每辆敌人 1 发）
    parameter N_E       = 3,            // 敌方坦克辆数（和 enemy_ctrl 的 N_E 一致）
    parameter SPEED_DIV = 24'd400_000,  // 250Hz 移动节拍（100MHz / 400000）
    parameter COOLDOWN  = 26'd50_000_000, // 玩家开火冷却 0.5s @100MHz
    parameter ONE_AT_A_TIME = 1,        // 经典规则：每个发射者同屏只允许 1 发（0 = 不限）
    parameter [19:0] DB_MAX = 20'd999_999, // 开火键消抖时间（10ms @100MHz；仿真里改小）
    parameter BW        = 10,           // 炮弹贴图宽
    parameter BH        = 10,           // 炮弹贴图高
    parameter MAP_W     = 120,          // 地图 120x120 格 = 600x600 像素
    parameter MAP_H     = 120,
    parameter TILE      = 5
)(
    input               clock,
    input               reset,
    // ---------------- 玩家开火（内部同步/消抖/取边沿）----------------
    input               fire_btn,
    input               player_alive,   // 0 = 阵亡/无敌中：不许开火，也不会被敌人打中
    input               freeze,         // 1 = 全场冻结（GAME OVER）：炮弹也停在原地
    input      [9:0]    tank_x,
    input      [9:0]    tank_y,
    input      [1:0]    tank_dir,       // 00 上，01 下，10 左，11 右
    // ---------------- 敌方开火请求（每辆一位，单拍脉冲）----------------
    input      [N_E-1:0]    e_fire,
    input      [N_E*10-1:0] e_x,
    input      [N_E*10-1:0] e_y,
    input      [N_E*2-1:0]  e_dir,
    input      [N_E-1:0]    e_alive,
    // ---------------- 命中回报（都是单拍脉冲）----------------
    output reg          hit_player,     // 玩家被敌人的炮弹打中
    output reg [N_E-1:0] hit_enemy,     // 第 i 辆敌人被玩家的炮弹打中
    // ---------------- 地图总线（窗口式握手）----------------
    output reg          map_req,
    output              map_we,         // 组合输出：只在“采到砖”的那一拍拉高
    output reg [14:0]   map_addr,
    output     [3:0]    map_din,        // 恒为 0（打砖 = 把这一格写回空地）
    input               map_gnt,
    input      [3:0]    map_dout,
    // ---------------- 基地命中（单拍脉冲，给 top 做 game-over 状态）----------------
    output reg          base_hit,       // 1 = 这一拍判定到基地格（T_BASE）：基地被摧毁
    // ---------------- 渲染侧（对象池打包成扁平向量，方便接口不用 unpacked array）----
    output     [N_B-1:0]    b_valid,
    output     [N_B-1:0]    b_owner,    // 1 = 敌人打的（VGA 画成偏品红）
    output     [N_B*10-1:0] b_x,
    output     [N_B*10-1:0] b_y,
    output     [N_B*2-1:0]  b_dir
);
    // 地形编号（和 pysrc/map_generator.py 保持一致）
    localparam T_EMPTY = 4'd0,
               T_BRICK = 4'd1,
               T_STEEL = 4'd2,
               T_RIVER = 4'd3,
               T_WOODS = 4'd4,
               T_BASE  = 4'd5;

    localparam [23:0] SPD  = SPEED_DIV;
    localparam [25:0] COOL = COOLDOWN;

    // 除 5（乘 205 右移 10），对 v <= 1023 恒定精确
    function [7:0] div5;
        input [9:0] v;
        reg [17:0] p;
        begin
            p    = v * 18'd205;
            div5 = p[17:10];
        end
    endfunction

    // ---------------- 对象池本体（SoA）----------------
    // own[] 记录“谁打的”：0 = 玩家，1..N_E = 第 (i-1) 辆敌人。
    // 它同时决定三件事：同屏 1 发的分组、命中谁、VGA 的配色。
    localparam [2:0] OWN_NONE = 3'd0;   // 池里 never 存这个值，只是给比较器用
    reg [N_B-1:0] act;              // 1 = 槽位被占用
    reg [9:0]     x [0:N_B-1];      // 贴图左上角
    reg [9:0]     y [0:N_B-1];
    reg [1:0]     dir [0:N_B-1];    // 飞行方向 = 发射时的坦克朝向
    reg [2:0]     own [0:N_B-1];    // 0 = 玩家；i = 第 i 辆敌人
    reg [15:0]    last_cell [0:N_B-1]; // {cell_x, cell_y}：上次判定过的前缘格

    // 打包给 VGA（VGA 只需要“每个槽在哪、朝哪、在不在、谁的”）
    genvar gi;
    generate
        for (gi = 0; gi < N_B; gi = gi + 1) begin : g_pack
            assign b_x[gi*10 +: 10] = x[gi];
            assign b_y[gi*10 +: 10] = y[gi];
            assign b_dir[gi*2 +: 2] = dir[gi];
            assign b_owner[gi]      = (own[gi] != OWN_NONE);
        end
    endgenerate
    assign b_valid = act;

    // ================= 开火输入：同步 -> 消抖 -> 取上升沿 =================
    // 按键是异步的机械触点，必须两级同步 + 消抖，否则一次按下会打出好几发。
    // 消抖时间由参数 DB_MAX 给（板上 10ms；仿真里改小以加速）。

    reg [1:0]  fire_sync = 2'b00;
    reg [19:0] db_cnt    = 20'd0;
    reg        fire_stable = 1'b0;
    reg        fire_prev   = 1'b0;

    always @(posedge clock) begin
        if (reset) begin
            fire_sync   <= 2'b00;
            db_cnt      <= 20'd0;
            fire_stable <= 1'b0;
            fire_prev   <= 1'b0;
        end else begin
            fire_sync <= {fire_sync[0], fire_btn};
            if (fire_sync[1] != fire_stable) begin
                if (db_cnt == DB_MAX) begin      // 稳定了 10ms，才认这个电平
                    fire_stable <= fire_sync[1];
                    db_cnt      <= 20'd0;
                end else begin
                    db_cnt <= db_cnt + 20'd1;
                end
            end else begin
                db_cnt <= 20'd0;                 // 抖动，重新计时
            end
            fire_prev <= fire_stable;
        end
    end

    wire fire_pulse = fire_stable & ~fire_prev;   // 按下那一拍（按住不连发）

    // ================= 冷却计时 =================
    reg [25:0] cool_cnt = 26'd0;
    wire       cool_ready = (cool_cnt == 26'd0);

    // ================= 分配器：取最低位的空槽 =================
    wire [N_B-1:0] free_mask = ~act;
    wire           pool_free = |free_mask;
    wire [N_B-1:0] alloc_oh  = free_mask & (~free_mask + {{(N_B-1){1'b0}}, 1'b1});

    reg [7:0] alloc_idx;
    integer a;
    always @(*) begin
        alloc_idx = 8'd0;
        for (a = 0; a < N_B; a = a + 1)
            if (alloc_oh[a]) alloc_idx = a[7:0];
    end

    // ================= 每个发射者的“我已有弹在飞”标志 =================
    // 经典规则：同一个发射者同屏只允许 1 发。own[] 里存的就是发射者编号，
    // 所以这里按 own 分组统计一遍，一次派生出全部标志（N_B 次比较，很便宜）。
    reg        busy_p;                  // 玩家已有弹在飞
    reg [N_E-1:0] busy_e;               // 第 i 辆敌人已有弹在飞
    integer b;
    always @(*) begin
        busy_p = 1'b0;
        busy_e = {N_E{1'b0}};
        for (b = 0; b < N_B; b = b + 1)
            if (act[b]) begin
                if (own[b] == 3'd0) busy_p = 1'b1;
                else                busy_e[own[b] - 3'd1] = 1'b1;
            end
    end

    // ================= 发射请求仲裁（玩家优先，然后编号小的敌人）=================
    wire player_req = fire_pulse && cool_ready && player_alive &&
                      (!ONE_AT_A_TIME || !busy_p);

    wire [N_E-1:0] enemy_ok;
    genvar ge;
    generate
        for (ge = 0; ge < N_E; ge = ge + 1) begin : g_enemy_req
            assign enemy_ok[ge] = e_alive[ge] && (!ONE_AT_A_TIME || !busy_e[ge]);
        end
    endgenerate
    wire [N_E-1:0] enemy_req = e_fire & enemy_ok;

    reg [2:0] req_owner;                // 组合：本拍想开火的是谁（0 = 玩家，i = 第 i 辆敌人）
    reg       spawn_req;                // 组合：本拍有请求
    reg        spawn   = 1'b0;          // 寄存：这一拍正在入池（上一拍受理的请求）
    reg [2:0]  own_sel = 3'd0;          // 寄存：入池这一发是谁打的
    integer   r;
    always @(*) begin
        spawn_req = 1'b0;
        req_owner = 3'd0;
        // spawn 是“上一拍已经受理、这一拍正在入池”的标志：它还在的时候就先不接新请求，
        // 否则连续两拍各来一个请求会算出同一个空槽，后一个把前一个覆盖掉。
        if (pool_free && !freeze && !spawn) begin
            if (player_req) begin
                spawn_req = 1'b1;
                req_owner = 3'd0;
            end else begin
                for (r = 0; r < N_E; r = r + 1)
                    if (!spawn_req && enemy_req[r]) begin
                        spawn_req = 1'b1;
                        req_owner = r + 1;
                    end
            end
        end
    end

    // ---- 打一拍：把“谁要开火”锁下来，炮口选择和入池放到下一拍 ----
    // 【为什么需要这一级流水】own -> busy_* -> 请求 -> 炮口 -> 池 这条组合链
    // 原来有 14 级逻辑（实测 WNS -0.81ns，把 100MHz 的 10ns 吃穿了）。
    // 开火请求本来就慢（玩家 5Hz、敌人 2~8Hz），多等一拍完全无所谓，
    // 但省下来的这 10ns 让时序回到正值。
    always @(posedge clock) begin
        if (reset) begin
            spawn   <= 1'b0;
            own_sel <= 3'd0;
        end else begin
            spawn   <= spawn_req;
            own_sel <= req_owner;
        end
    end

    // 玩家开火冷却（敌人有自己的开火周期，不占这个计数器）
    always @(posedge clock) begin
        if (reset)                            cool_cnt <= 26'd0;
        else if (spawn && own_sel == 3'd0)    cool_cnt <= COOL - 26'd1;
        else if (cool_cnt != 26'd0)           cool_cnt <= cool_cnt - 26'd1;
    end

    // ================= 移动节拍（250Hz，坦克的 4 倍）=================
    reg [23:0] spd_cnt = 24'd0;
    always @(posedge clock) begin
        if (reset)                          spd_cnt <= 24'd0;
        else if (spd_cnt >= SPD - 24'd1)    spd_cnt <= 24'd0;
        else                                spd_cnt <= spd_cnt + 24'd1;
    end
    wire bullet_tick = (spd_cnt == SPD - 24'd1) && !freeze;

    // ================= 炮口位置：贴边生成，10x10 的炮弹正好被坦克居中挡在后面 ====
    // 发射者可能是玩家，也可能是某辆敌人（own_sel 已经在上一拍锁好）。
    // 这里用“one-hot 选择 + 常量下标拼位”而不是“变量下标的位选”：
    // 后者的 (n-1)*10 乘法 + 30 选 1 桶形移位要多两级逻辑，正好卡在 10ns 上。
    wire [N_E-1:0] src_sel = (own_sel == 3'd0) ? {N_E{1'b0}}
                                               : (3'd1 << (own_sel - 3'd1));
    reg [9:0] src_x, src_y;
    reg [1:0] src_d;
    integer si;
    always @(*) begin
        src_x = tank_x;
        src_y = tank_y;
        src_d = tank_dir;
        for (si = 0; si < N_E; si = si + 1)
            if (src_sel[si]) begin
                src_x = e_x[si*10 +: 10];
                src_y = e_y[si*10 +: 10];
                src_d = e_dir[si*2 +: 2];
            end
    end

    reg [9:0] muzzle_x, muzzle_y;
    always @(*) begin
        case (src_d)
            2'b00:   begin muzzle_x = src_x + 10'd5;  muzzle_y = src_y - 10'd10; end // 向上：坦克上边
            2'b01:   begin muzzle_x = src_x + 10'd5;  muzzle_y = src_y + 10'd20; end // 向下：坦克下边
            2'b10:   begin muzzle_x = src_x - 10'd10; muzzle_y = src_y + 10'd5;  end // 向左：坦克左边
            default: begin muzzle_x = src_x + 10'd20; muzzle_y = src_y + 10'd5;  end // 向右：坦克右边
        endcase
    end
    // ================= 弹体覆盖的 2x2 格（网格原生）=================
    // 串行引擎同一时刻只处理一个槽，所以这里用 chk_idx 去索引对象池：
    // 综合出来是 4 选 1 的 mux，只占一份逻辑、一份乘法器。
    reg [7:0]  chk_idx = 8'd0;      // 当前处理的槽（扫描引擎的“游标”）
    reg [7:0]  box_cx  = 8'd0;      // 弹体左上角所在格（列）
    reg [7:0]  box_cy  = 8'd0;      // 弹体左上角所在格（行）
    reg [1:0]  box_i   = 2'd0;      // 本轮正在判定弹体的第几格（0..3）

    wire [9:0] c_x = x[chk_idx];
    wire [9:0] c_y = y[chk_idx];
    wire [1:0] c_d = dir[chk_idx];

    // 出界判定：坐标是 10 位的，向上/向左走出地图会回绕成很大的值，
    // 右上/右下也要判（贴图原点 + 10 像素超出地图就回收）。
    wire box_oob = (c_x >= MAP_W * TILE) || (c_y >= MAP_H * TILE) ||
                   ((c_x + BW) > MAP_W * TILE) || ((c_y + BH) > MAP_H * TILE);

    // 弹体覆盖的 2x2 格：{box_cx, box_cx+1} x {box_cy, box_cy+1}
    //   box_i[0] = 列偏移，box_i[1] = 行偏移
    // 地址 = row * MAP_W + col，MAP_W = 120 = 128 - 8 -> (row<<7) - (row<<3)。
    // 600x600 玩区之后地图只有 120 格宽，这里（以及 terrain_probe / vga.v）
    // 是仅有的三处“行宽”常量，改玩区宽度时一起改。
    localparam [14:0] ROW_STRIDE = MAP_W;       // 下一行的地址增量 = 120
    wire [7:0]  scn_col  = box_cx + {7'd0, box_i[0]};
    wire [7:0]  scn_row  = box_cy + {7'd0, box_i[1]};
    wire [15:0] scn_base = ({8'd0, scn_row} << 7) - ({8'd0, scn_row} << 3); // row*120
    wire [15:0] scn_sum  = scn_base + {8'd0, scn_col};
    wire [14:0] scn_addr = scn_sum[14:0];

    // ================= 打砖洞：4 格宽 x 2 格深 = 20x10 像素 =================
    // 竖直飞（上/下）：列 box_cx-1 .. box_cx+2（4 列 = 坦克宽），行 box_cy, box_cy+1
    // 水平飞（左/右）：行 box_cy-1 .. box_cy+2（4 行 = 坦克高），列 box_cx, box_cx+1
    // 炮口在坦克正中的那条边上，div5(炮口) 正好是“坦克这条边往里第 1 格”，
    // 所以上面的 -1 之后正好从坦克这条边的第一格开始 —— 洞和坦克脚下一格不差。
    //   _v / _h 是两种形状的基址，C_DEC 里按飞行方向锁存（之后再算 8 个格的地址）。
    // 可达情况下不会下溢：竖直时 box_cx >= 1（炮口 x = 坦克 x + 5），
    // 水平时 box_cy >= 1（炮口 y = 坦克 y + 5）；越界由 box_oob 提前回收。
    wire        chop_vert   = ~c_d[1];                                       // 上下 = 1
    wire [14:0] chop_row    = ({7'd0, box_cy} << 7) - ({7'd0, box_cy} << 3); // box_cy * 120
    wire [14:0] chop_base_v = chop_row + {7'd0, box_cx} - 15'd1;             // 行 box_cy，列 box_cx-1 起
    wire [14:0] chop_base_h = chop_row - ROW_STRIDE + {7'd0, box_cx};  // 行 box_cy-1，列 box_cx 起

    reg  [14:0] chop_base = 15'd0;  // C_DEC 锁存：之后 c_d/x/y 可能被新炮弹覆盖
    reg         chop_v    = 1'b1;   // C_DEC 锁存：1 = 竖直飞的形状（4 列 x 2 行）
    reg  [2:0]  chop_i    = 3'd0;   // 条带内第几格（0..7）

    // 8 格的地址当场算出来，不做累加（累加一旦跑飞会写到别的格子上）：
    //   竖直：i[1:0] 选列（0..3），i[2] 选行（0..1）  -> +列 +行*MAP_W
    //   水平：i[1:0] 选行（0..3），i[2] 选列（0..1）  -> +行*MAP_W +列
    wire [14:0] chop_addr_nxt = chop_v
        ? (chop_base + {13'd0, chop_i[1:0]} + (chop_i[2] ? ROW_STRIDE : 15'd0))
        : (chop_base + ({8'd0, chop_i[1:0]} << 7) - ({8'd0, chop_i[1:0]} << 3)
                      + (chop_i[2] ? 15'd1 : 15'd0));

    // ================= 串行命中判定引擎 =================
    // 一次 bullet_tick 之后把池里所有占用槽扫一遍，只有“弹体压着的 2x2 格”变了
    // 才去读地图（4 格串行读，每格 7 拍；没换格就一次都不读）。
    localparam [3:0] C_IDLE  = 4'd0,   // 等一次扫描触发
               C_SEL   = 4'd1,   // 找下一个占用槽（空槽直接跳过）
               C_CALC  = 4'd2,   // 弹体左上角除 5 得到格子坐标（2 个乘法器）
               C_CMP   = 4'd3,   // 出界？和上次的格子比，没变就不用读地图
               C_REQ   = 4'd4,   // 申请总线并发地址
               C_WAIT  = 4'd5,   // 等授权，再等 4 拍让 douta 稳定
               C_DEC   = 4'd6,   // 采样地形，决定：穿过 / 消失 / 打砖
               C_NEXT  = 4'd7,   // 收尾：撤销 req、换下一个槽
               C_CHOP  = 4'd8,   // 打砖：把洞里这一格的地址送上总线
               C_CHOPW = 4'd9,   // 打砖：等 douta 稳定（同 C_WAIT）
               C_CHOPD = 4'd10;  // 打砖：采 douta，是砖就写 0

    reg [3:0]  chk_state = C_IDLE;
    reg [2:0]  chk_cnt   = 3'd0;    // C_WAIT / C_CHOPW 的等待计数
    reg        chk_run   = 1'b0;    // 本轮扫描请求
    reg        kill_pulse = 1'b0;   // 单拍：回收 kill_slot 这个槽
    reg [7:0]  kill_slot  = 8'd0;
    reg        kill2_pulse = 1'b0;  // 单拍：对消灭时回收“另一发”（kill2_slot）
    reg [7:0]  kill2_slot  = 8'd0;

    // ================= 坦克命中：包围盒重叠 =================
    // 弹体是 10x10（左上角 c_x/c_y），坦克是 20x20，两者都对齐在 5px 格点上，
    // 所以直接做包围盒相交（左边界比右边界）就够了，不用逐像素。
    //   · 玩家的弹（own == 0）只打敌人，而且不能打“已经死了/正在无敌”的目标
    //   · 敌人的弹（own != 0）只打玩家（不打自己人，避免敌人互相误伤）
    // 命中后由 top 决定加多少分（敌人的血量/兵种差异在 enemy_ctrl 里）。
    function overlap20;
        input [9:0] bx;
        input [9:0] by;
        input [9:0] tx;
        input [9:0] ty;
        begin
            // 全部用 11 位做加法，避免“贴图坐标 + 20”在 10 位里回绕
            // （炮口在边缘时会算出 1014 这种回绕值，用 10 位加会假命中）
            overlap20 = ({1'b0, bx} < ({1'b0, tx} + 11'd20)) &&
                        ({1'b0, tx} < ({1'b0, bx} + 11'd10)) &&
                        ({1'b0, by} < ({1'b0, ty} + 11'd20)) &&
                        ({1'b0, ty} < ({1'b0, by} + 11'd10));
        end
    endfunction

    wire [N_E-1:0] e_box_hit;
    genvar gh;
    generate
        for (gh = 0; gh < N_E; gh = gh + 1) begin : g_box
            wire [9:0] ex = e_x[gh*10 +: 10];
            wire [9:0] ey = e_y[gh*10 +: 10];
            assign e_box_hit[gh] = e_alive[gh] && overlap20(c_x, c_y, ex, ey);
        end
    endgenerate
    wire player_box_hit = player_alive && overlap20(c_x, c_y, tank_x, tank_y);

    // 当前这一发压到谁了（只有玩家弹才看敌人；敌人弹只看玩家）
    wire [N_E-1:0] e_hit_now = (own[chk_idx] == 3'd0) ? e_box_hit : {N_E{1'b0}};
    wire           p_hit_now = (own[chk_idx] != 3'd0) && player_box_hit;

    // ================= 弹对弹：敌我炮弹相撞同归于尽 =================
    // 经典 Battle City 里“自己的弹能打掉敌人的弹”，这里用同样的规则：
    // 两发归属不同、10x10 包围盒相交 -> 两发都回收。
    //
    // 【为什么把判定做成“预先算好的矩阵”】16 个“距离 < 10px”的减法/比较
    // 如果放在扫描状态机里组合出来，chk_idx -> x[chk_idx] -> 4 组绝对值减法
    // -> 优先级 mux -> chk_state 这条链实测 10.1ns（WNS -0.05ns，就差这一点）。
    // 炮弹每 400us 才走 1 像素，把“谁和谁撞了”提前一拍算好完全没影响；
    // 而且矩阵是 16 个并行比较器（每级只有减法+比较），深度很浅。
    function near10;
        input [9:0] a;
        input [9:0] b;
        reg [10:0] d;
        begin
            d = (a >= b) ? ({1'b0, a} - {1'b0, b}) : ({1'b0, b} - {1'b0, a});
            near10 = (d < 11'd10);
        end
    endfunction

    reg [N_B*N_B-1:0] pair_now = {(N_B*N_B){1'b0}};
    integer pa, pb2;
    always @(posedge clock) begin
        for (pa = 0; pa < N_B; pa = pa + 1)
            for (pb2 = 0; pb2 < N_B; pb2 = pb2 + 1)
                pair_now[pa*N_B + pb2] <= act[pa] && act[pb2] && (pa != pb2) &&
                                          (own[pa] != own[pb2]) &&
                                          near10(x[pa], x[pb2]) &&
                                          near10(y[pa], y[pb2]);
    end

    // 当前扫描的这发，和哪些槽撞上了（变量下标的位选，1 位 N_B 选 1，很浅）
    wire [N_B-1:0] pair_hits = pair_now[chk_idx * N_B +: N_B];

    reg [7:0] pair_slot;
    reg       pair_found;
    integer   pb;
    always @(*) begin
        pair_slot  = 8'd0;
        pair_found = 1'b0;
        for (pb = N_B - 1; pb >= 0; pb = pb - 1)
            if (pair_hits[pb]) begin      // 倒序覆盖 -> 最终留下编号最小的那个
                pair_found = 1'b1;
                pair_slot  = pb[7:0];
            end
    end
    // 判定结果要写回 last_cell[]，但 last_cell 已经在下面的对象池 always 块里
    // 被 reset / spawn 写过。同一个 reg 数组不能有两个 always 驱动（综合会报
    // multi-driven，硬件上直接丢掉一路），所以这里只发一个单拍脉冲，
    // 由对象池那块统一落盘（和 kill_pulse 一个套路）。
    reg        mark_pulse = 1'b0;
    reg [7:0]  mark_idx   = 8'd0;
    reg [15:0] mark_cell  = 16'hFFFF;

    // 写使能做成“组合”输出：C_CHOPD 那一拍 map_addr 还停在被打的那一格上，
    // 而寄存器输出要晚一拍才生效 —— 那样 0 就会被写到下一格去。
    // map_gnt 也一起与进来：没拿到窗口时总线不属于炮弹，不能写。
    wire chop_hit = (chk_state == C_CHOPD) && map_gnt && (map_dout == T_BRICK);
    assign map_we  = chop_hit;
    assign map_din = 4'd0;

    always @(posedge clock) begin
        if (reset) begin
            chk_state  <= C_IDLE;
            chk_idx    <= 8'd0;
            chk_cnt    <= 3'd0;
            box_cx     <= 8'd0;
            box_cy     <= 8'd0;
            box_i      <= 2'd0;
            chk_run    <= 1'b0;
            kill_pulse <= 1'b0;
            kill_slot  <= 8'd0;
            kill2_pulse <= 1'b0;
            kill2_slot  <= 8'd0;
            mark_pulse <= 1'b0;
            mark_idx   <= 8'd0;
            mark_cell  <= 16'hFFFF;
            base_hit   <= 1'b0;
            hit_player <= 1'b0;
            hit_enemy  <= {N_E{1'b0}};
            map_req    <= 1'b0;
            map_addr   <= 15'd0;
            chop_base  <= 15'd0;
            chop_v     <= 1'b1;
            chop_i     <= 3'd0;
        end else begin
            kill_pulse <= 1'b0;                 // 默认都是单拍脉冲
            kill2_pulse <= 1'b0;
            mark_pulse <= 1'b0;
            base_hit   <= 1'b0;
            hit_player <= 1'b0;
            hit_enemy  <= {N_E{1'b0}};

            // 每个移动节拍（并且池里还有炮弹）触发一轮扫描；
            // 生成的那一拍也必须马上扫一次：炮弹出生时可能已经贴在墙/砖里，
            // 如果不立刻判定，它会在第一次移动后跳过“炮口所在的那一格”，
            // 出现“贴着砖块开火却打不穿”的 bug。
            if (spawn || (bullet_tick && (act != {N_B{1'b0}}))) chk_run <= 1'b1;

            case (chk_state)
                C_IDLE: begin
                    if (chk_run) begin
                        chk_idx   <= 8'd0;
                        chk_state <= C_SEL;
                    end
                end
                C_SEL: begin
                    if (!act[chk_idx]) begin
                        // 空槽：直接跳过；走到池尾就结束本轮
                        if (chk_idx == N_B - 1) begin
                            chk_run   <= 1'b0;
                            chk_state <= C_IDLE;
                        end else begin
                            chk_idx <= chk_idx + 8'd1;
                        end
                    end else begin
                        chk_state <= C_CALC;
                    end
                end
                C_CALC: begin
                    // 弹体左上角所在的格（坐标是 5 的倍数，div5 是精确整除）
                    box_cx    <= div5(c_x);
                    box_cy    <= div5(c_y);
                    box_i     <= 2'd0;
                    chk_state <= C_CMP;
                end
                C_CMP: begin
                    // 每一格都从这儿发地址（窗口从头到尾不撒手，只换地址）
                    if (box_i == 2'd0) begin
                        if (pair_found) begin
                            // 敌我炮弹撞在一起：两发同时回收，连地图都不用读
                            kill_pulse  <= 1'b1;
                            kill_slot   <= chk_idx;
                            kill2_pulse <= 1'b1;
                            kill2_slot  <= pair_slot;
                            chk_state   <= C_NEXT;
                        end else if (box_oob) begin
                            // 飞出地图：回收，不占用地图总线
                            kill_pulse <= 1'b1;
                            kill_slot  <= chk_idx;
                            chk_state  <= C_NEXT;
                        end else if (|e_hit_now || p_hit_now) begin
                            // 打到坦克（只看第一格：4 格扫描期间相对位置不会变）。
                            // 这一步必须【每个节拍】都判，不能等到“换格才读地图”：
                            // 坦克 20x20 比弹体大，弹体完全可能整整一个格组都压在
                            // 坦克身上而地图格组没变 —— 那时读地图的路径被去重跳过，
                            // 命中就漏了（早期版本就是这样“贴脸打不中”）。
                            kill_pulse <= 1'b1;
                            kill_slot  <= chk_idx;
                            hit_enemy  <= e_hit_now;
                            hit_player <= p_hit_now;
                            chk_state  <= C_NEXT;
                        end else if ({box_cx, box_cy} == last_cell[chk_idx]) begin
                            // 弹体压着的还是那 2x2 格，不可能撞到新东西，省掉 4 次地图读
                            chk_state <= C_NEXT;
                        end else begin
                            map_addr  <= scn_addr;
                            map_req   <= 1'b1;
                            chk_cnt   <= 3'd0;
                            chk_state <= C_REQ;
                        end
                    end else begin
                        map_addr  <= scn_addr;      // 同一窗口内换到下一格
                        chk_cnt   <= 3'd0;
                        chk_state <= C_REQ;
                    end
                end
                C_REQ: begin
                    // 地址这一拍已经送出（寄存器输出，地址路径很短）
                    chk_state <= C_WAIT;
                end
                C_WAIT: begin
                    // 等拿到独占窗口后再数 4 拍，保证 douta 是本格的（容忍 0~3 拍延迟）
                    if (!map_gnt)          chk_cnt <= 3'd0;
                    else if (chk_cnt == 3'd3) chk_state <= C_DEC;
                    else                   chk_cnt <= chk_cnt + 3'd1;
                end
                C_DEC: begin
                    if (map_dout == T_BRICK) begin
                        // 打砖：炮弹消失，并在同一个总线窗口里把 4x2 = 20x10 的洞全清掉
                        // （判定的这 4 格本身就在洞里，不用在这里单独写）
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chop_base  <= chop_vert ? chop_base_v : chop_base_h;
                        chop_v     <= chop_vert;
                        chop_i     <= 3'd0;
                        chk_state  <= C_CHOP;
                    end else if (map_dout == T_BASE) begin
                        // 基地：炮弹消失，地图不变（格子仍是 5，坦克照样进不去），
                        // 但发一个单拍 base_hit 给 top —— 由它把 game-over 状态锁住，
                        // VGA 再把基地画成“白旗”那张 ROM。把基地单独拆出来，是因为
                        // “打中基地”和“打中钢墙”在画面上后果完全不同。
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        base_hit   <= 1'b1;
                        chk_state  <= C_NEXT;
                    end else if (map_dout != T_EMPTY && map_dout != T_WOODS) begin
                        // 钢墙 / 河流：炮弹消失，地图不变
                        kill_pulse <= 1'b1;
                        kill_slot  <= chk_idx;
                        chk_state  <= C_NEXT;
                    end else if (box_i == 2'd3) begin
                        // 2x2 全是空地/树林：记下这一组格子，下次弹体没换格就跳过
                        mark_pulse <= 1'b1;
                        mark_idx   <= chk_idx;
                        mark_cell  <= {box_cx, box_cy};
                        chk_state  <= C_NEXT;
                    end else begin
                        box_i     <= box_i + 2'd1;   // 换弹体压着的下一格
                        chk_state <= C_CMP;
                    end
                end
                C_CHOP: begin
                    // 把洞里的这一格地址送上总线（窗口已经拿到，req 保持不变）
                    map_addr  <= chop_addr_nxt;
                    chk_cnt   <= 3'd0;
                    chk_state <= C_CHOPW;
                end
                C_CHOPW: begin
                    // 和 C_WAIT 一样：等 douta 稳定（容忍 0~3 拍读延迟）
                    if (!map_gnt)             chk_cnt <= 3'd0;
                    else if (chk_cnt == 3'd3) chk_state <= C_CHOPD;
                    else                      chk_cnt <= chk_cnt + 3'd1;
                end
                C_CHOPD: begin
                    // 这一拍 map_dout 就是本格地形；是砖时 map_we 组合拉高（写 0）。
                    // 地址这一拍不能动，否则 0 会写到别的格子上。
                    if (chop_i == 3'd7) begin
                        chk_state <= C_NEXT;             // 8 格（4x2）清完
                    end else begin
                        chop_i    <= chop_i + 3'd1;
                        chk_state <= C_CHOP;
                    end
                end
                default: begin // C_NEXT
                    map_req <= 1'b0;
                    if (chk_idx == N_B - 1) begin
                        chk_run   <= 1'b0;
                        chk_state <= C_IDLE;
                    end else begin
                        chk_idx   <= chk_idx + 8'd1;
                        chk_state <= C_SEL;
                    end
                end
            endcase
        end
    end
    // ================= 对象池更新：移动 / 生成 / 回收 =================
    // 三个动作放在同一个 always 块里，避免同一个数组被多个 always 驱动
    // （Verilog 里 act[0] 和 act[1] 属于同一个 reg，分开写会报多驱动）。
    integer m;
    always @(posedge clock) begin
        if (reset) begin
            act <= {N_B{1'b0}};
            for (m = 0; m < N_B; m = m + 1) begin
                x[m]         <= 10'd0;
                y[m]         <= 10'd0;
                dir[m]       <= 2'b00;
                own[m]       <= 3'd0;
                last_cell[m] <= 16'hFFFF;     // 不合法的“上次格子”，保证首拍必查
            end
        end else begin
            // 0) 落盘“已经判定过的格子”（扫描引擎发来的单拍脉冲）
            if (mark_pulse) last_cell[mark_idx] <= mark_cell;

            // 1) 移动：所有占用槽并行沿自己的朝向走 1 像素
            if (bullet_tick) begin
                for (m = 0; m < N_B; m = m + 1) begin
                    if (act[m]) begin
                        case (dir[m])
                            2'b00:   y[m] <= y[m] - 10'd1;
                            2'b01:   y[m] <= y[m] + 10'd1;
                            2'b10:   x[m] <= x[m] - 10'd1;
                            default: x[m] <= x[m] + 10'd1;
                        endcase
                    end
                end
            end

            // 2) 生成：写在移动之后，优先级更高（新炮弹当拍不移动）
            //    muzzle_x/y/src_d 已经在上面按“谁请求的”选好了；own 记下发射者，
            //    后面命中判定、同屏 1 发、VGA 配色都靠它。
            if (spawn) begin
                act[alloc_idx]       <= 1'b1;
                x[alloc_idx]         <= muzzle_x;
                y[alloc_idx]         <= muzzle_y;
                dir[alloc_idx]       <= src_d;
                own[alloc_idx]       <= own_sel;
                last_cell[alloc_idx] <= 16'hFFFF;  // 下一拍强制做一次命中判定
            end

            // 3) 回收：撞墙 / 打掉砖 / 打中坦克 / 撞上对方的弹 / 飞出地图
            if (kill_pulse)  act[kill_slot]  <= 1'b0;
            if (kill2_pulse) act[kill2_slot] <= 1'b0;   // 弹对弹：另一发同时回收
        end
    end

endmodule

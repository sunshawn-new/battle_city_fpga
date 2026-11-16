`timescale 1ns / 1ps

// ============================================================================
//  enemy_ctrl —— 敌方坦克的运动 / 转向
//
//  【出场由 stage_ctrl 决定】本模块不再“复位即出场 3 辆”：每次 spawn[i] 单拍
//  脉冲就按 spawn_type[i] 往第 i 槽放一辆车（复位后所有槽都是空的）。波次、每关
//  多少辆、什么时候补车都在 stage_ctrl.v 里；这里只负责“一辆车怎么动/怎么打/怎么死”，
//  兵种参数（速度/开火周期/血量）在出场那一拍写进本槽的寄存器。
//
//  【和 player.v 共用同一条不变量】每个移动节拍走整整一格（TILE = 5 像素），
//  所以坐标永远是 TILE 的整数倍、20x20 的车身永远精确压在自己那 4x4 格上。
//  这样前方地形查询就能直接复用 terrain_probe（每辆车一个实例），以后
//  “坦克互斥 / 炮弹打坦克 / 敌人被击毁”也都能用格点和包围盒来算，
//  不会出现“半格卡住”“偏心命中”这类麻烦。
//
//  速度：MOVE_DIV 决定节拍（top 里给玩家的 2 倍 -> 12.5Hz，比玩家慢一半）。
//  几辆车的计数器初值错开（PHASE），不会同手同脚一起走。
//
//  AI（朝基地进攻 + 不会被墙角困住）：
//    1. 前面能走（空地 / 树林）就沿当前朝向走一格；
//    2. 每 TURN_TICKS 个移动节拍重新选向：3/4 概率直接对准玩家基地
//       （曼哈顿贪心：先走离基地更远的那一轴），1/4 随机拐一下 ——
//       这样三辆车不会排成一条直线，但整体一定在往基地压；
//    3. 前面是墙（砖 / 钢 / 河 / 基地 / 地图外框）时按固定顺序试四个方向：
//       ① 沿“锁存的横向偏好”贴墙滑（撞墙才换边）② 反方向滑（同时换边）
//       ③ 掉头 ④ 主轴朝基地，走通一个就把计数器清零。四个方向全覆盖，
//       所以三面是墙的路口最多三拍就能掉头绕出去；沿着河岸滑的时候
//       每 6 格再朝基地瞄一次，于是会自己找到浅滩。
//       横向方向必须“锁存”：如果每拍都拿 x 和基地 x 比大小，车正好在基地
//       正上方时会左右各滑 5px 反复抖，永远到不了浅滩（实测轨迹就是这样）。
//       早期版本是纯随机 90° 转向，表现是“聚在墙角原地抖、永远不去打基地”。
//
//  为什么用 generate 展开、而不像炮弹那样做串行引擎：
//    每辆车只有一套 20 位左右的状态（x/y/dir/计数器/LFSR），逻辑量很小，
//    展开后天然并行、每拍都能更新；串行化反而要排队，把逻辑搞复杂。
//
//  朝向编码和 player / bullet / vga 完全一致：00 上，01 下，10 左，11 右。
// ============================================================================
module enemy_ctrl #(
    parameter N_E        = 3,            // 敌方坦克辆数（VGA 的 N_E 必须一致）
    parameter WIDTH      = 600,          // 600x600 玩区（右边 200px 是 HUD）
    parameter HEIGHT     = 600,
    parameter TILE       = 5,            // 一格 5 像素（和 player.v / map.coe 一致）
    parameter MOVE_DIV   = 8_000_000,    // 中间档节拍：100M / MOVE_DIV 拍/秒
    parameter TURN_TICKS = 24,           // 每多少个移动节拍重新选一次向（要不小于 8）
    parameter FIRE_TICKS = 4             // 开火周期基准（按自己的移动节拍计数）
)(
    input clock,
    input reset,

    // ---------------- 出场（由 stage_ctrl 派）：单拍脉冲 + 兵种 ----------------
    // 复位后所有槽都是空的（alive=0），等 stage_ctrl 说“放一辆进来”。
    // 兵种在出场这一拍写进本槽的寄存器（step / 开火周期 / 血量），
    // 所以同一个槽前后可以是不同兵种 —— 波次换车不用改硬件结构。
    input  [N_E-1:0]   spawn,
    input  [N_E*2-1:0] spawn_type,      // 第 i 辆占 spawn_type[i*2 +: 2]

    // ---------------- 每辆车的“前方地形”（各接一个 terrain_probe 实例）----------------
    input      [N_E*4-1:0]  terrain_front,   // 第 i 辆占 terrain_front[i*4 +: 4]
    input      [N_E-1:0]    terrain_valid,   // 结果可信（查询条件 == 当前 x/y/dir）
    output     [N_E-1:0]    move_tick,       // 每辆车自己的节拍，接各自 probe 的 refresh

    // ---------------- 坦克互斥：玩家的位置 ----------------
    // 其它敌人的位置在本模块内部互传（en_all_x/y/v 那三根网线），玩家必须
    // 从 top 传进来。没有这一层时敌人能从玩家身上开过去（穿模）。
    input      [9:0]        p_x,
    input      [9:0]        p_y,

    // ---------------- 战斗 ----------------
    input      [N_E-1:0]    e_hit,           // 单拍：这辆车被炮弹打中（由 bullet_ctrl 报）
    input                   freeze,          // 1 = 全冻结（GAME OVER 后不再动/不再开火）
    output     [N_E-1:0]    e_fire,          // 单拍：请求开火（接 bullet_ctrl 的 e_fire）
    output     [N_E-1:0]    e_kill,          // 单拍：这辆车被击毁（top 用来加分）

    // ---------------- 打包给 VGA（扁平打包，避免 unpacked array 端口）----------------
    output     [N_E-1:0]    e_valid,         // 1 = 这辆车还在
    output     [N_E*10-1:0] e_x,
    output     [N_E*10-1:0] e_y,
    output     [N_E*2-1:0]  e_dir,
    output     [N_E*2-1:0]  e_type           // 兵种（VGA 按它选贴图 ROM）
);
    // 地形编号（和 pysrc/map_generator.py / player.v / terrain_probe.v 一致）
    localparam T_EMPTY = 4'd0,
               T_WOODS = 4'd4;

    // 进攻目标 = 玩家基地中心（像素）。基地精灵占 x 290..309 / y 565..584
    // （见 vga.v 的 HQ_X0/HQ_Y0），取中心和取左上角对贪心选向没有区别。
    // 基地（老鹰）中心：块 52..67 x 104..119 -> 像素 260..339 x 520..599，
    // 中心 ≈ (300,560)。和 map_generator.py 的 HQ_X0/HQ_Y0 一致。
    localparam [9:0] TGT_X = 10'd300,
                     TGT_Y = 10'd560;
    // 朝向编码（和 player / bullet / vga 一致）：00 上，01 下，10 左，11 右
    localparam [1:0] D_UP    = 2'b00,
                     D_DOWN  = 2'b01,
                     D_LEFT  = 2'b10,
                     D_RIGHT = 2'b11;
    // 撞墙后先沿另一轴滑这么多格，再重新朝基地瞄一次。
    // 这个值决定"沿墙走多远才回头试一次主轴"：太大就会滑过浅滩（浅滩只有
    // 3 块 = 60px 宽，而坦克每滑一格是 5px），太小又会太频繁地停顿。
    localparam [7:0] SLIDE_TICKS = 8'd3;

    // 兵种编号（和 vga.v 的 tank ROM 选择一致）：
    //   00 = 快速坦克  -> blk_mem_tank_fast  （淡青、细炮管、窄履带）
    //   01 = 火力坦克  -> blk_mem_tank_power （亮橙、粗炮管 + 炮口制退器）
    //   10 = 装甲坦克  -> blk_mem_tank_armor （绿色、5px 厚履带 + 宽炮盾）
    // 【兵种差异】不只好看：速度（step）、开火周期（fire_period）、血量（hp_max）
    // 三样都不一样。这三个量现在是每个槽的寄存器，出场时按兵种写进去，
    // 见下面 generate 里的 n_step / n_fire / n_hp。
    localparam [1:0] T_FAST  = 2'd0,
                     T_POWER = 2'd1,
                     T_ARMOR = 2'd2;

    localparam TANK_W = 20;                       // 敌人和玩家一样是 20x20
    localparam TANK_H = 20;
    localparam [9:0] X_MAX = WIDTH  - TANK_W;     // 780：车身右边缘刚好贴住画面
    localparam [9:0] Y_MAX = HEIGHT - TANK_H;     // 580

    // 每辆车自己的移动节拍（同一条线上的第 gi 位）
    wire [N_E-1:0] tick_all;
    assign move_tick = tick_all;

    // ---------------- 坦克互斥用的“全场车辆坐标” ----------------
    // 每个槽把自己的 x/y/alive 打到这三根网线上（和 e_x/e_y 打包输出的驱动方式
    // 一样，只是这份只在本模块内可见）。读它的地方只有“下一状态”的比较逻辑，
    // 而且比较的对象永远是别人的格子，所以不会形成组合环。
    wire [N_E*10-1:0] en_all_x, en_all_y;
    wire [N_E-1:0]    en_all_v;

    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_enemy
            // ---------------- 出生点 / 初始朝向 ----------------
            // 都在真实地图第 0 块（那是新地图里专门留出来的 4 块 x 4 块空地），
            // 朝下开；x 是 5 的倍数、y 对齐到块边界，20x20 的车身正好压在自己
            // 那 4x4 个块上，不会骑在墙上（以前 y=10 会让车身一半在第 0 块、
            // 一半在第 1 块，出生那几拍是在墙里挤出来的）。
            //   (40,0)  块列 8~11    左边通道（map_generator 的 ENEMY_SPAWNS[0]）
            //   (300,0) 块列 60~63   中间，正对玩家出生点的那条纵向主通道
            //   (560,0) 块列 112~115 右边通道（ENEMY_SPAWNS[2]）
            // 这三个点和 map_generator.py 的 ENEMY_SPAWNS 是硬绑定的：
            // 生成器会验证这三块 4x4 区域是空地、而且坦克能从那里开到基地。
            // N_E 超过 3 辆时，多出来的都按右边那个点出生（以后做波次再改）。
            localparam [9:0] SPAWN_X = (gi == 0) ? 10'd40 :
                                       (gi == 1) ? 10'd300 : 10'd560;
            localparam [9:0] SPAWN_Y = 10'd0;
            localparam [1:0] SPAWN_D = 2'b01;                 // 朝下

            // 兵种跟着出生点走（旧版的固定分配，现在只用来做“本槽的初始兵种”
            // 兜底：真正的兵种由 stage_ctrl 在 spawn 那一拍给）：
            // 左边那辆是轻快的快速坦克、中间火力、右边装甲。
            localparam [1:0] DEF_TYPE = (gi == 0) ? T_FAST :
                                        (gi == 1) ? T_POWER : T_ARMOR;

            // ---------------- 兵种差异（玩法核心）----------------
            //   快速 T_FAST  : 和玩家同速（STEP = 玩家节拍）、1 发碎、每 6 拍一炮
            //   火力 T_POWER : 玩家的一半速度、1 发碎、每 4 拍一炮（弹幕最密）
            //   装甲 T_ARMOR : 玩家的 1/3 速度、要挨 2 发、每 8 拍一炮
            // top 传进来的 MOVE_DIV 是“中间档”（玩家的 2 倍），所以：
            //   fast = MOVE_DIV/2（8M -> 25Hz，和玩家一样）
            //   power= MOVE_DIV  （8M -> 12.5Hz）
            //   armor= MOVE_DIV*3/2（12M -> 8.3Hz）
            // 开火周期用“自己的移动节拍”计数，所以仿真里把 MOVE_DIV 改小之后
            // 开火频率会跟着一起变快，用例不用另调参数。
            // 这些量是【寄存器】：出场那一拍按 spawn_type 算一次，
            // 之后 tick / 开火比较直接跟寄存器比，比每次实时 mux 省一截逻辑，
            // 也让“同一个槽里换兵种”变成可能（波次就是这么做的）。
            wire [1:0]  ntype   = spawn_type[gi*2 +: 2];
            wire [23:0] n_step  = (ntype == T_FAST)  ? (MOVE_DIV >> 1) :
                                  (ntype == T_POWER) ? MOVE_DIV :
                                                       (MOVE_DIV + (MOVE_DIV >> 1));
            wire [3:0]  n_fire  = (ntype == T_FAST)  ? (FIRE_TICKS + 4'd2) :
                                  (ntype == T_POWER) ? FIRE_TICKS :
                                                       (FIRE_TICKS * 4'd2);
            wire [1:0]  n_hp    = (ntype == T_ARMOR) ? 2'd2 : 2'd1;

            // 相位错开：cnt 初值给 0/8/16，复位后先留 ~150 拍让 4 个 terrain_probe
            // 各扫一遍，再让几辆车错开一点开始走，避免同一时刻抢同一条地图总线。
            localparam [7:0] PHASE = gi * 8;

            wire [3:0] front    = terrain_front[gi*4 +: 4];
            wire       passable = (front == T_EMPTY) || (front == T_WOODS);

            reg [9:0]  x, y;
            reg [1:0]  dir;
            reg        alive;
            reg [23:0] cnt;
            reg [15:0] rnd;
            reg [7:0]  turn_cnt;
            reg [3:0]  fire_cnt;      // 开火周期计数（按自己的移动节拍）
            reg [2:0]  stuck;         // 撞墙后试到第几个方向（0..3），走通即清零
            reg        slide_q;       // 锁存的横向滑行方向（1 = 右），撞墙才换边
            reg [1:0]  hp;            // 当前血量：装甲 2，其它 1
            reg [1:0]  my_type;       // 本槽当前兵种（出场时写入）
            reg [23:0] step;          // 本槽当前的移动节拍分频
            reg [3:0]  fire_period;   // 本槽当前的开火周期（自己的节拍数）
            reg [1:0]  hp_max;        // 本槽当前的血量上限
            reg        fire_req;      // 单拍开火请求
            reg        kill_req;      // 单拍击毁脉冲

            // ---------------- 朝基地的“贪心”目标方向 ----------------
            // 以基地中心 (300,560) 为目标做曼哈顿贪心：先走离基地更远的那一轴。
            //   want_dir   = 朝基地的方向（定期选向、以及试错④用）
            //   slide_dir  = 撞墙后贴墙滑的方向（另一轴）
            //   slide_flip = slide_dir 的反向（贴墙滑也撞墙时用，同时换边）
            // 注意横向这一轴用的是【锁存】的 slide_q（撞墙才换边），不是"实时比
            // 较 x 和基地 x"：车正好在基地正上方时（|dx| ≤ 5），实时比较每拍都
            // 会翻转，结果是在河岸 ±5px 原地抖、永远滑不到浅滩（第一版就是这样）。
            wire        tgt_right   = (x < TGT_X);          // 基地在车右边
            wire        tgt_down    = (y < TGT_Y);          // 基地在车下面
            wire [9:0]  dist_x      = tgt_right ? (TGT_X - x) : (x - TGT_X);
            wire [9:0]  dist_y      = tgt_down  ? (TGT_Y - y) : (y - TGT_Y);

            // 轴向优先级也要【锁存】（hf_q）：选定一轴就一直开到对齐（≤ 2 格）
            // 再换轴。原来是实时比较 dist_x / dist_y，贴到基地跟前时两个距离都
            // 只剩几十像素、还轮流变小，horiz_first 于是每拍翻转 —— 车就在基地
            // 门口左右横跳，看起来就是“反复转圈进不去”。锁存之后它一定先在某
            // 一轴上对齐，然后直着冲墙。
            reg         hf_q;                               // 1 = 当前先走横向
            wire        hf_next = hf_q ? (dist_x > 10'd10)
                                       : ((dist_y <= 10'd10) ? (dist_x > 10'd10)
                                                             : (dist_x > dist_y));
            wire        horiz_first = hf_q;
            wire [1:0]  want_h      = tgt_right ? D_RIGHT : D_LEFT;
            wire [1:0]  want_v      = tgt_down  ? D_DOWN : D_UP;
            wire [1:0]  want_dir    = horiz_first ? want_h : want_v;
            wire [1:0]  slide_h     = slide_q ? D_RIGHT : D_LEFT;
            wire [1:0]  slide_dir   = horiz_first ? want_v  : slide_h;
            wire [1:0]  slide_flip  = horiz_first ? (want_v ^ 2'b01)
                                                  : (slide_q ? D_LEFT : D_RIGHT);

            // 已经贴到基地跟前（横竖都在 3 块 = 60px 以内）：不再四方向试探，
            // 直接面向基地、用炮弹把挡路的砖打穿。老版本在这个距离上仍然
            // 每拍换一个方向试探，朝基地的只占 1/4 的时间，玩家看到的就是
            // “敌人在家门口转圈”。（炮弹打砖是 20x10，一发啃掉半块，
            //  砖墙撑不了几发。）
            wire        attack      = (dist_x <= 10'd60) && (dist_y <= 10'd60);

            // ---------------- 坦克互斥：下一格有没有别的车 ----------------
            // 候选位置 = 当前朝向往前一格（坐标永远是 5 的倍数，可以直接比包围盒）。
            // 本槽自己那一位在掩码里去掉（否则它会和自己重叠、原地卡死）。
            // 被别的车挡住和撞墙走的是同一条“换方向”通路 —— 敌人会像绕过墙
            // 一样绕过同伴，不会贴着同伴推。
            localparam [N_E:0] OWN_MASK = ({{N_E{1'b0}}, 1'b1} << (gi + 1));
            wire [9:0] cand_x = (dir == D_LEFT)  ? (x - TILE) :
                                (dir == D_RIGHT) ? (x + TILE) : x;
            wire [9:0] cand_y = (dir == D_UP)    ? (y - TILE) :
                                (dir == D_DOWN)  ? (y + TILE) : y;
            wire [N_E:0]      blk_v = {en_all_v, 1'b1} & ~OWN_MASK;   // 第 0 位 = 玩家
            wire [N_E*10+9:0] blk_x = {en_all_x, p_x};
            wire [N_E*10+9:0] blk_y = {en_all_y, p_y};
            wire              cand_blocked;

            tank_block #(.N(N_E + 1)) u_blk (
                .cx(cand_x), .cy(cand_y),
                .o_valid(blk_v), .o_x(blk_x), .o_y(blk_y),
                .blocked(cand_blocked)
            );

            wire wall_ahead = terrain_valid[gi] && !passable;   // 前面是砖/钢/河/基地
            wire can_go     = terrain_valid[gi] && passable && !cand_blocked;

            wire tick = (cnt >= step - 24'd1);

            // tick 的一拍寄存版：24 位比较器(3 级 CARRY4)的输出只写这一个触发器，
            // 移动/开火/地形刷新等所有“该走一步了”的判断都从 tick_q 出发。
            // 这样 step_reg -> 比较器 -> 高扇出 CE 的深路径被切成两段：
            //   step_reg -> tick_q（短）与 tick_q -> 各 CE（短）。
            // 移动比原来晚 1 拍（恒定且不可感知），cnt 的波形不变（仍按 tick 归零）。
            // 出场那一拍必须清掉：cnt 换成 PHASE 之前 tick 可能还是 1，
            // 不清的话新车会在出场后一拍就走一格。
            reg tick_q;
            always @(posedge clock) begin
                if (reset || spawn[gi]) tick_q <= 1'b0;
                else                    tick_q <= tick;
            end
            assign tick_all[gi] = tick_q;

            // ---------------- 决策流水（时序修复）----------------
            // “下一拍(tick_q)怎么走”在 tick 拍全部算好并寄存起来。
            // 原来 x/y/dir -> cand±5 -> tank_block 4 路比较 -> can_go ->
            // want_dir/slide/stuck 多路选择 -> dir 下一态是一条 15~16 级的
            // 组合长链（时序报告的 WNS -0.459 / TNS -17.8 主要来自这里）。
            // 敌人移动节拍只有 12.5~25Hz，决策早 10ns 做出完全无感；
            // 两拍之间 x/y/dir/turn_cnt 都不会变，寄存的决策与“当拍现算”
            // 严格等价（LFSR 的随机位在这里做快照，语义不变）。
            reg        d_terrain_ok;  // 决策时 probe 的结果是否可信
            reg        d_can_go;      // 前面能走（空地/树林且没有别的车）
            reg        d_wall_ahead;  // 前面是砖/钢/河/基地
            reg        d_attack;      // 已贴到基地跟前
            reg        d_turn_over;   // 巡逻计时到点，要重新选向
            reg        d_hf_next;     // 轴向锁存的下一步
            reg        d_rnd_turn;    // LFSR rnd[6]&rnd[7]：随机拐 90° 的开关
            reg        d_rnd_left;    // LFSR rnd[0]：随机拐左还是右
            reg [1:0]  d_want_dir;    // 朝基地的贪心方向
            reg [1:0]  d_slide_dir;   // 撞墙后贴墙滑的方向
            reg [1:0]  d_slide_flip;  // 贴墙滑的反向（同时换边）

            always @(posedge clock) begin
                if (reset || spawn[gi]) begin
                    d_terrain_ok <= 1'b0;
                    d_can_go     <= 1'b0;
                    d_wall_ahead <= 1'b0;
                    d_attack     <= 1'b0;
                    d_turn_over  <= 1'b0;
                    d_hf_next    <= 1'b0;
                    d_rnd_turn   <= 1'b0;
                    d_rnd_left   <= 1'b0;
                    d_want_dir   <= 2'b00;
                    d_slide_dir  <= 2'b00;
                    d_slide_flip <= 2'b00;
                end else if (tick) begin
                    d_terrain_ok <= terrain_valid[gi];
                    d_can_go     <= can_go;
                    d_wall_ahead <= wall_ahead;
                    d_attack     <= attack;
                    d_turn_over  <= (turn_cnt >= TURN_TICKS - 1);
                    d_hf_next    <= hf_next;
                    d_rnd_turn   <= (rnd[6] & rnd[7]);
                    d_rnd_left   <= rnd[0];
                    d_want_dir   <= want_dir;
                    d_slide_dir  <= slide_dir;
                    d_slide_flip <= slide_flip;
                end
            end

            assign e_valid[gi]       = alive;
            assign e_x[gi*10 +: 10]  = x;
            assign e_y[gi*10 +: 10]  = y;
            assign e_dir[gi*2  +: 2] = dir;
            assign e_type[gi*2 +: 2] = my_type;
            assign e_fire[gi]        = fire_req;
            assign e_kill[gi]        = kill_req;
            // 坦克互斥用的全场坐标（第 gi 个槽就是本车；比较时自己那一位会被屏蔽掉）
            assign en_all_x[gi*10 +: 10] = x;
            assign en_all_y[gi*10 +: 10] = y;
            assign en_all_v[gi]          = alive;

            // 上电初值（Vivado 会写进触发器的 INIT 属性，xsim 里同样生效）：
            // 复位后所有槽都是【空的】—— 敌人由 stage_ctrl 一辆一辆放进来，
            // 这样“波次”才成立；出生点也还是板上的真实坐标，不至于 (0,0)。
            initial begin
                x           = SPAWN_X;
                y           = SPAWN_Y;
                dir         = SPAWN_D;
                alive       = 1'b0;
                cnt         = PHASE;
                rnd         = 16'h1ACE + gi[15:0];
                turn_cnt    = 8'd0;
                fire_cnt    = 4'd0;
                stuck       = 3'd0;
                slide_q     = 1'b1;
                hf_q        = 1'b0;      // 先走纵向（出生点在屏幕顶端，基地在下面）
                hp          = 2'd1;
                my_type     = DEF_TYPE;
                step        = MOVE_DIV;
                fire_period = FIRE_TICKS;
                hp_max      = 2'd1;
                fire_req    = 1'b0;
                kill_req    = 1'b0;
            end
            always @(posedge clock) begin
                if (reset) begin
                    x           <= SPAWN_X;
                    y           <= SPAWN_Y;
                    dir         <= SPAWN_D;
                    alive       <= 1'b0;
                    cnt         <= PHASE;
                    rnd         <= 16'h1ACE + gi[15:0];
                    turn_cnt    <= 8'd0;
                    fire_cnt    <= 4'd0;
                    stuck       <= 3'd0;
                    slide_q     <= 1'b1;
                    hf_q        <= 1'b0;
                    hp          <= 2'd1;
                    my_type     <= DEF_TYPE;
                    step        <= MOVE_DIV;
                    fire_period <= FIRE_TICKS;
                    hp_max      <= 2'd1;
                    fire_req    <= 1'b0;
                    kill_req    <= 1'b0;
                end else if (spawn[gi]) begin
                    // ---------------- 出场：回出生点 + 按兵种装一套参数 ----------------
                    // 复用同一个槽（上一辆已经死了），所以这里要把计数器和
                    // 随机数种子全部重来，否则新车会继承旧车的转向节奏。
                    x           <= SPAWN_X;
                    y           <= SPAWN_Y;
                    dir         <= SPAWN_D;
                    alive       <= 1'b1;
                    cnt         <= PHASE;
                    turn_cnt    <= 8'd0;
                    fire_cnt    <= 4'd0;
                    stuck       <= 3'd0;
                    slide_q     <= (SPAWN_X < TGT_X);   // 先朝基地那一侧滑
                    hf_q        <= 1'b0;                // 新车重新从“先纵向”开始
                    my_type     <= ntype;
                    step        <= n_step;
                    fire_period <= n_fire;
                    hp_max      <= n_hp;
                    hp          <= n_hp;
                    fire_req    <= 1'b0;
                    kill_req    <= 1'b0;
                end else begin
                    fire_req <= 1'b0;      // 两个都是单拍脉冲
                    kill_req <= 1'b0;

                    // 16 位 LFSR（x^16 + x^14 + x^13 + x^11 + 1，最大长度序列）。
                    // 每拍走一步，换向时取里面不同的低位：不可预测但完全可复现。
                    rnd <= {rnd[14:0], rnd[15] ^ rnd[13] ^ rnd[12] ^ rnd[10]};

                    // ---------------- 挨打：先扣血，血光才死 ----------------
                    // 装甲坦克要两发（第一发只掉血，车身不变），其它一发就碎。
                    // 击毁脉冲给 top 加分；alive 一清 0，VGA 那边这辆车就消失了。
                    if (e_hit[gi] && alive && !freeze) begin
                        if (hp > 2'd1) begin
                            hp <= hp - 2'd1;
                        end else begin
                            hp       <= 2'd0;
                            alive    <= 1'b0;
                            kill_req <= 1'b1;
                        end
                    end

                    if (tick) cnt <= 24'd0;
                    else      cnt <= cnt + 24'd1;

                    if (tick_q && alive && !freeze) begin
                        // ---------------- 开火：每 fire_period 个节拍请求一发 ----------------
                        // fire_period 是出场时按兵种写好的寄存器（快速 6 / 火力 4 / 装甲 8）。
                        // 这里只发“请求”，真正的池分配/冷却/同屏 1 发限制都在
                        // bullet_ctrl 里统一做（它还要同时管玩家的炮弹）。
                        if (fire_cnt >= fire_period - 4'd1) begin
                            fire_cnt <= 4'd0;
                            fire_req <= 1'b1;
                        end else begin
                            fire_cnt <= fire_cnt + 4'd1;
                        end

                        // 巡逻计时：到点后重新选向。
                        // 3/4 概率直接对准基地（want_dir），1/4 随机拐 90°：
                        // 既保证整体在进攻，又不会三辆车排成一条直线。
                        if (d_turn_over) turn_cnt <= 8'd0;
                        else             turn_cnt <= turn_cnt + 8'd1;

                        // 下面所有“怎么走”的判断都用 tick 拍寄存好的决策
                        // （d_*）：x/y/dir -> 决策 与 决策 -> 下一态 之间隔了触发器，
                        // 不再是一条 15 级的深路径。
                        if (!d_terrain_ok) begin
                            // 刚出生 / 刚转向：新朝向上的地形结果还没回来，本拍不动
                            // （probe 扫一遍约 30 拍，只耽误不到一个节拍，看不出来）
                        end else if (d_can_go) begin
                            // 前面能走（空地/树林，且没有别的车）：沿当前朝向走一整格
                            case (dir)
                                2'b00:   if (y != 10'd0)          y <= y - TILE;  // 上
                                2'b01:   if ((y + TILE) <= Y_MAX) y <= y + TILE; // 下
                                2'b10:   if (x != 10'd0)          x <= x - TILE;  // 左
                                default: if ((x + TILE) <= X_MAX) x <= x + TILE; // 右
                            endcase
                            stuck <= 3'd0;
                            // 轴向锁存跟着“离基地的远近”推进（见 hf_next 的说明）
                            hf_q <= d_hf_next;
                            // 到点重新选向：这一格照走，下一拍 probe 会按新朝向重扫
                            if (d_turn_over)
                                dir <= d_rnd_turn
                                     ? (dir ^ (d_rnd_left ? 2'b10 : 2'b11))   // 随机拐 90°
                                     : d_want_dir;                            // 朝基地
                        end else if (d_attack && d_wall_ahead) begin
                            // 贴到基地跟前、前面是砖：别再转圈，直接顶着墙打。
                            // （这一支就是“敌人到家门口反复转圈进不去”的修复：
                            //   与其在 4 个方向里轮着试，不如朝着基地一直开炮，
                            //   炮弹会把砖墙一块一块啃掉，几发之后就能开进去。）
                            dir      <= d_want_dir;
                            stuck    <= 3'd0;
                            turn_cnt <= 8'd0;
                            // 顶墙时补一炮。bullet_ctrl 有 0.2s 冷却 + 同屏 1 发，
                            // 这里多发几次请求也不会变成弹幕。
                            fire_req <= 1'b1;
                            fire_cnt <= 4'd0;
                            hf_q     <= d_hf_next;
                        end else begin
                            // 前面是墙（砖 / 钢 / 河 / 基地 / 地图外框）或者别的坦克。
                            // 按固定顺序依次试四个方向，走通一个就把 stuck 清零：
                            //   ① 沿锁存的横向方向贴墙滑   ② 反方向滑（并换边）
                            //   ③ 掉头（主轴反向）         ④ 主轴朝基地
                            // 四个方向全覆盖，所以"三面是墙"的路口最多三拍就能
                            // 掉头出去；旧版随机转 90° 会在这种路口左右来回抖，
                            // 永远想不到往上走 —— stuck 就是这个计数器。
                            case (stuck)
                                3'd0:    dir <= d_slide_dir;
                                3'd1:    dir <= d_slide_flip;
                                3'd2:    dir <= d_want_dir ^ 2'b01;
                                default: dir <= d_want_dir;
                            endcase
                            if (stuck == 3'd1) slide_q <= ~slide_q;   // ② 之后换边
                            if (stuck == 3'd3) stuck   <= 3'd0;
                            else               stuck   <= stuck + 3'd1;
                            // 滑 SLIDE_TICKS 格之后再重新朝基地瞄一次
                            turn_cnt <= TURN_TICKS - SLIDE_TICKS;
                            hf_q     <= d_hf_next;
                        end
                    end
                end
            end
        end
    endgenerate

endmodule

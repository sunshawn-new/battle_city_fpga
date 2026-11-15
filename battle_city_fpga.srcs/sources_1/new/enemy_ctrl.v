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
//  AI（刻意做得很简单，够演示、不会失控）：
//    1. 前面能走（空地 / 树林）就沿当前朝向走一格；
//    2. 前面是墙（砖 / 钢 / 河 / 基地 / 地图外框）就原地转 90°，
//       左转还是右转由 16 位 LFSR 决定 —— 避免在墙角来回抖；
//    3. 每隔 TURN_TICKS 个节拍，如果 LFSR 某一位是 1 就随机转 90°，
//       让它在空地上也会拐弯，看起来像在“巡逻”而不是一条直线机器人。
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
    parameter TURN_TICKS = 24,           // 每多少个移动节拍随机换一次向
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

    genvar gi;
    generate
        for (gi = 0; gi < N_E; gi = gi + 1) begin : g_enemy
            // ---------------- 出生点 / 初始朝向 ----------------
            // 都在真实地图第 0~1 块（那里是空地），朝下开；x 是 5 的倍数，
            // 20x20 的车身压在自己那 4 列上，不会碰到外墙（列 0 / 列 119）。
            //   (40,10)  列 8~11    左边，往下去走左边那处浅滩（块列 4~6）
            //   (300,10) 列 60~63   中间，正对玩家出生点的纵向主通道
            //   (560,10) 列 112~115 右边，往下去走右边那处浅滩（块列 23~25）
            // N_E 超过 3 辆时，多出来的都按右边那个点出生（以后做波次再改）。
            localparam [9:0] SPAWN_X = (gi == 0) ? 10'd40 :
                                       (gi == 1) ? 10'd300 : 10'd560;
            localparam [9:0] SPAWN_Y = 10'd10;
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
            reg [1:0]  hp;            // 当前血量：装甲 2，其它 1
            reg [1:0]  my_type;       // 本槽当前兵种（出场时写入）
            reg [23:0] step;          // 本槽当前的移动节拍分频
            reg [3:0]  fire_period;   // 本槽当前的开火周期（自己的节拍数）
            reg [1:0]  hp_max;        // 本槽当前的血量上限
            reg        fire_req;      // 单拍开火请求
            reg        kill_req;      // 单拍击毁脉冲

            wire tick = (cnt >= step - 24'd1);
            assign tick_all[gi] = tick;

            assign e_valid[gi]       = alive;
            assign e_x[gi*10 +: 10]  = x;
            assign e_y[gi*10 +: 10]  = y;
            assign e_dir[gi*2  +: 2] = dir;
            assign e_type[gi*2 +: 2] = my_type;
            assign e_fire[gi]        = fire_req;
            assign e_kill[gi]        = kill_req;

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

                    if (tick && alive && !freeze) begin
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

                        // 巡逻计时：到点后由 LFSR 决定要不要拐一下
                        if (turn_cnt >= TURN_TICKS - 1) turn_cnt <= 8'd0;
                        else                            turn_cnt <= turn_cnt + 8'd1;

                        if (!terrain_valid[gi]) begin
                            // 刚出生 / 刚转向：新朝向上的地形结果还没回来，本拍不动
                            // （probe 扫一遍约 30 拍，只耽误不到一个节拍，看不出来）
                        end else if (passable) begin
                            // 前面能走：沿当前朝向走一整格（TILE 像素）
                            case (dir)
                                2'b00:   if (y != 10'd0)          y <= y - TILE;  // 上
                                2'b01:   if ((y + TILE) <= Y_MAX) y <= y + TILE; // 下
                                2'b10:   if (x != 10'd0)          x <= x - TILE;  // 左
                                default: if ((x + TILE) <= X_MAX) x <= x + TILE; // 右
                            endcase
                            // 巡逻：这一格照走，同时随机换个朝向（下一拍 probe 重新扫描）
                            if (turn_cnt >= TURN_TICKS - 1 && rnd[3])
                                dir <= dir ^ 2'b10;
                        end else begin
                            // 前面是墙：转 90°（左/右由 LFSR 决定）。
                            // 2'b10 / 2'b11 都是“垂直转向”，交替着来就不会在墙角来回抖；
                            // 另外 1/4 概率直接掉头 —— 掉头的方向刚走过、一定通，
                            // 这是“贴着墙角出不来”的保底出口（比如一直沿着右墙上下滑）。
                            dir <= dir ^ ((rnd[1:0] == 2'b00) ? 2'b01
                                                              : (rnd[0] ? 2'b10 : 2'b11));
                        end
                    end
                end
            end
        end
    endgenerate

endmodule

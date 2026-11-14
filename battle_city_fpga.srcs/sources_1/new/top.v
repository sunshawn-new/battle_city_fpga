`timescale 1ns / 1ps

module top #(
    // 坦克移动节拍分频：100MHz / 4_000_000 = 25Hz，每拍走 1 格 = 5 像素
    //   -> 125 像素/秒（6.25 个车身/秒，横穿 600 像素约 4.8 秒）。
    //   比原来的 62.5 像素/秒快一倍，和原版 Battle City 的节奏接近。
    //   仿真里会改小以加速。
    parameter MOVE_DIV = 4_000_000,
    // 敌方坦克辆数：每辆占一个 terrain_probe（地图总线上多一位 p_req）
    parameter N_ENEMY  = 3,
    // 敌方坦克的“巡逻”周期（多少个移动节拍随机换一次向）。
    // 仿真里给个大值，让用例不被随机转向干扰。
    parameter TURN_TICKS = 24,
    // 敌人开火周期基准（按各自的移动节拍计数，见 enemy_ctrl）：
    //   快速 +2 拍 / 火力 0 拍（就是它）/ 装甲 x2 拍
    parameter FIRE_TICKS = 4,
    // 初始生命数（GAME OVER 条件之一）
    parameter LIVES_START = 3,
    // 复活后的无敌时间（时钟数）：1s @100MHz。无敌期间不会再被打中。
    // 仿真里改小（不然一个用例要跑 1 亿拍）。
    parameter INVULN_CYCLES = 100_000_000,
    // 敌人开火总开关：1 = 正常（板上默认），0 = 敌人不开火。
    // 地形/移动那几个老用例不关心战斗，关掉它才能保证结果可复现。
    parameter ENEMY_FIRE = 1,
    // 爆炸动画：每个相位多少拍（100MHz -> 80ms），一共 6 个相位 = 480ms
    // （前 3 个相位放"亮爆团"，后 3 个放"星形环"）。仿真里改小。
    parameter FX_DIV = 8_000_000
)(
    input clock,       // 100MHz
    input reset,
    input btn_up, btn_down, btn_left, btn_right,
    input btn_fire,    // 开火（板上中心按键 btnC）
    output [11:0] disp_RGB,
    output hsync,
    output vsync
);
    // ---------------- 地图 / 坦克尺寸 ----------------
    // 600x600 玩区 = 120x120 格；屏幕右边 200px（x = 600..799）是 HUD。
    // BRAM 的物理深度还是 19200（IP 不用重新生成），最大地址 14399。
    localparam MAP_W  = 120;    // 地图横向 120 格
    localparam MAP_H  = 120;    // 地图纵向 120 格
    localparam TILE   = 5;      // 每格 5x5 像素
    localparam TANK_W = 20;     // 坦克 20x20 像素（= 4x4 格）
    localparam TANK_H = 20;
    localparam PLAY_W = MAP_W * TILE;   // 600：玩区宽度（player/enemy 用）

    localparam N_BULLET = N_ENEMY + 1;  // 炮弹对象池：玩家 1 发 + 每辆敌人 1 发
    localparam N_FX     = 4;            // 爆炸槽：3 辆敌人 + 玩家，最坏情况同拍全死也不丢帧

    wire [9:0] player_x, player_y;
    wire [3:0] player_terrain_in_front;
    wire       terrain_valid;
    wire       move_tick;              // 坦克的移动节拍（25Hz），用来定期刷新地形查询

    // 生命 / 分数 / 结算状态（HUD 和玩法共用）
    //   lives     : 还剩几条命（3 -> 0）；归零立刻 GAME OVER
    //   score100  : 分数 / 100（每辆敌人 +1/+2/+3 -> 100/200/300 分）；
    //               因为分数永远是 100 的倍数，HUD 直接用十进制显示 nn00，
    //               省掉一个 16 位 /10 除法器（见 hud.v 的说明）
    //   game_over : 基地被打爆 或 生命耗尽，锁存（本工程没有重开一局）
    //   victory   : 三辆敌人全部被击毁
    reg [1:0] lives     = LIVES_START;
    reg [3:0] score100  = 4'd0;
    reg       game_over = 1'b0;
    reg       victory   = 1'b0;
    reg [27:0] invuln_cnt = 28'd0;     // 复活无敌倒计时
    reg        respawn_pulse = 1'b0;
    wire       player_invuln = (invuln_cnt != 28'd0);
    wire       player_alive  = ~game_over & ~player_invuln;
    wire       freeze        = game_over;   // GAME OVER 后玩家/敌人都不再动

    player #(
        .MOVE_DIV(MOVE_DIV), .TILE(TILE),
        .WIDTH(PLAY_W), .HEIGHT(MAP_H * TILE)
    ) u_player(
        .clock(clock), .reset(reset),
        .up_enable(btn_up), .down_enable(btn_down),
        .left_enable(btn_left), .right_enable(btn_right),
        .position_x(player_x), .position_y(player_y),
        .terrain_in_front(player_terrain_in_front),
        .terrain_valid(terrain_valid),
        .respawn(respawn_pulse), .freeze(freeze),
        .move_tick(move_tick)
    );

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

    wire vga_clk;
    wire [14:0] vga_map_addr;
    wire [3:0]  vga_tile_id;
    // ================================================================================
    //  地图 BRAM Port A 的共享：地形查询引擎（玩家 + 敌人） + 炮弹引擎 -> map_bus -> BRAM
    //
    //  原来 Port A 只有“玩家前方地形查询”一个客户端，地址直接由它驱动、wea 恒为 0。
    //  加炮弹之后变成多客户端，所以中间加一层 map_bus 做窗口式仲裁：
    //    · 每个客户端用 req 电平圈走一段独占时间窗，窗口内地址不会被切走
    //    · 炮弹要读地图判命中，还要把砖块改写成空地 —— 所以 Port A 现在有写通路
    //  地形查询仍然享有最高优先级（玩家 0 号、敌人 1..N 号），并且是“非抢占”的，
    //  扫描中途不会被插队，所以原来那批地形断言在改成共享总线之后依然成立。
    // ================================================================================
    wire [14:0] ram_addra;
    wire        ram_wea;
    wire [3:0]  ram_dina;
    wire [3:0]  ram_douta;

    // ---- 地形查询客户端：玩家 + N_ENEMY 辆敌方坦克，全部挂同一条窗口式总线 ----
    //   p_req[0]    = 玩家（优先级最高）
    //   p_req[1..N] = 敌方坦克（编号小的优先；窗口是非抢占的，不会互相打断）
    // 每辆敌方坦克各有一个 terrain_probe 实例：坐标/朝向接 enemy_ctrl 的实时值，
    // refresh 接它自己的移动节拍 —— 和玩家坦克的用法完全一致。
    localparam N_PROBE = N_ENEMY + 1;
    wire [N_PROBE-1:0]    p_req, p_gnt;
    wire [N_PROBE*15-1:0] p_addr;

    // ---- 客户端 0：玩家前方地形查询 ----
    wire        probe_req;
    wire [14:0] probe_addr;

    terrain_probe #(
        .MAP_W(MAP_W), .MAP_H(MAP_H), .TILE(TILE),
        .TANK_W(TANK_W), .TANK_H(TANK_H)
    ) u_probe (
        .clock(clock), .reset(reset),
        .x(player_x), .y(player_y), .dir(player_direction),
        .refresh(move_tick),
        .map_req(probe_req), .map_addr(probe_addr), .map_gnt(p_gnt[0]),
        .map_dout(ram_douta),
        .terrain(player_terrain_in_front), .valid(terrain_valid)
    );

    assign p_req[0]        = probe_req;
    assign p_addr[0 +: 15] = probe_addr;

    // ---- 客户端 1..N：敌方坦克 ----
    wire [N_ENEMY-1:0]    enemy_valid;          // 1 = 这辆车还在（VGA 画不画）
    wire [N_ENEMY*10-1:0] enemy_x, enemy_y;
    wire [N_ENEMY*2-1:0]  enemy_dir;
    wire [N_ENEMY*2-1:0]  enemy_type;           // 每辆车的兵种（VGA 用它选贴图）
    wire [N_ENEMY-1:0]    enemy_move_tick;      // 每辆车自己的移动节拍
    wire [N_ENEMY-1:0]    enemy_terrain_valid;
    wire [N_ENEMY*4-1:0]  enemy_terrain_front;

    genvar ge;
    generate
        for (ge = 0; ge < N_ENEMY; ge = ge + 1) begin : g_enemy_probe
            wire        e_req;
            wire [14:0] e_addr;

            terrain_probe #(
                .MAP_W(MAP_W), .MAP_H(MAP_H), .TILE(TILE),
                .TANK_W(TANK_W), .TANK_H(TANK_H)
            ) u_probe (
                .clock(clock), .reset(reset),
                .x(enemy_x[ge*10 +: 10]), .y(enemy_y[ge*10 +: 10]),
                .dir(enemy_dir[ge*2 +: 2]),
                .refresh(enemy_move_tick[ge]),
                .map_req(e_req), .map_addr(e_addr), .map_gnt(p_gnt[ge + 1]),
                .map_dout(ram_douta),
                .terrain(enemy_terrain_front[ge*4 +: 4]),
                .valid(enemy_terrain_valid[ge])
            );

            assign p_req[ge + 1]             = e_req;
            assign p_addr[(ge + 1)*15 +: 15] = e_addr;
        end
    endgenerate

    // ---- 敌方坦克：运动 + 转向（AI）----
    // MOVE_DIV 用玩家的 2 倍当“中间档”，enemy_ctrl 内部再按兵种分流：
    //   快速 = 玩家速度 / 火力 = 中间档 / 装甲 = 1.5 倍
    wire [N_ENEMY-1:0] enemy_fire;              // 单拍开火请求
    wire [N_ENEMY-1:0] enemy_fire_eff = ENEMY_FIRE ? enemy_fire : {N_ENEMY{1'b0}};
    wire [N_ENEMY-1:0] enemy_kill;              // 单拍击毁（top 用它加分）
    wire [N_ENEMY-1:0] enemy_hit;               // 单拍挨打（bullet_ctrl 报的）

    enemy_ctrl #(
        .N_E(N_ENEMY), .WIDTH(PLAY_W), .HEIGHT(MAP_H * TILE), .TILE(TILE),
        .MOVE_DIV(MOVE_DIV * 2), .TURN_TICKS(TURN_TICKS), .FIRE_TICKS(FIRE_TICKS)
    ) u_enemy_ctrl (
        .clock(clock), .reset(reset),
        .terrain_front(enemy_terrain_front),
        .terrain_valid(enemy_terrain_valid),
        .move_tick(enemy_move_tick),
        .e_hit(enemy_hit), .freeze(freeze),
        .e_fire(enemy_fire), .e_kill(enemy_kill),
        .e_valid(enemy_valid),
        .e_x(enemy_x), .e_y(enemy_y), .e_dir(enemy_dir),
        .e_type(enemy_type)
    );

    // ---- 客户端 2：炮弹对象池（玩家 + 敌人共用一套；发射 / 飞行 / 命中 / 打砖）----
    wire        b_req, b_we, b_gnt;
    wire        b_base_hit;                   // 单拍：炮弹命中基地格（tile_id == 5）
    wire        b_hit_player;                 // 单拍：玩家的炮弹打中玩家
    reg         base_alive = 1'b1;            // 基地是否还活着（1 = 金鹰，0 = 白旗）
    wire [14:0] b_addr;
    wire [3:0]  b_din;
    wire [N_BULLET-1:0]    b_valid, b_owner;
    wire [N_BULLET*10-1:0] b_x, b_y;
    wire [N_BULLET*2-1:0]  b_dir;

    bullet_ctrl #(
        .N_B(N_BULLET),
        .N_E(N_ENEMY),
        .SPEED_DIV(24'd250_000),      // 400Hz：坦克 25Hz 的 16 倍，视觉上“快”
        .COOLDOWN(26'd20_000_000),    // 0.2s 冷却
        .ONE_AT_A_TIME(1),            // 经典规则：每个发射者同屏只允许 1 发
        .BW(10), .BH(10),
        .MAP_W(MAP_W), .MAP_H(MAP_H), .TILE(TILE)
    ) u_bullet_ctrl (
        .clock(clock), .reset(reset),
        .fire_btn(btn_fire),
        .player_alive(player_alive),
        .freeze(freeze),
        .tank_x(player_x), .tank_y(player_y), .tank_dir(player_direction),
        .e_fire(enemy_fire_eff),
        .e_x(enemy_x), .e_y(enemy_y), .e_dir(enemy_dir), .e_alive(enemy_valid),
        .hit_player(b_hit_player), .hit_enemy(enemy_hit),
        .map_req(b_req), .map_we(b_we), .map_addr(b_addr), .map_din(b_din),
        .map_gnt(b_gnt), .map_dout(ram_douta),
        .base_hit(b_base_hit),
        .b_valid(b_valid), .b_owner(b_owner), .b_x(b_x), .b_y(b_y), .b_dir(b_dir)
    );

    // ---- 爆炸特效：坦克被击毁 / 玩家中弹（2 帧动画，见 fx_ctrl.v）----
    // 位置必须在“死亡那一拍”采样：玩家中弹后的下一拍就被 respawn 拉回出生点，
    // 所以 p_x/p_y 直接接 player_x/player_y —— fx_ctrl 和 player.v 在同一个时钟沿
    // 采样，那一拍拿到的还是死亡位置（晚一拍就成出生点坐标了）。
    // 敌人这边 e_kill 是单拍脉冲，e_x/e_y 在死亡后不再变化，怎么采都对。
    wire [N_FX-1:0]    fx_valid;
    wire [N_FX*10-1:0] fx_x, fx_y;
    wire [N_FX*2-1:0]  fx_frame;

    fx_ctrl #(
        .N_FX(N_FX), .N_E(N_ENEMY),
        .FX_DIV(FX_DIV), .FX_PHASES(6)
    ) u_fx_ctrl (
        .clock(clock), .reset(reset),
        .e_kill(enemy_kill), .e_x(enemy_x), .e_y(enemy_y),
        .p_kill(b_hit_player & player_alive),
        .p_x(player_x), .p_y(player_y),
        .fx_valid(fx_valid), .fx_x(fx_x), .fx_y(fx_y), .fx_frame(fx_frame)
    );

    // ---- 打法状态机：基地 / 生命 / 分数 / 胜负（全部锁存在 top）----
    // 放在 top 而不是 vga：vga 只决定“画哪张贴图”，这些是系统状态。
    //   · 基地被打中一次 -> base_alive=0（白旗贴图）+ game_over
    //   · 玩家被打中 -> 扣一条命 + 回到出生点 + 一段无敌时间；命没了 -> game_over
    //   · 三辆敌人全灭 -> victory（本工程只有一关，没有下一关）
    // game_over 之后 freeze=1：玩家和敌人都不再移动/开火（画面定格）。
    reg [1:0] kill_pts;
    reg       kill_any;
    integer   ki;
    always @(*) begin
        kill_pts = 2'd0;
        kill_any = 1'b0;
        for (ki = 0; ki < N_ENEMY; ki = ki + 1)
            if (enemy_kill[ki]) begin
                kill_any = 1'b1;
                case (enemy_type[ki*2 +: 2])
                    2'd0:    kill_pts = 2'd1;   // 快速：100 分
                    2'd1:    kill_pts = 2'd2;   // 火力：200 分
                    default: kill_pts = 2'd3;   // 装甲：300 分
                endcase
            end
    end

    always @(posedge clock) begin
        if (reset) begin
            base_alive    <= 1'b1;
            lives         <= LIVES_START;
            score100      <= 4'd0;
            game_over     <= 1'b0;
            victory       <= 1'b0;
            invuln_cnt    <= 28'd0;
            respawn_pulse <= 1'b0;
        end else begin
            respawn_pulse <= 1'b0;              // 单拍脉冲

            if (b_base_hit) begin
                base_alive <= 1'b0;
                game_over  <= 1'b1;
            end

            if (kill_any) score100 <= score100 + {2'b0, kill_pts};

            // 敌人全灭 -> 胜利（只在还没输的时候点亮）
            if (!game_over && (enemy_valid == {N_ENEMY{1'b0}}))
                victory <= 1'b1;

            // 玩家中弹：扣命 -> 复活 + 无敌；最后一条命就 GAME OVER
            if (b_hit_player && player_alive) begin
                if (lives <= 2'd1) begin
                    lives     <= 2'd0;
                    game_over <= 1'b1;
                end else begin
                    lives         <= lives - 2'd1;
                    invuln_cnt    <= INVULN_CYCLES;
                    respawn_pulse <= 1'b1;
                end
            end else if (invuln_cnt != 28'd0) begin
                invuln_cnt <= invuln_cnt - 28'd1;
            end
        end
    end

    // ---- 仲裁器：N_PROBE 个地形查询客户端 + 1 个炮弹客户端 ----
    map_bus #(.N_PROBE(N_PROBE)) u_map_bus (
        .clock(clock), .reset(reset),
        .p_req(p_req), .p_addr(p_addr), .p_gnt(p_gnt),
        .b_req(b_req), .b_we(b_we), .b_addr(b_addr), .b_din(b_din), .b_gnt(b_gnt),
        .ram_addra(ram_addra), .ram_wea(ram_wea), .ram_dina(ram_dina)
    );
    vga #(.N_B(N_BULLET), .N_E(N_ENEMY), .N_FX(N_FX)) u_vga(
        .clock(clock), .reset(reset),
        .position_x(player_x), .position_y(player_y),
        .map_addr(vga_map_addr),
        .tile_id(vga_tile_id),
        .disp_RGB(disp_RGB), .hsync(hsync), .vsync(vsync),
        .vga_clk(vga_clk),
        .player_direction(player_direction),
        .bullet_valid(b_valid), .bullet_owner(b_owner),
        .bullet_x(b_x), .bullet_y(b_y), .bullet_dir(b_dir),
        .enemy_valid(enemy_valid),
        .enemy_x(enemy_x), .enemy_y(enemy_y), .enemy_dir(enemy_dir),
        .enemy_type(enemy_type),
        .fx_valid(fx_valid), .fx_x(fx_x), .fx_y(fx_y), .fx_frame(fx_frame),
        .hq_destroyed(~base_alive),
        // ---- HUD：右侧 200px 信息栏 ----
        .hud_score100(score100),
        .hud_lives({1'b0, lives}),
        .hud_level(3'd1),
        .hud_game_over(game_over),
        .hud_victory(victory)
    );

    blk_mem_gen_0 u_map_ram (
        // ========== Port A (系统总线：地形查询 / 炮弹命中与打砖，由 map_bus 仲裁) ==========
        .clka  (clock),
        .wea   (ram_wea),         // 只有炮弹打掉砖块时才会为 1
        .addra (ram_addra),       // map_bus 选出的客户端地址
        .dina  (ram_dina),        // 打砖时写 0（空地）
        .douta (ram_douta),       // 读出的一格地形（广播给所有客户端）

        // ========== Port B (VGA 渲染：纯粹只读) ==========
        .clkb  (vga_clk),
        .web   (1'b0),            // VGA 永远不写
        .addrb (vga_map_addr),
        .dinb  (4'd0),            // 永远不写，补 0
        .doutb (vga_tile_id)      // 给 VGA 模块渲染画面
    );
endmodule
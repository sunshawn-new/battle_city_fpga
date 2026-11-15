`timescale 1ns / 1ps

// ============================================================================
//  stage_ctrl —— 关卡推进 / 敌人波次
//
//  【它管什么】本工程原来“3 辆敌人全灭 = victory 锁死”，打完就没事可做了。
//  这一版把它换成经典 Battle City 的关卡循环：
//    · 每关要打 ENEMIES_PER_STAGE 辆（默认 20），同屏最多 N_E 辆（= 敌人槽数 3）；
//    · 开局的 N_E 辆同时出场（不拖延），之后每 SPAWN_CYCLES（3s）补一辆 ——
//      这就是“按时间顺序刷新出更多敌人”，玩家能预期节奏，不会一次被淹；
//    · 兵种按队列出：前 3 辆固定 快速/火力/装甲（让玩家先看清三种车），
//      后面按关卡的配比表出（越往后重装越多），见 type_of()；
//    · 本关打完（队列空 && 场上没人）-> STAGE CLEAR 横幅 CLEAR_CYCLES（2s）
//      -> 装载下一关地图 -> 玩家回出生点、敌人重新排一屏 -> 继续；
//    · 打完最后一关回到第 1 关（无限循环，分数/生命不清零）。
//
//  【为什么不放在 top.v 里】
//    top 已经在管地图总线、生命/分数、VGA 接线；关卡流程是一个完整的小状态机
//    （队列 + 计时 + 装载握手），单独成模块才能和 enemy_ctrl（只负责“一辆车怎么
//    动”）切开：enemy_ctrl 不知道有“波次”，stage_ctrl 不知道“坦克怎么走”，
//    两者只通过 spawn / e_valid 两个信号握手。
//
//  【paused 的作用】S_CLEAR / S_LOAD 期间 paused=1，top 用它冻结玩家、敌人、
//    炮弹，并把 terrain_probe 复位 —— 装载地图时必须保证没人正在查询地图。
// ============================================================================
module stage_ctrl #(
    parameter N_E      = 3,             // 敌人槽数（同屏最多几辆）
    parameter N_LEVELS = 4,             // 一共几关（打完循环回第 1 关）
    parameter ENEMIES_PER_STAGE = 20,   // 每关要打多少辆
    parameter SPAWN_CYCLES = 300_000_000,   // 补一辆车的间隔：3s @100MHz
    parameter CLEAR_CYCLES = 200_000_000    // STAGE CLEAR 横幅停留：2s @100MHz
)(
    input             clock,
    input             reset,
    input             game_over,        // 1 = 本局结束：不再刷新敌人

    input [N_E-1:0]   e_valid,          // 敌人槽占用情况（来自 enemy_ctrl）
    input             load_done,        // 单拍：level_loader 装载完成

    output reg [N_E-1:0]   spawn,       // 单拍：往第 i 槽放一辆新车
    output reg [N_E*2-1:0] spawn_type,  // 新车的兵种（00 快速 / 01 火力 / 10 装甲）

    output reg [2:0]  level,            // 当前关卡号 1..N_LEVELS
    output     [5:0]  enemies_left,     // 本关还剩多少辆（含场上活着的），HUD 用
    output reg        stage_clear,      // 1 = 正在放 STAGE CLEAR 横幅
    output reg        load_start,       // 单拍：让 level_loader 开始装载
    output reg [2:0]  load_level,       // 要装哪一关
    output reg        respawn,          // 单拍：玩家回出生点（每关开局一次）
    output            paused           // 1 = 全场暂停（横幅 / 装载地图）
);
    localparam S_PLAY  = 2'd0,
               S_CLEAR = 2'd1,
               S_LOAD  = 2'd2;

    localparam [1:0] T_FAST  = 2'd0,
                     T_POWER = 2'd1,
                     T_ARMOR = 2'd2;

    reg [5:0]  remaining = 6'd0;   // 本关还没出场的辆数
    reg [5:0]  idx       = 6'd0;   // 本关已经出场到第几辆（决定兵种）
    reg [2:0]  state     = S_PLAY;
    reg [31:0] spawn_timer = 32'd0;
    reg [31:0] clear_timer = 32'd0;

    assign paused = (state != S_PLAY);

    // ---------------- 出场兵种队列 ----------------
    // 每关的配比（前 3 辆固定 F/P/A 之后，剩下的 17 辆按 fast -> power -> armor
    // 的顺序出，让一关里“先轻后重”，压力是逐步加上去的）：
    //   第 1 关 10 快 / 5 火 / 2 装    第 2 关 6 / 7 / 4
    //   第 3 关  3 / 6 / 8             第 4 关 1 / 4 / 12
    function [1:0] type_of;
        input [5:0] k;      // 本关第几辆（0 起）
        input [2:0] lv;     // 关卡号
        reg   [5:0] n_fast, n_power, rest;
        begin
            // 前 3 辆：三种兵种各一辆（和旧的“左快 / 中火 / 右装”完全一致）
            if (k == 6'd0)      type_of = T_FAST;
            else if (k == 6'd1) type_of = T_POWER;
            else if (k == 6'd2) type_of = T_ARMOR;
            else begin
                case (lv)
                    3'd1:    begin n_fast = 6'd10; n_power = 6'd5;  end
                    3'd2:    begin n_fast = 6'd6;  n_power = 6'd7;  end
                    3'd3:    begin n_fast = 6'd3;  n_power = 6'd6;  end
                    default: begin n_fast = 6'd1;  n_power = 6'd4;  end
                endcase
                rest = k - 6'd3;
                if (rest < n_fast)                type_of = T_FAST;
                else if (rest < n_fast + n_power) type_of = T_POWER;
                else                              type_of = T_ARMOR;
            end
        end
    endfunction

    // ---------------- 找编号最小的空槽 ----------------
    // 倒序覆盖：最后写进去的是编号最小的空槽 —— 空槽从小到大用，
    // 出生点也就按 (40,10) -> (300,10) -> (560,10) 的顺序周转。
    //
    // 注意要同时看 spawn：e_valid 是“这一拍之前”的状态，刚派出去的槽要等到
    // 下一个时钟沿才在 e_valid 里变 1。不把 spawn 并进来，同一次“开局排一屏”
    // 就会连着两拍派给同一个槽（而且多吃掉一个队列名额）。
    wire [N_E-1:0] slot_busy = e_valid | spawn;

    reg [2:0] free_i;
    reg       free_any;
    integer   i;
    always @(*) begin
        free_i   = 3'd0;
        free_any = 1'b0;
        for (i = N_E - 1; i >= 0; i = i - 1)
            if (!slot_busy[i]) begin
                free_any = 1'b1;
                free_i   = i[2:0];
            end
    end

    wire [5:0] alive_cnt = {5'd0, slot_busy[0]} + {5'd0, slot_busy[1]} + {5'd0, slot_busy[2]};
    assign enemies_left = remaining + alive_cnt;

    // 开局（本关前 N_E 辆）直接放满一屏；之后按 SPAWN_CYCLES 补车。
    wire spawn_now = (state == S_PLAY) && !game_over && (remaining != 6'd0) && free_any &&
                     ((idx < N_E) || (spawn_timer == 32'd0));

    // 本关打完：队列空了，而且场上一辆都不剩。
    // 这里必须用 slot_busy 而不是 e_valid —— 最后一辆“刚派出去”的那一拍
    // e_valid 还是 0，用它会把正常的补车误判成“全灭”。
    wire stage_done = (state == S_PLAY) && !game_over &&
                      (remaining == 6'd0) && (slot_busy == {N_E{1'b0}});

    always @(posedge clock) begin
        if (reset) begin
            state       <= S_PLAY;
            remaining   <= ENEMIES_PER_STAGE[5:0];
            idx         <= 6'd0;
            spawn       <= {N_E{1'b0}};
            spawn_type  <= {N_E*2{1'b0}};
            level       <= 3'd1;
            stage_clear <= 1'b0;
            load_start  <= 1'b0;
            load_level  <= 3'd1;
            respawn     <= 1'b0;
            spawn_timer <= 32'd0;
            clear_timer <= 32'd0;
        end else begin
            spawn      <= {N_E{1'b0}};      // 都是单拍脉冲
            load_start <= 1'b0;
            respawn    <= 1'b0;

            // 补车计时：减到 0 就停在那儿，等有空槽立刻出场
            if (spawn_timer != 32'd0) spawn_timer <= spawn_timer - 32'd1;

            if (spawn_now) begin
                spawn[free_i]             <= 1'b1;
                spawn_type[free_i*2 +: 2] <= type_of(idx, level);
                remaining                 <= remaining - 6'd1;
                idx                       <= idx + 6'd1;
                spawn_timer               <= SPAWN_CYCLES;
            end

            case (state)
                S_PLAY: begin
                    if (stage_done) begin
                        stage_clear <= 1'b1;
                        clear_timer <= CLEAR_CYCLES;
                        state       <= S_CLEAR;
                    end
                end

                S_CLEAR: begin
                    // 横幅停留 CLEAR_CYCLES（2s），期间 paused=1：全场冻结
                    if (clear_timer != 32'd0) clear_timer <= clear_timer - 32'd1;
                    else begin
                        stage_clear <= 1'b0;
                        load_level  <= (level >= N_LEVELS) ? 3'd1 : level + 3'd1;
                        load_start  <= 1'b1;
                        state       <= S_LOAD;
                    end
                end

                default: begin // S_LOAD：等 level_loader 把新地图写完
                    if (load_done) begin
                        level       <= load_level;
                        remaining   <= ENEMIES_PER_STAGE[5:0];
                        idx         <= 6'd0;
                        spawn_timer <= 32'd0;
                        respawn     <= 1'b1;        // 玩家回出生点
                        state       <= S_PLAY;
                    end
                end
            endcase
        end
    end
endmodule

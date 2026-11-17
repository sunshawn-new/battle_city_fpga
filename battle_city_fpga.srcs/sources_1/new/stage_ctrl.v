`timescale 1ns / 1ps

module stage_ctrl #(
    parameter N_E      = 3,
    parameter N_LEVELS = 4,
    parameter ENEMIES_PER_STAGE = 20,
    parameter SPAWN_CYCLES = 300_000_000,
    parameter CLEAR_CYCLES = 200_000_000
)(
    input             clock,
    input             reset,
    input             restart, 
    input             game_over, 

    input [N_E-1:0]   e_valid,
    input             load_done,  

    output reg [N_E-1:0]   spawn,   
    output reg [N_E*2-1:0] spawn_type, 

    output reg [2:0]  level,
    output     [5:0]  enemies_left,  
    output reg        stage_clear,  
    output reg        load_start, 
    output reg [2:0]  load_level,  
    output reg        respawn,   
    output            paused    
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

    function [1:0] type_of;
        input [5:0] k; 
        input [2:0] lv;   
        reg   [5:0] n_fast, n_power, rest;
        begin
            if (k == 6'd0)      type_of = T_FAST;
            else if (k == 6'd1) type_of = T_POWER;
            else if (k == 6'd2) type_of = T_ARMOR;
            else begin
                case (lv)
                    3'd1:    begin n_fast = 6'd4; n_power = 6'd10;  end
                    3'd2:    begin n_fast = 6'd4;  n_power = 6'd7;  end
                    3'd3:    begin n_fast = 6'd6;  n_power = 6'd6;  end
                    default: begin n_fast = 6'd6;  n_power = 6'd4;  end
                endcase
                rest = k - 6'd3;
                if (rest < n_fast)                type_of = T_FAST;
                else if (rest < n_fast + n_power) type_of = T_POWER;
                else                              type_of = T_ARMOR;
            end
        end
    endfunction

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

    wire spawn_now = (state == S_PLAY) && !game_over && (remaining != 6'd0) && free_any &&
                     ((idx < N_E) || (spawn_timer == 32'd0));

    wire stage_done = (state == S_PLAY) && !game_over &&
                      (remaining == 6'd0) && (slot_busy == {N_E{1'b0}});

    always @(posedge clock) begin
        if (reset || restart) begin
            state       <= S_LOAD;
            remaining   <= ENEMIES_PER_STAGE[5:0];
            idx         <= 6'd0;
            spawn       <= {N_E{1'b0}};
            spawn_type  <= {N_E*2{1'b0}};
            level       <= 3'd1;
            stage_clear <= 1'b0;
            load_start  <= 1'b1; 
            load_level  <= 3'd1;
            respawn     <= 1'b0;
            spawn_timer <= 32'd0;
            clear_timer <= 32'd0;
        end else begin
            spawn      <= {N_E{1'b0}};      // 都是单拍脉冲
            load_start <= 1'b0;
            respawn    <= 1'b0;

            // 补车计时：减到 0 就停在那里，等有空槽立刻出场
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

                default: begin // 等 level_loader 把新地图写完
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

`timescale 1ns / 1ps

module vga #(
    parameter N_B = 4,
    parameter N_E = 3,
    parameter N_FX = 4
)(
    input clock,                  // 100MHz
    input reset,
    input [9:0] position_x,       // 修复位宽
    input [9:0] position_y,
    input       player_hide,  // 1表示这一帧不画玩家坦克
    input wire [3:0] tile_id,
    input wire [1:0] player_direction,
    input wire [N_B-1:0]    bullet_valid,
    input wire [N_B*10-1:0] bullet_x,
    input wire [N_B*10-1:0] bullet_y,
    input wire [N_B*2-1:0]  bullet_dir,
    input wire [N_E-1:0]    enemy_valid,
    input wire [N_E*10-1:0] enemy_x,
    input wire [N_E*10-1:0] enemy_y,
    input wire [N_E*2-1:0]  enemy_dir,
    input wire [N_E*2-1:0]  enemy_type,
    input wire [N_B-1:0]    bullet_owner,
    input wire [N_FX-1:0]    fx_valid,
    input wire [N_FX*10-1:0] fx_x,
    input wire [N_FX*10-1:0] fx_y,
    input wire [N_FX*2-1:0]  fx_frame,   // 0亮爆团，1星形环
    input wire              hq_destroyed, // 基地状态，1表示已被炮弹打爆
    input wire [3:0]        hud_score100,
    input wire [2:0]        hud_lives,
    input wire [2:0]        hud_level,
    input wire [5:0]        hud_enemy_left,
    input wire              hud_game_over,
    input wire              hud_victory,
    output wire vga_clk,
    output [11:0] disp_RGB,
    output wire hsync,
    output wire vsync,
    output wire [14:0] map_addr
);
    wire dat_act, hsync_raw, vsync_raw;

    localparam [10:0] H_SYNC_END  = 11'd119,
                      H_DAT_BEGIN = 11'd184,
                      H_DAT_END   = 11'd984,
                      H_PIXEL_END = 11'd1039,
                      V_SYNC_END  = 11'd5,
                      V_DAT_BEGIN = 11'd29,
                      V_DAT_END   = 11'd629,
                      V_LINE_END  = 11'd665;

    reg [10:0] hcount = 11'd0;
    reg [10:0] vcount = 11'd0;
    
    reg clk_50m_reg = 1'b0;
    always @(posedge clock) begin
        if(reset) clk_50m_reg <= 1'b0;
        else clk_50m_reg <= ~clk_50m_reg;
    end

    assign vga_clk = clk_50m_reg;

    always @(posedge vga_clk) begin
        if (hcount == H_PIXEL_END) hcount <= 11'd0;
        else                       hcount <= hcount + 11'd1;
    end

    always @(posedge vga_clk) begin
        if (hcount == H_PIXEL_END) begin
            if (vcount == V_LINE_END) vcount <= 11'd0;
            else                      vcount <= vcount + 11'd1;
        end
    end

    assign dat_act = ((hcount >= H_DAT_BEGIN) && (hcount < H_DAT_END)) &&
                     ((vcount >= V_DAT_BEGIN) && (vcount < V_DAT_END));
    assign hsync_raw = (hcount <= H_SYNC_END);
    assign vsync_raw = (vcount <= V_SYNC_END);

    wire [10:0] img_x = hcount - H_DAT_BEGIN;   // 0..799
    wire [10:0] img_y = vcount - V_DAT_BEGIN;   // 0..599

    reg [9:0]          position_x_q, position_y_q;
    reg                player_hide_q;
    reg [1:0]          player_direction_q;
    reg [N_E-1:0]      enemy_valid_q;
    reg [N_E*10-1:0]   enemy_x_q, enemy_y_q;
    reg [N_E*2-1:0]    enemy_dir_q, enemy_type_q;
    reg [N_B-1:0]      bullet_valid_q;
    reg [N_B*10-1:0]   bullet_x_q, bullet_y_q;
    reg [N_B*2-1:0]    bullet_dir_q;
    reg [N_B-1:0]      bullet_owner_q;   // 1 = 敌人打的（画成偏品红）
    reg [N_FX-1:0]     fx_valid_q;
    reg [N_FX*10-1:0]  fx_x_q, fx_y_q;
    reg [N_FX*2-1:0]   fx_frame_q;

    reg [10:0]         img_x_d1, img_y_d1;

    always @(posedge vga_clk) begin
        img_x_d1           <= img_x;
        img_y_d1           <= img_y;
        position_x_q       <= position_x;
        position_y_q       <= position_y;
        player_hide_q      <= player_hide;
        player_direction_q <= player_direction;
        enemy_valid_q      <= enemy_valid;
        enemy_x_q          <= enemy_x;
        enemy_y_q          <= enemy_y;
        enemy_dir_q        <= enemy_dir;
        enemy_type_q       <= enemy_type;
        bullet_valid_q     <= bullet_valid;
        bullet_x_q         <= bullet_x;
        bullet_y_q         <= bullet_y;
        bullet_dir_q       <= bullet_dir;
        bullet_owner_q     <= bullet_owner;
        fx_valid_q         <= fx_valid;
        fx_x_q             <= fx_x;
        fx_y_q             <= fx_y;
        fx_frame_q         <= fx_frame;
    end

    localparam [10:0] PLAY_W = 11'd600;

    // 计算当前像素属于哪个 5x5 的格子
    wire [7:0] tile_x = img_x / 5; 
    wire [6:0] tile_y = img_y / 5; // 这里还在用/5运算，还可以简化
    wire [2:0] local_x = img_x - (tile_x * 5);
    wire [2:0] local_y = img_y - (tile_y * 5);
    wire [14:0] tile_y_ext = {8'b0, tile_y};
    wire [14:0] row_base = (tile_y_ext << 7) - (tile_y_ext << 3);
    assign map_addr = (img_x < PLAY_W) ? (row_base + {8'b0, tile_x}) : 15'd0;

    wire [4:0] local_px = img_x % 20;
    wire [4:0] local_py = img_y % 20;
    wire [8:0] local_addr = (local_py << 4) + (local_py << 2) + local_px;
    wire [15:0] local_pixel;

    // 然而坦克的像素不是在格点上固定的，必须要根据现场坐标重绘，并根据朝向取点
    function [8:0] tank_addr;
        input [4:0] px;
        input [4:0] py;
        input [1:0] d;
        reg   [8:0] row;    // py * 20
        reg   [8:0] col;    // px * 20
        begin
            row = ({4'b0, py} << 4) + ({4'b0, py} << 2);
            col = ({4'b0, px} << 4) + ({4'b0, px} << 2);
            case (d)
                2'b00:   tank_addr = row + {4'b0, px};
                2'b01:   tank_addr = 9'd399 - row - {4'b0, px};
                2'b10:   tank_addr = col + {4'b0, py};
                default: tank_addr = 9'd380 - col + {4'b0, py};
            endcase
        end
    endfunction

    // 玩家坦克：20x20 包围盒命中，命中才产生贴图地址
    wire [10:0] pdx = img_x - position_x_q;
    wire [10:0] pdy = img_y - position_y_q;
    // 无敌闪烁
    wire        player_on   = (pdx < 11'd20) && (pdy < 11'd20) && !player_hide_q;
    wire [8:0]  player_addr = tank_addr(pdx[4:0], pdy[4:0], player_direction_q);

    // 敌人坦克
    wire [N_E-1:0]   ehit;
    wire [N_E*9-1:0] e_addr_all;
    genvar ge;
    generate
        for (ge = 0; ge < N_E; ge = ge + 1) begin : g_enemy_tank
            wire [9:0]  ex = enemy_x_q[ge*10 +: 10];
            wire [9:0]  ey = enemy_y_q[ge*10 +: 10];
            wire [1:0]  ed = enemy_dir_q[ge*2 +: 2];
            wire [10:0] edx = img_x - {1'b0, ex};
            wire [10:0] edy = img_y - {1'b0, ey};

            assign ehit[ge] = enemy_valid_q[ge] && (edx < 11'd20) && (edy < 11'd20);
            assign e_addr_all[ge*9 +: 9] = tank_addr(edx[4:0], edy[4:0], ed);
        end
    endgenerate

    // 同一个像素最多只落在 1 辆车上
    reg [8:0] tank_addr_mux;
    reg       tank_on;
    reg       tank_is_enemy;
    reg [1:0] tank_type_sel;    // 选中那辆敌人的兵种（玩家时无意义）
    integer   ti;
    always @(*) begin
        tank_addr_mux = 9'd0;
        tank_on       = 1'b0;
        tank_is_enemy = 1'b0;
        tank_type_sel = 2'd0;
        for (ti = 0; ti < N_E; ti = ti + 1)
            if (!tank_on && ehit[ti]) begin
                tank_addr_mux = e_addr_all[ti*9 +: 9];
                tank_on       = 1'b1;
                tank_is_enemy = 1'b1;
                tank_type_sel = enemy_type_q[ti*2 +: 2];
            end
        if (player_on) begin
            tank_addr_mux = player_addr;
            tank_on       = 1'b1;
            tank_is_enemy = 1'b0;
            tank_type_sel = 2'd0;
        end
    end

    wire [15:0] brick_pixel;
    wire [15:0] river_pixel;
    wire [15:0] steel_pixel;
    wire [15:0] woods_pixel;
    wire [15:0] tank_pixel_pl;   // 玩家（黄）
    wire [15:0] tank_pixel_fast; // 快速（蓝）
    wire [15:0] tank_pixel_power;// 火力（橙）
    wire [15:0] tank_pixel_armor;// 装甲（绿）
    
    blk_mem_brick brick_rom(
        .clka(vga_clk),
        .addra(local_addr),
        .douta(brick_pixel)
    );
    blk_mem_river river_rom(
        .clka(vga_clk),
        .addra(local_addr),
        .douta(river_pixel)
    );
    blk_mem_steel steel_rom(
        .clka(vga_clk),
        .addra(local_addr),
        .douta(steel_pixel)
    );
    blk_mem_woods woods_rom(
        .clka(vga_clk),
        .addra(local_addr),
        .douta(woods_pixel)
    );
    // 4 个 ROM 共用同一个地址（贴图的旋转规则一样），只是数据不同，复用减少资源
    wire        hud_on, hud_icon_on;
    wire [11:0] hud_rgb;
    wire [8:0]  hud_icon_addr;
    wire [1:0]  hud_icon_type;

    wire [8:0] tank_rom_addr = hud_icon_on ? hud_icon_addr : tank_addr_mux;

    blk_mem_player_tank tank_rom(
        .clka(vga_clk),
        .addra(tank_rom_addr),
        .douta(tank_pixel_pl)
    );
    blk_mem_tank_fast tank_fast_rom(
        .clka(vga_clk),
        .addra(tank_rom_addr),
        .douta(tank_pixel_fast)
    );
    blk_mem_tank_power tank_power_rom(
        .clka(vga_clk),
        .addra(tank_rom_addr),
        .douta(tank_pixel_power)
    );
    blk_mem_tank_armor tank_armor_rom(
        .clka(vga_clk),
        .addra(tank_rom_addr),
        .douta(tank_pixel_armor)
    );

    // 坦克爆炸图层
    wire [N_FX-1:0]   fx_hit;
    wire [N_FX*9-1:0] fx_addr_all;
    genvar gf;
    generate
        for (gf = 0; gf < N_FX; gf = gf + 1) begin : g_fx_layer
            wire [9:0]  fxx = fx_x_q[gf*10 +: 10];
            wire [9:0]  fxy = fx_y_q[gf*10 +: 10];
            wire [10:0] fdx = img_x - {1'b0, fxx};
            wire [10:0] fdy = img_y - {1'b0, fxy};

            assign fx_hit[gf] = fx_valid_q[gf] && (fdx < 11'd20) && (fdy < 11'd20);
            assign fx_addr_all[gf*9 +: 9] = ({4'b0, fdy[4:0]} << 4)
                                          + ({4'b0, fdy[4:0]} << 2)
                                          + {4'b0, fdx[4:0]};
        end
    endgenerate

    reg [8:0] fx_addr_mux;
    reg       fx_on;
    reg [1:0] fx_frame_sel;
    integer   fi;
    always @(*) begin
        fx_addr_mux  = 9'd0;
        fx_on        = 1'b0;
        fx_frame_sel = 2'd0;
        for (fi = 0; fi < N_FX; fi = fi + 1)
            if (!fx_on && fx_hit[fi]) begin
                fx_addr_mux  = fx_addr_all[fi*9 +: 9];
                fx_on        = 1'b1;
                fx_frame_sel = fx_frame_q[fi*2 +: 2];
            end
    end

    wire [15:0] boom_burst_pixel; 
    wire [15:0] boom_ring_pixel; 
    blk_mem_tank_destroyed1 boom_burst_rom(
        .clka(vga_clk),
        .addra(fx_addr_mux),
        .douta(boom_burst_pixel)
    );
    blk_mem_tank_destroyed2 boom_ring_rom(
        .clka(vga_clk),
        .addra(fx_addr_mux),
        .douta(boom_ring_pixel)
    );

    // 和 ROM 的 1 拍读延迟对齐（命中信号 / 帧号都要打一拍）
    reg       fx_on_d1;
    reg [1:0] fx_frame_sel_d1;
    always @(posedge vga_clk) begin
        fx_on_d1        <= fx_on;
        fx_frame_sel_d1 <= fx_frame_sel;
    end
    wire [15:0] fx_pixel = (fx_frame_sel_d1 == 2'd0) ? boom_burst_pixel
                                                     : boom_ring_pixel;

    // 基底图层
    localparam [10:0] HQ_X0 = 11'd290,
                      HQ_Y0 = 11'd580;

    wire [10:0] hq_dx = img_x - HQ_X0;   
    wire [10:0] hq_dy = img_y - HQ_Y0;
    wire        hq_on = (hq_dx < 11'd20) && (hq_dy < 11'd20);
    wire [8:0]  hq_addr = ({4'b0, hq_dy[4:0]} << 4) + ({4'b0, hq_dy[4:0]} << 2)
                        + {4'b0, hq_dx[4:0]};
    reg hq_destroyed_q;
    always @(posedge vga_clk) hq_destroyed_q <= hq_destroyed;

    wire [15:0] hq_pixel_live;
    wire [15:0] hq_pixel_dead;
    blk_mem_headquarters hq_rom(
        .clka(vga_clk),
        .addra(hq_addr),
        .douta(hq_pixel_live)
    );
    blk_mem_hq_destroyed hq_dead_rom(
        .clka(vga_clk),
        .addra(hq_addr),
        .douta(hq_pixel_dead)
    );
    wire [15:0] hq_pixel = hq_destroyed_q ? hq_pixel_dead : hq_pixel_live;

    reg hq_on_d1;           // 和 ROM 的 1 拍读延迟对齐
    always @(posedge vga_clk) begin
        hq_on_d1 <= hq_on;
    end

    // 炮弹图层
    wire [N_B-1:0]   bhit;
    wire [N_B*7-1:0] b_addr_all;
    genvar gb;
    generate
        for (gb = 0; gb < N_B; gb = gb + 1) begin : g_bullet
            wire [9:0] bx = bullet_x_q[gb*10 +: 10];
            wire [9:0] by = bullet_y_q[gb*10 +: 10];
            wire [1:0] bd = bullet_dir_q[gb*2 +: 2];
            wire [10:0] bdx = img_x - {1'b0, bx};
            wire [10:0] bdy = img_y - {1'b0, by};
            wire [3:0]  bpx = bdx[3:0];   
            wire [3:0]  bpy = bdy[3:0];
            wire [6:0]  row10 = ({3'b0, bpy} << 3) + ({3'b0, bpy} << 1); 
            wire [6:0]  col10 = ({3'b0, bpx} << 3) + ({3'b0, bpx} << 1); 

            assign bhit[gb] = bullet_valid_q[gb] && (bdx < 11'd10) && (bdy < 11'd10);
            assign b_addr_all[gb*7 +: 7] = (bd == 2'b00) ? (row10 + {3'b0, bpx}) :
                                           (bd == 2'b01) ? (7'd99 - row10 - {3'b0, bpx}) :
                                           (bd == 2'b10) ? (col10 + 7'd9 - {3'b0, bpy}) :
                                                           (7'd90 - col10 + {3'b0, bpy});
        end
    endgenerate

    reg [6:0] bullet_addr;
    reg       bullet_on;
    reg       bullet_is_enemy;   
    integer bi;
    always @(*) begin
        bullet_addr     = 7'd0;
        bullet_on       = 1'b0;
        bullet_is_enemy = 1'b0;
        for (bi = 0; bi < N_B; bi = bi + 1)
            if (bhit[bi] && !bullet_on) begin
                bullet_addr     = b_addr_all[bi*7 +: 7];
                bullet_on       = 1'b1;
                bullet_is_enemy = bullet_owner_q[bi];
            end
    end

    wire [15:0] bullet_pixel;
    blk_mem_bullet bullet_rom(
        .clka(vga_clk),
        .addra(bullet_addr),
        .douta(bullet_pixel)
    );
    reg bullet_on_d1;       // 和 ROM 的 1 拍读延迟对齐
    reg bullet_is_enemy_d1;
    always @(posedge vga_clk) begin
        bullet_on_d1       <= bullet_on;
        bullet_is_enemy_d1 <= bullet_is_enemy;
    end

    reg [3:0] hud_score100_q;
    reg [2:0] hud_lives_q, hud_level_q;
    reg [5:0] hud_enemy_left_q;
    reg       hud_game_over_q, hud_victory_q;
    always @(posedge vga_clk) begin
        hud_score100_q   <= hud_score100;
        hud_lives_q      <= hud_lives;
        hud_level_q      <= hud_level;
        hud_enemy_left_q <= hud_enemy_left;
        hud_game_over_q  <= hud_game_over;
        hud_victory_q    <= hud_victory;
    end

    hud #(.N_E(N_E)) u_hud (
        .clock(vga_clk), .reset(reset),
        .x(img_x_d1), .y(img_y_d1),
        .score100(hud_score100_q), .lives(hud_lives_q), .level(hud_level_q),
        .enemy_left(hud_enemy_left_q),
        .enemy_valid(enemy_valid_q), .enemy_type(enemy_type_q),
        .game_over(hud_game_over_q), .victory(hud_victory_q),
        .hud_on(hud_on), .rgb(hud_rgb),
        .icon_on(hud_icon_on), .icon_addr(hud_icon_addr), .icon_type(hud_icon_type)
    );

    reg        hud_icon_on_d1;
    reg [1:0]  hud_icon_type_d1;
    always @(posedge vga_clk) begin
        hud_icon_on_d1   <= hud_icon_on;
        hud_icon_type_d1 <= hud_icon_type;
    end
    wire [15:0] hud_icon_pixel = (hud_icon_type_d1 == 2'd0) ? tank_pixel_fast :
                                 (hud_icon_type_d1 == 2'd1) ? tank_pixel_power :
                                                              tank_pixel_armor;


    // 生成背景颜色
    reg [11:0] bg_color;
    always @(*) begin
        case(tile_id)
            4'd0: bg_color = 12'h000; 
            4'd1: bg_color = brick_pixel[11:0];
            4'd2: bg_color = steel_pixel[11:0];
            4'd3: bg_color = river_pixel[11:0];
            4'd4: bg_color = woods_pixel[11:0]; // 这里冗余了，可以放到下面再写
            4'd5: begin 
                if (hq_on_d1 && hq_pixel[15]) bg_color = hq_pixel[11:0];
                else                          bg_color = 12'h000;
            end
            default: bg_color = 12'h000;
        endcase
    end 

    // 叠加图层逻辑 (坦克与草地遮挡)
    reg tank_on_d1, tank_is_enemy_d1;
    reg [1:0] tank_type_sel_d1;
    always @(posedge vga_clk) begin
        tank_on_d1       <= tank_on;
        tank_is_enemy_d1 <= tank_is_enemy;
        tank_type_sel_d1 <= tank_type_sel;
    end

    wire [15:0] tank_pixel = tank_is_enemy_d1
        ? ((tank_type_sel_d1 == 2'd0) ? tank_pixel_fast  :
           (tank_type_sel_d1 == 2'd1) ? tank_pixel_power : tank_pixel_armor)
        : tank_pixel_pl;

    reg [11:0] final_color;
    always @(*) begin
        if (hud_on) begin
            // 侧栏：面板底色 / 文字，敌人图标用坦克 ROM 的像素盖在上面
            if (hud_icon_on_d1 && hud_icon_pixel[15]) final_color = hud_icon_pixel[11:0];
            else                                     final_color = hud_rgb;
        end else if (tile_id == 4'd4 && woods_pixel[15]) begin
            final_color = bg_color; 
        end else if (fx_on_d1 && fx_pixel[15]) begin
            final_color = fx_pixel[11:0];
        end else if (bullet_on_d1 && bullet_pixel[15]) begin
            final_color = bullet_is_enemy_d1
                        ? {bullet_pixel[11:8], bullet_pixel[7:5], 1'b0, bullet_pixel[3:0]}
                        : bullet_pixel[11:0];
        end else if (tank_on_d1 && tank_pixel[15]) begin
            final_color = tank_pixel[11:0];
        end else begin
            final_color = bg_color;
        end
    end

    // 提取同步信号打拍
    reg hsync_d1, vsync_d1;
    reg dat_act_d1;
    reg [11:0] final_color_d1;
    
    always @(posedge vga_clk) begin
        dat_act_d1   <= dat_act;
        final_color_d1 <= final_color;
        hsync_d1     <= hsync_raw;
        vsync_d1     <= vsync_raw;
    end
    
    // 最终输出，使用打拍后的信号
    assign disp_RGB = dat_act_d1 ? final_color_d1 : 12'h000;
    assign hsync = hsync_d1;
    assign vsync = vsync_d1;

endmodule

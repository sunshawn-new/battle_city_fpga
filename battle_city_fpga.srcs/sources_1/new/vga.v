`timescale 1ns / 1ps

module vga #(
    parameter N_B = 4,            // 炮弹对象池深度（和 bullet_ctrl 的 N_B 保持一致）
    parameter N_E = 3,            // 敌方坦克辆数（和 enemy_ctrl 的 N_E 保持一致）
    parameter N_FX = 4            // 爆炸槽数（和 fx_ctrl 的 N_FX 保持一致）
)(
    input clock,                  // 100MHz
    input reset,
    input [9:0] position_x,       // 修复位宽
    input [9:0] position_y,
    // 1 = 这一帧不画玩家坦克（复活无敌时的闪烁，见 top.v 的 player_blink）
    input       player_hide,
    input wire [3:0] tile_id,
    input wire [1:0] player_direction,
    // 炮弹图层：每个槽 10 位坐标 + 2 位朝向，扁平打包（避免 unpacked array 端口）
    input wire [N_B-1:0]    bullet_valid,
    input wire [N_B*10-1:0] bullet_x,
    input wire [N_B*10-1:0] bullet_y,
    input wire [N_B*2-1:0]  bullet_dir,
    // 敌方坦克图层：和炮弹一样扁平打包（第 i 辆占 x[i*10 +: 10] / dir[i*2 +: 2]）
    input wire [N_E-1:0]    enemy_valid,
    input wire [N_E*10-1:0] enemy_x,
    input wire [N_E*10-1:0] enemy_y,
    input wire [N_E*2-1:0]  enemy_dir,
    // 兵种：第 i 辆占 enemy_type[i*2 +: 2]（00 快速 / 01 火力 / 10 装甲）
    input wire [N_E*2-1:0]  enemy_type,
    // 炮弹归属：第 i 位 1 = 这发是敌人打的（画成偏品红，和玩家的白弹区分）
    input wire [N_B-1:0]    bullet_owner,
    // 爆炸图层：和炮弹/敌人一样扁平打包（第 i 个槽占 x[i*10 +: 10] / frame[i*2 +: 2]）
    input wire [N_FX-1:0]    fx_valid,
    input wire [N_FX*10-1:0] fx_x,
    input wire [N_FX*10-1:0] fx_y,
    input wire [N_FX*2-1:0]  fx_frame,   // 0 = 亮爆团，1 = 星形环
    // 基地状态：1 = 已被炮弹打爆（基地图层换成“白旗”贴图）
    input wire              hq_destroyed,
    // ---------------- HUD（右侧 200px 信息栏，见 hud.v）----------------
    input wire [3:0]        hud_score100,
    input wire [2:0]        hud_lives,
    input wire [2:0]        hud_level,
    input wire [5:0]        hud_enemy_left,  // 本关剩余敌人（HUD 显示 ENEMY nn）
    input wire              hud_game_over,
    input wire              hud_victory,
    output wire vga_clk,
    output [11:0] disp_RGB,
    output wire hsync,
    output wire vsync,
    output wire [14:0] map_addr
);
    // 组合逻辑里 assign 出来的中间信号，显式声明（原来靠隐式网线，综合有警告）
    wire dat_act, hsync_raw, vsync_raw;

    // 800x600 @ 60Hz 的参数（画面尺寸没变；左边 600px 是玩区，右边 200px 是 HUD）
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
    
    // 分频：100MHz -> 50MHz 像素时钟
    reg clk_50m_reg = 1'b0;
    always @(posedge clock) begin
        if(reset) clk_50m_reg <= 1'b0;
        else clk_50m_reg <= ~clk_50m_reg;
    end

    assign vga_clk = clk_50m_reg;

    // 行/场扫描 (基于 50MHz)
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

    // 坐标转换
    wire [10:0] img_x = hcount - H_DAT_BEGIN;   // 0..799
    wire [10:0] img_y = vcount - V_DAT_BEGIN;   // 0..599

    // ---- sys_clk -> vga_clk 单级同步（几何信号）----
    // 位置/朝向都在 sys 域更新（12.5~25Hz，准静态），vga 域只读。
    // 直接跨域使用的话，sys 域寄存器会经减法器/比较器一路打到坦克 ROM 的地址口，
    // 时序报告里 sys_clk_pin -> vga_clk 那条最紧的路径（route 占 75%）就是它。
    // 这里先打一拍：跨域只剩“FF -> FF”的走线，地址由 vga 域寄存器驱动。
    // 位置是准静态的，画面不会延迟（最多晚 1 个 vga_clk 看到新坐标，远小于 1 像素）。
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

    // 像素坐标也打一拍：HUD 是纯组合逻辑（字模在 LUT 里，没有 ROM 延迟），
    // 必须和 map/贴图 ROM 的 1 拍读延迟对齐，否则整块侧栏会左移 1 像素。
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

    // ---------------- 玩区：左边 600px 是地图，右边 200px 是 HUD ----------------
    // 地图 120x120 格 x 5px = 600x600，和 800x600 的扫描时序完全无关
    // （时序参数一个都没动，只是把 x >= 600 的像素让给侧栏）。
    localparam [10:0] PLAY_W = 11'd600;

    // 1. 计算当前像素属于哪个 5x5 的格子
    wire [7:0] tile_x = img_x / 5;  // 0~119（HUD 区算出 120~159，被下面的门控挡掉）
    wire [6:0] tile_y = img_y / 5;  // 0~119
    wire [2:0] local_x = img_x - (tile_x * 5);
    wire [2:0] local_y = img_y - (tile_y * 5);
    wire [14:0] tile_y_ext = {8'b0, tile_y};
    // 地图宽 120 格：row*120 = (row<<7) - (row<<3)（比原来的 *160 少一级加法）
    wire [14:0] row_base = (tile_y_ext << 7) - (tile_y_ext << 3);
    // HUD 区域不读地图：那边 tile_x 已经跑到 120..159（地图外），
    // 与其让它读到填充区，不如直接钉在 0 —— 反正侧栏会整片盖住。
    assign map_addr = (img_x < PLAY_W) ? (row_base + {8'b0, tile_x}) : 15'd0;

    // ---3. 查地形贴图---
    // 取模 20 得到在 20x20 地形贴图里的相对坐标
    wire [4:0] local_px = img_x % 20;
    wire [4:0] local_py = img_y % 20;
    wire [8:0] local_addr = (local_py << 4) + (local_py << 2) + local_px;
    wire [15:0] local_pixel;

    // 然而坦克的像素不是在格点上固定的，必须要根据现场坐标重绘，并根据朝向取点。
    // 玩家和敌人共用同一张贴图 ROM（地址做 mux），旋转规则完全一样，所以抽成函数：
    //   源图 20x20 朝上，地址 = py*20 + px
    //     上: 原图              addr =  py*20 + px
    //     下: 旋转 180°         addr = 399 - py*20 - px
    //     左: 逆时针 90°        addr =  px*20 + py
    //     右: 顺时针 90°        addr = 380 - px*20 + py
    // (*20 写成 (x<<4)+(x<<2)；5 位输入最大 19*20+19 = 399，9 位地址够)
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

    // 玩家坦克：20x20 包围盒命中，命中才产生贴图地址。
    // 用无符号相减 + “< 20” 判断越界：img_x < position_x 时会回绕成很大的数。
    wire [10:0] pdx = img_x - position_x_q;
    wire [10:0] pdy = img_y - position_y_q;
    // 无敌闪烁：player_hide 高的时候这一帧不画玩家（车身“亮/灭”闪）。
    wire        player_on   = (pdx < 11'd20) && (pdy < 11'd20) && !player_hide_q;
    wire [8:0]  player_addr = tank_addr(pdx[4:0], pdy[4:0], player_direction_q);

    // 敌人坦克：同样的把式，每辆各算一遍（3 辆车 = 3 组比较器/小加法，很便宜）
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

    // 同一个像素最多只落在 1 辆车上（还没有“坦克互斥”，重叠时按 玩家 > 编号小的敌人）。
    // 选中哪一辆，同时决定 ROM 地址、用玩家贴图还是兵种贴图（tank_is_enemy/tank_type_sel）。
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

    // 敌人坦克：不再“玩家贴图 + 换色”，而是每种兵种一张独立 ROM
    // （img/tank_fast|power|armor.png -> tank_*_16bit.coe）。
    // 换色的老做法（enemy_tint 三个常量）删掉了：它把敌人绑死在玩家坦克的
    // 调色板上，换一次玩家配色就得同步一次常量，而且三辆车全灰、看不出兵种。
    // 现在玩家 1 张 + 敌人 3 张，共 4 个 512x16 单口 ROM，地址都来自
    // tank_addr_mux（旋转规则完全一样），只在“出像素”这一层按兵种 mux 一次。

    wire [15:0] brick_pixel;
    wire [15:0] river_pixel;
    wire [15:0] steel_pixel;
    wire [15:0] woods_pixel;
    wire [15:0] tank_pixel_pl;   // 玩家（黄）
    wire [15:0] tank_pixel_fast; // 快速（淡青）
    wire [15:0] tank_pixel_power;// 火力（亮橙）
    wire [15:0] tank_pixel_armor;// 装甲（亮绿）
    
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
    // 4 个 ROM 共用同一个地址（贴图的旋转规则一样），只是数据不同。
    // 512x16 的单口 ROM 各占半个 BRAM36（4 个 = 2 个 BRAM36），比“把 4 张图
    // 拼成一张 2048 深的贴图表”省地址逻辑，也和现有 brick/river/... 的做法一致。
    //
    // HUD 的敌人图标复用这 4 张图：图标区域的像素不在玩区里（x >= 600），
    // 坦克图层不可能同时命中，所以直接把地址 mux 过去就行 —— 不用第 5 张图。
    // （HUD 的输出在这里先声明，实例在下面第 5 节之前；Verilog 的显式 net
    //   声明必须在使用之前，否则会被当成 1 位的隐式网线，9 位地址会被截断。）
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

    // ---------------- 爆炸图层（坦克被击毁的 2 帧动画，状态在 fx_ctrl.v）----------------
    // 贴图也是 20x20（400 项 / IP 512 深），但爆炸图案中心对称，不按朝向旋转，
    // 地址就是 row*20 + col（和坦克的 tank_addr 不同，省掉旋转的 case）。
    // 两张图共用同一个地址、只在“出像素”这一层按 fx_frame 选一次，
    // 和坦克 4 张 ROM 的做法一致。
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

    // 一个像素最多落在一个爆炸上（爆炸只有 20x20，槽之间可能重叠 -> 取编号小的）
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

    wire [15:0] boom_burst_pixel;   // 第 0 帧：亮黄白色的实心爆团
    wire [15:0] boom_ring_pixel;    // 第 1 帧：橙色的星形环
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

    // ---------------- 基地（HQ）图层 ----------------
    // map.coe 里的基地本体是 4x4 个格子（20x20 像素：x 290..309 / y 565..584），
    // 正好等于 headquarters.png 的精灵包围盒 —— tile_id == 5 的每一格都落在
    // 下面这个 hq_on 窗口里，鹰占不到的格子是砖（1），画面因此不会出现
    // “砖墙中间挖了个 40x30 黑坑、鹰孤零零坐在坑里”的观感。
    // 位置只影响画面，改地图时同步这两个常量即可（不参与任何碰撞/移动逻辑，
    // 基地占不占地由 terrain_probe 读 tile_id == 5 决定）。
    // 600x600 玩区之后基地整体左移 100px（原 390 -> 290）：
    // 地图里的基地方块是 格 58..61 x 113..116（块 14~15 x 28~29 里的一部分，
    // 同一个 'H' 块剩下的格子由 level_loader / map_generator 补成砖）。
    localparam [10:0] HQ_X0 = 11'd290,
                      HQ_Y0 = 11'd565;

    wire [10:0] hq_dx = img_x - HQ_X0;      // 无符号相减：越界会回绕成很大的数
    wire [10:0] hq_dy = img_y - HQ_Y0;
    wire        hq_on = (hq_dx < 11'd20) && (hq_dy < 11'd20);
    // py*20 + px = py<<4 + py<<2 + px
    wire [8:0]  hq_addr = ({4'b0, hq_dy[4:0]} << 4) + ({4'b0, hq_dy[4:0]} << 2)
                        + {4'b0, hq_dx[4:0]};

    // 两张基地贴图：完好（金鹰）和被打爆（白旗 + 断杆 + 碎石）。
    // hq_destroyed 由 top 锁存（上电 0，被炮弹打中后置 1，GAME OVER 后按 BTNC
    // 重开一局时随 sys_rst 清回 0 —— 所以 Eagle 会重新立起来），
    // 两张图用同一个地址，所以直接 mux 不会有一帧错位。
    // 它来自 sys 域，这里同样先打一拍再进 mux（准静态信号，晚 1 拍无影响）。
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

    // ---------------- 炮弹图层 ----------------
    // 每个槽独立做 10x10 的包围盒测试，命中才产生 ROM 地址；多个槽同时命中时
    // 取编号最小的那个（同屏两发重合成一像素的概率极低，视觉上无差别）。
    // 旋转规则（源图是朝上的）：
    //   上   : 原图                      addr =  py*10 + px
    //   下   : 旋转 180°                  addr = 99 - py*10 - px
    //   左   : 逆时针 90°（弹头朝左）      addr =  px*10 + 9 - py
    //   右   : 顺时针 90°（弹头朝右）      addr = 90 - px*10 + py
    // 注意这三个乘 10 都写成 (x<<3)+(x<<1)，7 位足够（最大 99）。
    wire [N_B-1:0]   bhit;
    wire [N_B*7-1:0] b_addr_all;
    genvar gb;
    generate
        for (gb = 0; gb < N_B; gb = gb + 1) begin : g_bullet
            wire [9:0] bx = bullet_x_q[gb*10 +: 10];
            wire [9:0] by = bullet_y_q[gb*10 +: 10];
            wire [1:0] bd = bullet_dir_q[gb*2 +: 2];
            // 无符号相减：img_x < bx 时会回绕成很大的数，天然被 <10 的判断排除
            wire [10:0] bdx = img_x - {1'b0, bx};
            wire [10:0] bdy = img_y - {1'b0, by};
            wire [3:0]  bpx = bdx[3:0];      // 命中时必然是 0..9
            wire [3:0]  bpy = bdy[3:0];
            wire [6:0]  row10 = ({3'b0, bpy} << 3) + ({3'b0, bpy} << 1);   // py*10
            wire [6:0]  col10 = ({3'b0, bpx} << 3) + ({3'b0, bpx} << 1);   // px*10

            assign bhit[gb] = bullet_valid_q[gb] && (bdx < 11'd10) && (bdy < 11'd10);
            assign b_addr_all[gb*7 +: 7] = (bd == 2'b00) ? (row10 + {3'b0, bpx}) :
                                           (bd == 2'b01) ? (7'd99 - row10 - {3'b0, bpx}) :
                                           (bd == 2'b10) ? (col10 + 7'd9 - {3'b0, bpy}) :
                                                           (7'd90 - col10 + {3'b0, bpy});
        end
    endgenerate

    reg [6:0] bullet_addr;
    reg       bullet_on;
    reg       bullet_is_enemy;      // 选中这发炮弹的归属（1 = 敌人打的）
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

    // ================================================================================
    //  HUD：右侧 x = 600..799 的信息栏（分数 / 关卡 / 敌人图标 / 生命 / 结算横幅）
    //
    //  坐标喂 img_x_d1/img_y_d1（延迟一拍）：和 map ROM / 贴图 ROM 的读延迟对齐，
    //  侧栏边界才正好落在 x = 600。颜色是纯组合的（字模在 LUT 里），不用再打拍。
    //  hud_on 直接参与下面 final_color 的优先级判断（最高），把玩区图层整片盖掉。
    // ================================================================================
    // HUD 的状态输入也要先打一拍（sys -> vga 的单级同步）。
    // 否则 game_over 会经“选行 -> 横幅 -> final_color”这条 13 级组合链直接
    // 打到 vga 域的寄存器上，变成跨时钟长路径（实测 WNS -0.825ns，12 个端点）。
    // 分数/生命/胜负都是准静态信号（几秒才变一次），晚一拍完全看不出来。
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

    // 图标的像素来自坦克 ROM（地址已在 tank_rom_addr 里 mux 过去），
    // 所以命中信号和兵种也要打一拍，和 douta 的 1 拍延迟对齐。
    reg        hud_icon_on_d1;
    reg [1:0]  hud_icon_type_d1;
    always @(posedge vga_clk) begin
        hud_icon_on_d1   <= hud_icon_on;
        hud_icon_type_d1 <= hud_icon_type;
    end
    wire [15:0] hud_icon_pixel = (hud_icon_type_d1 == 2'd0) ? tank_pixel_fast :
                                 (hud_icon_type_d1 == 2'd1) ? tank_pixel_power :
                                                              tank_pixel_armor;


    // 4. 根据 BRAM 返回的 tile_id 生成背景颜色
    reg [11:0] bg_color;
    always @(*) begin
        case(tile_id)
            4'd0: bg_color = 12'h000; // 空地：黑
            4'd1: bg_color = brick_pixel[11:0];
            4'd2: bg_color = steel_pixel[11:0];
            4'd3: bg_color = river_pixel[11:0];
            4'd4: bg_color = woods_pixel[11:0]; // 严格来说这里冗余了，不过可以避免锁存器？
            4'd5: begin                // 基地：金鹰；被打爆后换成白旗（同一个包围盒）
                // 贴图不透明的地方画鹰，透明的像素留黑（和空地一个颜色）
                if (hq_on_d1 && hq_pixel[15]) bg_color = hq_pixel[11:0];
                else                          bg_color = 12'h000;
            end
            default: bg_color = 12'h000;
        endcase
    end 

    // 5. 叠加图层逻辑 (坦克与草地遮挡)
    // 坦克的包围盒命中 / 贴图地址已经在上面算好了（tank_on / tank_addr_mux），
    // 这里把命中信号和“选中哪辆车/哪个兵种”一起打一拍，和 ROM 的 1 拍读延迟对齐。
    // 关键：兵种 mux 必须用打拍后的 tank_type_sel_d1 —— 这样它选中的是
    // 【上一拍地址】对应的那辆车的 ROM 数据（本拍才从 douta 出来），
    // 和 tank_on_d1 的时序正好一致，坦克边缘不会出现“邻居兵种”的杂色像素。
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
        // 图层优先级（高 -> 低）：HUD > 树林 > 爆炸 > 炮弹 > 坦克 > 地形背景
        // 三层贴图都要看最高位（alpha）：透明像素必须露出下面的图层，
        // 否则透明区会被当成黑色画上去，坦克就成了一块黑方块。
        if (hud_on) begin
            // 侧栏：面板底色 / 文字，敌人图标用坦克 ROM 的像素盖在上面
            if (hud_icon_on_d1 && hud_icon_pixel[15]) final_color = hud_icon_pixel[11:0];
            else                                     final_color = hud_rgb;
        end else if (tile_id == 4'd4 && woods_pixel[15]) begin
            final_color = bg_color; // 树林层级最高，覆盖坦克和炮弹，但取决于该方格是否透明
        end else if (fx_on_d1 && fx_pixel[15]) begin
            // 爆炸压在炮弹和坦克上面：被击毁的坦克这一帧已经消失，
            // 爆炸的火球正好盖住它原来的 20x20 位置和旁边的弹片
            final_color = fx_pixel[11:0];
        end else if (bullet_on_d1 && bullet_pixel[15]) begin
            // 敌人的炮弹把绿通道减半（白弹 -> 品红），一眼能和玩家的白弹分开
            final_color = bullet_is_enemy_d1
                        ? {bullet_pixel[11:8], bullet_pixel[7:5], 1'b0, bullet_pixel[3:0]}
                        : bullet_pixel[11:0];
        end else if (tank_on_d1 && tank_pixel[15]) begin
            // 坦克贴图的透明像素不遮背景；敌人兵种的颜色已经由各自的 ROM 决定
            final_color = tank_pixel[11:0];
        end else begin
            final_color = bg_color; // 普通背景
        end
    end

    // 1. 提取同步信号打拍
    reg hsync_d1, vsync_d1;
    reg dat_act_d1;
    reg [11:0] final_color_d1;
    
    always @(posedge vga_clk) begin
        dat_act_d1   <= dat_act;
        final_color_d1 <= final_color;
        hsync_d1     <= hsync_raw; // 假设你原来的 hsync 改为 hsync_raw
        vsync_d1     <= vsync_raw;
    end
    
    // 2. 最终输出，使用打拍后的信号
    assign disp_RGB = dat_act_d1 ? final_color_d1 : 12'h000;
    assign hsync = hsync_d1;
    assign vsync = vsync_d1;

endmodule

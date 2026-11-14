`timescale 1ns / 1ps

module vga #(
    parameter N_B = 4,            // 炮弹对象池深度（和 bullet_ctrl 的 N_B 保持一致）
    parameter N_E = 3             // 敌方坦克辆数（和 enemy_ctrl 的 N_E 保持一致）
)(
    input clock,                  // 100MHz
    input reset,
    input [9:0] position_x,       // 修复位宽
    input [9:0] position_y,
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
    output wire vga_clk,
    output [11:0] disp_RGB,
    output wire hsync,
    output wire vsync,
    output wire [14:0] map_addr
);
    // 组合逻辑里 assign 出来的中间信号，显式声明（原来靠隐式网线，综合有警告）
    wire dat_act, hsync_raw, vsync_raw;

    // 800x600 @ 60Hz 的参数
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

    // 1. 计算当前像素属于哪个 5x5 的格子
    wire [7:0] tile_x = img_x / 5;  // 0~159
    wire [6:0] tile_y = img_y / 5;  // 0~119
    wire [2:0] local_x = img_x - (tile_x * 5);
    wire [2:0] local_y = img_y - (tile_y * 5);
    wire [14:0] tile_y_ext = {8'b0, tile_y};
    assign map_addr = (tile_y_ext << 7) + (tile_y_ext << 5) + {7'b0, tile_x}; // tile_y * 160 + tile_x

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
    wire [10:0] pdx = img_x - position_x;
    wire [10:0] pdy = img_y - position_y;
    wire        player_on   = (pdx < 11'd20) && (pdy < 11'd20);
    wire [8:0]  player_addr = tank_addr(pdx[4:0], pdy[4:0], player_direction);

    // 敌人坦克：同样的把式，每辆各算一遍（3 辆车 = 3 组比较器/小加法，很便宜）
    wire [N_E-1:0]   ehit;
    wire [N_E*9-1:0] e_addr_all;
    genvar ge;
    generate
        for (ge = 0; ge < N_E; ge = ge + 1) begin : g_enemy_tank
            wire [9:0]  ex = enemy_x[ge*10 +: 10];
            wire [9:0]  ey = enemy_y[ge*10 +: 10];
            wire [1:0]  ed = enemy_dir[ge*2 +: 2];
            wire [10:0] edx = img_x - {1'b0, ex};
            wire [10:0] edy = img_y - {1'b0, ey};

            assign ehit[ge] = enemy_valid[ge] && (edx < 11'd20) && (edy < 11'd20);
            assign e_addr_all[ge*9 +: 9] = tank_addr(edx[4:0], edy[4:0], ed);
        end
    endgenerate

    // 同一个像素最多只落在 1 辆车上（还没有“坦克互斥”，重叠时按 玩家 > 编号小的敌人）。
    // 选中哪一辆，决定 ROM 地址，也决定这颗像素要不要染成灰色。
    reg [8:0] tank_addr_mux;
    reg       tank_on;
    reg       tank_is_enemy;
    integer   ti;
    always @(*) begin
        tank_addr_mux = 9'd0;
        tank_on       = 1'b0;
        tank_is_enemy = 1'b0;
        for (ti = 0; ti < N_E; ti = ti + 1)
            if (!tank_on && ehit[ti]) begin
                tank_addr_mux = e_addr_all[ti*9 +: 9];
                tank_on       = 1'b1;
                tank_is_enemy = 1'b1;
            end
        if (player_on) begin
            tank_addr_mux = player_addr;
            tank_on       = 1'b1;
            tank_is_enemy = 1'b0;
        end
    end

    // 敌人坦克 = 玩家贴图 + 换色（原版敌方坦克是灰的）。
    // tank.png 只有 3 种不透明色，coe 里的 12 位值就是下面这三个，
    // 所以三个比较器就够 —— 不必为敌人再单独做一个 ROM / IP。
    //   0xFD3 车体（黄）   0xA60 炮管/暗部（深黄）   0x310 描边（近黑）
    // >>> 以后改 tank.png 的配色，这三个常量必须跟着改，否则敌人又变回黄色。
    //     （查法：读 tank_16bit.coe 里的不透明值，取低 12 位。）
    function [11:0] enemy_tint;
        input [11:0] c;
        begin
            case (c)
                12'hFD3: enemy_tint = 12'hCCC;   // 车体 -> 浅灰
                12'hA60: enemy_tint = 12'h777;   // 炮管/暗部 -> 中灰
                12'h310: enemy_tint = 12'h310;   // 描边保持近黑
                default: enemy_tint = c;
            endcase
        end
    endfunction

    wire [15:0] brick_pixel;
    wire [15:0] river_pixel;
    wire [15:0] steel_pixel;
    wire [15:0] woods_pixel;
    wire [15:0] tank_pixel;      // 玩家和敌人共用这一张贴图（地址由 tank_addr_mux 选）
    
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
    blk_mem_player_tank tank_rom(
        .clka(vga_clk),
        .addra(tank_addr_mux),
        .douta(tank_pixel)
    );

    // ---------------- 基地（HQ）图层 ----------------
    // map.coe 里的基地是 8x6 个格子（40x30 像素：x 380..419 / y 560..589），
    // 而 headquarters.png 只有 20x20，所以把鹰居中画在这块区域中间：
    //   x 390..409，y 565..584
    // 位置只影响画面，改地图时同步这两个常量即可（不参与任何碰撞/移动逻辑，
    // 基地占不占地由 terrain_probe 读 tile_id == 5 决定）。
    localparam [10:0] HQ_X0 = 11'd390,
                      HQ_Y0 = 11'd565;

    wire [10:0] hq_dx = img_x - HQ_X0;      // 无符号相减：越界会回绕成很大的数
    wire [10:0] hq_dy = img_y - HQ_Y0;
    wire        hq_on = (hq_dx < 11'd20) && (hq_dy < 11'd20);
    // py*20 + px = py<<4 + py<<2 + px
    wire [8:0]  hq_addr = ({4'b0, hq_dy[4:0]} << 4) + ({4'b0, hq_dy[4:0]} << 2)
                        + {4'b0, hq_dx[4:0]};

    wire [15:0] hq_pixel;
    blk_mem_headquarters hq_rom(
        .clka(vga_clk),
        .addra(hq_addr),
        .douta(hq_pixel)
    );

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
            wire [9:0] bx = bullet_x[gb*10 +: 10];
            wire [9:0] by = bullet_y[gb*10 +: 10];
            wire [1:0] bd = bullet_dir[gb*2 +: 2];
            // 无符号相减：img_x < bx 时会回绕成很大的数，天然被 <10 的判断排除
            wire [10:0] bdx = img_x - {1'b0, bx};
            wire [10:0] bdy = img_y - {1'b0, by};
            wire [3:0]  bpx = bdx[3:0];      // 命中时必然是 0..9
            wire [3:0]  bpy = bdy[3:0];
            wire [6:0]  row10 = ({3'b0, bpy} << 3) + ({3'b0, bpy} << 1);   // py*10
            wire [6:0]  col10 = ({3'b0, bpx} << 3) + ({3'b0, bpx} << 1);   // px*10

            assign bhit[gb] = bullet_valid[gb] && (bdx < 11'd10) && (bdy < 11'd10);
            assign b_addr_all[gb*7 +: 7] = (bd == 2'b00) ? (row10 + {3'b0, bpx}) :
                                           (bd == 2'b01) ? (7'd99 - row10 - {3'b0, bpx}) :
                                           (bd == 2'b10) ? (col10 + 7'd9 - {3'b0, bpy}) :
                                                           (7'd90 - col10 + {3'b0, bpy});
        end
    endgenerate

    reg [6:0] bullet_addr;
    reg       bullet_on;
    integer bi;
    always @(*) begin
        bullet_addr = 7'd0;
        bullet_on   = 1'b0;
        for (bi = 0; bi < N_B; bi = bi + 1)
            if (bhit[bi] && !bullet_on) begin
                bullet_addr = b_addr_all[bi*7 +: 7];
                bullet_on   = 1'b1;
            end
    end

    wire [15:0] bullet_pixel;
    blk_mem_bullet bullet_rom(
        .clka(vga_clk),
        .addra(bullet_addr),
        .douta(bullet_pixel)
    );
    reg bullet_on_d1;       // 和 ROM 的 1 拍读延迟对齐
    always @(posedge vga_clk) begin
        bullet_on_d1 <= bullet_on;
    end


    // 4. 根据 BRAM 返回的 tile_id 生成背景颜色
    reg [11:0] bg_color;
    always @(*) begin
        case(tile_id)
            4'd0: bg_color = 12'h000; // 空地：黑
            4'd1: bg_color = brick_pixel[11:0];
            4'd2: bg_color = steel_pixel[11:0];
            4'd3: bg_color = river_pixel[11:0];
            4'd4: bg_color = woods_pixel[11:0]; // 严格来说这里冗余了，不过可以避免锁存器？
            4'd5: begin                // 基地：直接贴 headquarters.png 的鹰
                // 贴图不透明的地方画鹰，透明的像素留黑（和空地一个颜色）
                if (hq_on_d1 && hq_pixel[15]) bg_color = hq_pixel[11:0];
                else                          bg_color = 12'h000;
            end
            default: bg_color = 12'h000;
        endcase
    end 

    // 5. 叠加图层逻辑 (坦克与草地遮挡)
    // 坦克的包围盒命中 / 贴图地址已经在上面算好了（tank_on / tank_addr_mux），
    // 这里只要把命中信号打一拍，和 ROM 的 1 拍读延迟对齐。
    // tank_is_enemy 一起打拍：决定这颗像素用原色还是“敌人灰”。
    reg tank_on_d1, tank_is_enemy_d1;
    always @(posedge vga_clk) begin
        tank_on_d1       <= tank_on;
        tank_is_enemy_d1 <= tank_is_enemy;
    end

    reg [11:0] final_color;
    always @(*) begin
        // 图层优先级（高 -> 低）：树林 > 炮弹 > 坦克 > 地形背景
        // 三层贴图都要看最高位（alpha）：透明像素必须露出下面的图层，
        // 否则透明区会被当成黑色画上去，坦克就成了一块黑方块。
        if (tile_id == 4'd4 && woods_pixel[15]) begin
            final_color = bg_color; // 树林层级最高，覆盖坦克和炮弹，但取决于该方格是否透明
        end else if (bullet_on_d1 && bullet_pixel[15]) begin
            final_color = bullet_pixel[11:0]; // 炮弹贴图的透明像素不遮坦克
        end else if (tank_on_d1 && tank_pixel[15]) begin
            // 坦克贴图的透明像素不遮背景；敌人坦克染成灰色（一眼分得出谁是谁）
            final_color = tank_is_enemy_d1 ? enemy_tint(tank_pixel[11:0])
                                           : tank_pixel[11:0];
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

`timescale 1ns / 1ps

module vga(
    input clock,                  // 100MHz
    input reset,
    input [9:0] position_x,       // 修复位宽
    input [9:0] position_y,
    input wire [3:0] tile_id,
    input wire [1:0] player_direction,
    input wire [3:0] terrain_in_front,  // 前方地形查询结果（仅用于左上角调试色块）
    input wire       terrain_valid,     // 前方地形查询是否有效（仅用于调试色块）
    output wire vga_clk,
    output [11:0] disp_RGB,
    output wire hsync,
    output wire vsync,
    output wire [14:0] map_addr
);
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

    // 然而坦克的像素不是在格点上固定的，必须要根据现场坐标重绘，并根据朝向取点
    wire [4:0] player_px = img_x - position_x;
    wire [4:0] player_py = img_y - position_y;
    reg [8:0] player_addr;
    always @(*) begin
        case (player_direction)
            2'b00: player_addr = (player_py << 4) + (player_py << 2) + player_px;
            2'b01: player_addr = 399 - (player_py << 4) - (player_py << 2) - player_px;
            2'b10: player_addr = (player_px << 4) + (player_px << 2) + player_py;
            2'b11: player_addr = 380 - (player_px << 4) - (player_px << 2) + player_py;
        endcase
    end

    wire [15:0] brick_pixel;
    wire [15:0] river_pixel;
    wire [15:0] steel_pixel;
    wire [15:0] woods_pixel;
    wire [15:0] player_pixel;
    
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
    blk_mem_player_tank player_rom(
        .clka(vga_clk),
        .addra(player_addr),
        .douta(player_pixel)
    );

    // 4. 根据 BRAM 返回的 tile_id 生成背景颜色
    reg [11:0] bg_color;
    always @(*) begin
        case(tile_id)
            4'd0: bg_color = 12'h000; // 空地：黑
            4'd1: bg_color = brick_pixel[11:0];
            4'd2: bg_color = steel_pixel[11:0];
            4'd3: bg_color = river_pixel[11:0];
            4'd4: bg_color = woods_pixel[11:0]; // 严格来说这里冗余了，不过可以避免锁存器？
            4'd5: begin                // 基地：这里还需要继续设计，因为需要切换基地是否被摧毁
                if (local_x >= 1 && local_x <= 3 && local_y >= 1 && local_y <= 3)
                    bg_color = 12'hFFF;
                else
                    bg_color = 12'hFF0; 
            end
            default: bg_color = 12'h000;
        endcase
    end

    // ---------------- 左上角调试色块 ----------------
    // 把“前方地形查询”的状态直接画在画面上，方便不接逻辑分析仪也能看出问题：
    //   红 = 结果无效 / 正在扫描（这一拍坦克一定不动）
    //   绿 = 前方可通行（空地或树林）
    //   黄 = 前方被挡住（砖/钢/河流/基地）
    // 不想要就把它改成 1'b0。
    localparam DBG_OVERLAY = 1'b1;
    wire dbg_box = DBG_OVERLAY && (img_x >= 11'd4) && (img_x < 11'd16) &&
                                  (img_y >= 11'd4) && (img_y < 11'd16);

    reg [11:0] dbg_color;
    always @(*) begin
        if (!terrain_valid)
            dbg_color = 12'hF00;                                   // 红
        else if (terrain_in_front == 4'd0 || terrain_in_front == 4'd4)
            dbg_color = 12'h0F0;                                   // 绿
        else
            dbg_color = 12'hFF0;                                   // 黄
    end

    // 5. 叠加图层逻辑 (坦克与草地遮挡)
    // 需要增加根据坦克朝向绘制的逻辑
    wire tank_valid = (img_x >= position_x) && (img_x <= position_x + 19) &&
                      (img_y >= position_y) && (img_y <= position_y + 19);
    reg tank_valid_d1; // 因为读取bram有延迟，所以要打一拍
    always @(posedge vga_clk) begin
        tank_valid_d1 <= tank_valid;
    end

    reg [11:0] final_color;
    always @(*) begin
        if (dbg_box) begin
            final_color = dbg_color;   // 调试色块优先级最高
        end else if (tile_id == 4'd4 && woods_pixel[15]) begin
            final_color = bg_color; // 树林层级最高，覆盖坦克，但是取决于该方格是否透明
        end else if (tank_valid_d1) begin
            final_color = player_pixel[11:0];
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

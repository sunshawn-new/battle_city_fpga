set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[11]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[10]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[9]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[8]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[7]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {disp_RGB[0]}]
# ---------------- Pmod VGA 12 位色 ----------------
# 位序约定（重要，别写反）：
#   vga.v 输出 disp_RGB = {R[3:0], G[3:0], B[3:0]}
#     即 bit11..bit8 = 红 R3..R0（bit11 是红的最高位），bit0 = 蓝的最低位。
#   Pmod VGA 每组 4 根线的引脚顺序是“先 LSB 再 MSB”：
#     红 G19=R0(LSB) H19=R1 J19=R2 N19=R3(MSB)
#     绿 J17=G0      H17=G1 G17=G2 D17=G3
#     蓝 N18=B0      L18=B1 K18=B2 J18=B3
# 所以位号必须“从高到低”对上“MSB → LSB”的引脚（下面就是这样排的）：
#   disp_RGB[11..8] 红 R3 R2 R1 R0 -> N19 J19 H19 G19
#   disp_RGB[ 7..4] 绿 G3 G2 G1 G0 -> D17 G17 H17 J17
#   disp_RGB[ 3..0] 蓝 B3 B2 B1 B0 -> J18 K18 L18 N18
# 旧写法把 disp_RGB[11] 接在 G19(=R0) 上，等于每组 4 位整体倒序
# （12 位数据 0xE72 会变成 0x7E4），于是：
#   砖缝 0x8E72(232,120,32 橙)   -> 0x87E4(112,224,64 荧光黄绿)  ← 上一版的“黄绿屏”
#   金鹰 0x8FE4(240,224,64 金黄) -> 0x8F72(240,112,32 橙)
# 纯红/纯白/纯蓝在这套调色板里对“4 位倒序”不敏感（0xF 反过来还是 0xF），
# 所以这个 bug 藏了很久，直到砖/树/坦克换成非对称配色才现形。
# 详见 sim/README.md 的“第三轮：整屏发毒气黄绿”一节。
# 注意：set_property 后面不能跟 “# 行尾注释”——Tcl 只认行首（或分号后）的 #，
#       否则 # 会被当成多余参数，综合时刷 "Invalid option value '#' specified
#       for 'objects'"，而且该条引脚约束会被整条丢弃（引脚全变未约束！）。
set_property PACKAGE_PIN N19 [get_ports {disp_RGB[11]}]
set_property PACKAGE_PIN J19 [get_ports {disp_RGB[10]}]
set_property PACKAGE_PIN H19 [get_ports {disp_RGB[9]}]
set_property PACKAGE_PIN G19 [get_ports {disp_RGB[8]}]
set_property PACKAGE_PIN D17 [get_ports {disp_RGB[7]}]
set_property PACKAGE_PIN G17 [get_ports {disp_RGB[6]}]
set_property PACKAGE_PIN H17 [get_ports {disp_RGB[5]}]
set_property PACKAGE_PIN J17 [get_ports {disp_RGB[4]}]
set_property PACKAGE_PIN J18 [get_ports {disp_RGB[3]}]
set_property PACKAGE_PIN K18 [get_ports {disp_RGB[2]}]
set_property PACKAGE_PIN L18 [get_ports {disp_RGB[1]}]
set_property PACKAGE_PIN N18 [get_ports {disp_RGB[0]}]
set_property PACKAGE_PIN U17 [get_ports btn_down]
set_property PACKAGE_PIN W19 [get_ports btn_left]
set_property PACKAGE_PIN T17 [get_ports btn_right]
set_property PACKAGE_PIN T18 [get_ports btn_up]
set_property PACKAGE_PIN W5 [get_ports clock]
set_property PACKAGE_PIN R2 [get_ports reset]
set_property PACKAGE_PIN P19 [get_ports hsync]
set_property PACKAGE_PIN R19 [get_ports vsync]
set_property IOSTANDARD LVCMOS33 [get_ports btn_down]
set_property IOSTANDARD LVCMOS33 [get_ports btn_left]
set_property IOSTANDARD LVCMOS33 [get_ports btn_right]
set_property IOSTANDARD LVCMOS33 [get_ports btn_up]
set_property IOSTANDARD LVCMOS33 [get_ports clock]
set_property IOSTANDARD LVCMOS33 [get_ports hsync]
set_property IOSTANDARD LVCMOS33 [get_ports reset]
set_property IOSTANDARD LVCMOS33 [get_ports vsync]

# ============================================================================
# 时序约束
# ----------------------------------------------------------------------------
# 这两个约束原来缺失，导致整份设计（126 个触发器）全部处于“无时钟”状态：
#   check_timing 曾经报 no_clock(144) / unconstrained_internal_endpoints(474)
# 没有时钟约束 ⇒ Vivado 完全不做时序分析，也不为时序做任何优化/布线努力，
# 前方地形查询那种“除法 + 比较 + 16 位加法 → BRAM 地址”的长组合路径就可能
# 在 100MHz 下跑不动，抓到错的地图格子（表现为四方向全被“空气墙”挡住）。
# ============================================================================

# 板上 100MHz 晶振（W5）
create_clock -period 10.000 -name sys_clk_pin [get_ports clock]

# VGA 像素时钟：clk_50m_reg 是 100MHz 二分频得到，属于同步派生时钟。
# 注意 1：不能写 [get_pins u_vga/clk_50m_reg/Q] —— 综合后这个寄存器会被改名成
#         clk_50m_reg_reg，写死引脚名会约束失败。
# 注意 2：XDC 文件里不能用 if / foreach 之类的 Tcl 控制流（Vivado 会报
#         "Command 'if' is not supported in the xdc constraint file" 并跳过），
#         所以这里直接写约束命令，目标用 RTL 里稳定的网名 vga_clk。
create_generated_clock -name vga_clk -source [get_ports clock] \
                       -divide_by 2 [get_nets vga_clk]

# fire button (Basys3 center button btnC)
set_property PACKAGE_PIN U18 [get_ports btn_fire]
set_property IOSTANDARD LVCMOS33 [get_ports btn_fire]

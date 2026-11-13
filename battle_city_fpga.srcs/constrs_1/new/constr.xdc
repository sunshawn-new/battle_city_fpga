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
set_property PACKAGE_PIN G19 [get_ports {disp_RGB[11]}]
set_property PACKAGE_PIN H19 [get_ports {disp_RGB[10]}]
set_property PACKAGE_PIN J19 [get_ports {disp_RGB[9]}]
set_property PACKAGE_PIN N19 [get_ports {disp_RGB[8]}]
set_property PACKAGE_PIN J17 [get_ports {disp_RGB[7]}]
set_property PACKAGE_PIN H17 [get_ports {disp_RGB[6]}]
set_property PACKAGE_PIN G17 [get_ports {disp_RGB[5]}]
set_property PACKAGE_PIN D17 [get_ports {disp_RGB[4]}]
set_property PACKAGE_PIN N18 [get_ports {disp_RGB[3]}]
set_property PACKAGE_PIN L18 [get_ports {disp_RGB[2]}]
set_property PACKAGE_PIN K18 [get_ports {disp_RGB[1]}]
set_property PACKAGE_PIN J18 [get_ports {disp_RGB[0]}]
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

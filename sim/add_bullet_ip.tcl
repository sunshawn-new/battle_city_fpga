#-------------------------------------------------------------------------------
# add_bullet_ip.tcl
#
# 把炮弹相关的新文件并进工程：
#   1. terrain_probe.v / map_bus.v  -> sources_1
#   2. blk_mem_bullet IP            -> 512x16 单口 ROM，初值 bullet_16bit.coe
#      （10x10 = 100 个有效像素，VGA 只用低 128 个地址，占 1 个 BRAM36）
#
# 用法（在工程根目录）：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\add_bullet_ip.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"

open_project "$root/battle_city_fpga.xpr"

# ---------- 1. 新的 RTL 源文件 ----------
add_files -norecurse -fileset sources_1 [list \
    "$root/battle_city_fpga.srcs/sources_1/new/terrain_probe.v" \
    "$root/battle_city_fpga.srcs/sources_1/new/map_bus.v" ]

# ---------- 2. 炮弹贴图 ROM ----------
if {[llength [get_ips -quiet blk_mem_bullet]] == 0} {
    create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 \
              -module_name blk_mem_bullet -dir "$root/battle_city_fpga.srcs/sources_1/ip"
    set_property -dict [list \
        CONFIG.Memory_Type {Single_Port_ROM} \
        CONFIG.Write_Width_A {16} \
        CONFIG.Write_Depth_A {512} \
        CONFIG.Read_Width_A {16} \
        CONFIG.Operating_Mode_A {WRITE_FIRST} \
        CONFIG.Enable_A {Always_Enabled} \
        CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
        CONFIG.Load_Init_File {true} \
        CONFIG.Coe_File {../../../../bullet_16bit.coe} \
        CONFIG.Fill_Remaining_Memory_Locations {false} \
    ] [get_ips blk_mem_bullet]
}

generate_target all [get_ips blk_mem_bullet]

update_compile_order -fileset sources_1

puts "=== bullet ROM config ==="
puts "  Memory_Type   = [get_property CONFIG.Memory_Type          [get_ips blk_mem_bullet]]"
puts "  Write_Width_A = [get_property CONFIG.Write_Width_A        [get_ips blk_mem_bullet]]"
puts "  Write_Depth_A = [get_property CONFIG.Write_Depth_A        [get_ips blk_mem_bullet]]"
puts "  Coe_File      = [get_property CONFIG.Coe_File             [get_ips blk_mem_bullet]]"
puts "  generated     = [get_property IS_GENERATED                [get_ips blk_mem_bullet]]"

close_project
puts "=== project saved ==="

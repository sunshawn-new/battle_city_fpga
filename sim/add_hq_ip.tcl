#-------------------------------------------------------------------------------
# add_hq_ip.tcl
#
# 1. 新建基地贴图 ROM：blk_mem_headquarters（512x16 单口 ROM，初值
#    headquarters_16bit.coe；20x20 = 400 个有效像素，占 1 个 BRAM36）
# 2. 玩家坦克换了金色涂装，tank_16bit.coe 内容变了，强制重新生成
#    blk_mem_player_tank，避免综合还用旧的 .dcp
#
# 用法（在工程根目录，先跑 img/imgconverter.py 生成新的 coe）：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\add_hq_ip.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"

open_project "$root/battle_city_fpga.xpr"

# ---------- 1. 基地贴图 ROM ----------
set ipname "blk_mem_headquarters"
set xci    "$root/battle_city_fpga.srcs/sources_1/ip/$ipname/$ipname.xci"
if {[llength [get_ips -quiet $ipname]] == 0} {
    if {[file exists $xci]} {
        # 目录已经生成过（比如上次跑到一半中断），把 xci 直接挂进工程即可
        puts "=== $ipname.xci 已存在，直接 add_files ==="
        add_files -norecurse $xci
    } else {
        create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 \
                  -module_name $ipname -dir "$root/battle_city_fpga.srcs/sources_1/ip"
        set_property -dict [list \
            CONFIG.Memory_Type {Single_Port_ROM} \
            CONFIG.Write_Width_A {16} \
            CONFIG.Write_Depth_A {512} \
            CONFIG.Read_Width_A {16} \
            CONFIG.Operating_Mode_A {WRITE_FIRST} \
            CONFIG.Enable_A {Always_Enabled} \
            CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
            CONFIG.Load_Init_File {true} \
            CONFIG.Coe_File {../../../../headquarters_16bit.coe} \
            CONFIG.Fill_Remaining_Memory_Locations {false} \
        ] [get_ips $ipname]
    }
}

generate_target all [get_ips blk_mem_headquarters]

# ---------- 2. 坦克 ROM 重新读 coe（换了金色调色板）----------
if {[llength [get_ips -quiet blk_mem_player_tank]]} {
    reset_target all  [get_ips blk_mem_player_tank]
    generate_target all [get_ips blk_mem_player_tank]
}

update_compile_order -fileset sources_1

puts "=== HQ ROM config ==="
puts "  Memory_Type   = [get_property CONFIG.Memory_Type   [get_ips blk_mem_headquarters]]"
puts "  Write_Depth_A = [get_property CONFIG.Write_Depth_A [get_ips blk_mem_headquarters]]"
puts "  Coe_File      = [get_property CONFIG.Coe_File      [get_ips blk_mem_headquarters]]"
puts "  tank ROM (gold coe) = [get_property CONFIG.Coe_File [get_ips blk_mem_player_tank]]"
puts "  IPs in project = [get_ips]"

save_project
close_project
puts "=== project saved ==="

#-------------------------------------------------------------------------------
# add_tank_types_ip.tcl
#
# 把“兵种贴图 + 基地被打爆贴图”这 4 张图并进工程（都是 512x16 单口 ROM）：
#   blk_mem_tank_fast     <- tank_fast_16bit.coe
#   blk_mem_tank_power    <- tank_power_16bit.coe
#   blk_mem_tank_armor    <- tank_armor_16bit.coe
#   blk_mem_hq_destroyed  <- headquarters_destroyed_16bit.coe
#
# 这些 coe 都是 img/imgconverter.py 生成的（20x20 = 400 项）。VGA 侧把
# tank_addr_mux 同时接到 4 个坦克 ROM（玩家 + 3 个兵种），再用 enemy_type
# 选像素；基地则用 hq_destroyed 在“金鹰 / 白旗”两张 ROM 之间切。
#
# 用法（在工程根目录，先跑过 python img\sprites.py + python img\imgconverter.py）：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\add_tank_types_ip.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"

open_project "$root/battle_city_fpga.xpr"

# 单口 ROM 的公共配置；Coe_File 相对 IP 目录（sources_1/ip/<name>/）写 4 级 ..
proc ensure_rom {ipname coe} {
    global root
    if {[llength [get_ips -quiet $ipname]] == 0} {
        set xci "$root/battle_city_fpga.srcs/sources_1/ip/$ipname/$ipname.xci"
        if {[file exists $xci]} {
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
                CONFIG.Coe_File "../../../../$coe" \
                CONFIG.Fill_Remaining_Memory_Locations {false} \
            ] [get_ips $ipname]
        }
    }
    generate_target all [get_ips $ipname]
    puts "=== $ipname : Coe_File = [get_property CONFIG.Coe_File [get_ips $ipname]] ==="
}

ensure_rom blk_mem_tank_fast    tank_fast_16bit.coe
ensure_rom blk_mem_tank_power   tank_power_16bit.coe
ensure_rom blk_mem_tank_armor   tank_armor_16bit.coe
ensure_rom blk_mem_hq_destroyed headquarters_destroyed_16bit.coe

update_compile_order -fileset sources_1

puts "=== IPs in project ==="
foreach ip [get_ips] { puts "  - $ip" }

# 注：Vivado 在 close_project 时会自动把改动写回 .xpr（mtime 会更新），
# 不要再写 save_project —— 这个名字不是 Vivado 命令，会被 Tcl 前缀匹配成
# save_project_as，然后报 “Missing value for option 'name'”。
close_project
puts "=== project saved ==="

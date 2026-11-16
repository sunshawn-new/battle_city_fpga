#-------------------------------------------------------------------------------
# add_tank_block.tcl
#
# 把“坦克互斥”的新文件并进工程（只需跑一次，之后工程里就有它了）：
#   tank_block.v -> sources_1
#
# player.v（4 个方向）和 enemy_ctrl.v（每车 1 个）都例化它，
# 漏加这个文件的话打开工程会报 “module tank_block not found”，
# 综合直接失败 —— 仿真（sim/*.ps1）自己带文件列表，所以仿真全绿也不代表工程是全的。
#
# 用法（在工程根目录）：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\add_tank_block.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"

open_project "$root/battle_city_fpga.xpr"

# ---------- 新的 RTL 源文件 ----------
add_files -norecurse -fileset sources_1 [list \
    "$root/battle_city_fpga.srcs/sources_1/new/tank_block.v" ]

update_compile_order -fileset sources_1

puts "=== sources_1 top-level order ==="
foreach f [get_files -of_objects [get_filesets sources_1]] {
    puts "  $f"
}

close_project
puts "=== project saved ==="

#-------------------------------------------------------------------------------
# add_enemy_ctrl.tcl
#
# 把敌方坦克的新文件并进工程（只需跑一次，之后工程里就有它了）：
#   enemy_ctrl.v -> sources_1
#
# 敌方坦克的贴图没有新增 ROM/IP：直接复用 blk_mem_player_tank 的贴图，
# 在 vga.v 里用 3 个比较器把黄色换成灰色（tank.png 只有 3 种不透明色）。
#
# 用法（在工程根目录）：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\add_enemy_ctrl.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"

open_project "$root/battle_city_fpga.xpr"

# ---------- 新的 RTL 源文件 ----------
add_files -norecurse -fileset sources_1 [list \
    "$root/battle_city_fpga.srcs/sources_1/new/enemy_ctrl.v" ]

update_compile_order -fileset sources_1

puts "=== sources_1 top-level order ==="
foreach f [get_files -of_objects [get_filesets sources_1]] {
    puts "  $f"
}

close_project
puts "=== project saved ==="

# probe_ckpt.tcl - 只在批量模式里查名字，不改设计
set root "E:/college_studies/semester202609/battle_city_fpga"
open_checkpoint "$root/battle_city_fpga.runs/impl_1/top_routed.dcp"

puts "=== cells matching 50m ==="
foreach c [get_cells -hier -quiet -filter {NAME =~ *50m*}] {
    puts "CELL  $c  (ref = [get_property REF_NAME [get_cells $c]])"
}

puts "=== drivers of the vga_clk net ==="
foreach p [get_pins -quiet -of_objects [get_nets -quiet vga_clk] -filter {DIRECTION == OUT}] {
    puts "PIN   $p  (cell = [get_property REF_NAME [get_cells -quiet -of_objects $p]])"
}

puts "=== BUFG cells ==="
foreach b [get_cells -hier -quiet -filter {REF_NAME =~ BUFG*}] {
    set in [get_pins -quiet -of_objects [get_cells $b] -filter {DIRECTION == IN}]
    set onet [get_nets -quiet -of_objects $in]
    puts "BUFG  $b   input_net = $onet   driver = [get_pins -quiet -of_objects [get_nets -quiet $onet] -filter {DIRECTION == OUT}]"
}

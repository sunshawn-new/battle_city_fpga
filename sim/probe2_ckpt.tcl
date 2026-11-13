# probe2_ckpt.tcl - 验证 vga_clk 的约束写法（网表里 FF 被改名成 clk_50m_reg_reg，
# 所以要用“网名”而不是“寄存器引脚名”来定义派生时钟）
set root "E:/college_studies/semester202609/battle_city_fpga"
open_checkpoint "$root/battle_city_fpga.runs/impl_1/top_routed.dcp"

create_clock -period 10.000 -name sys_clk_pin [get_ports clock]

set vga_net [get_nets -quiet vga_clk]
puts "=== net vga_clk : $vga_net ==="
if {[llength $vga_net]} {
    create_generated_clock -name vga_clk -source [get_ports clock] -divide_by 2 $vga_net
    puts "=== RESULT: created generated clock on net vga_clk ==="
} else {
    puts "=== RESULT: net vga_clk NOT FOUND ==="
}

report_clocks -file "$root/sim/clocks_probe.txt"
report_timing_summary -max_paths 3 -file "$root/sim/clocks_probe.txt" -append
puts "=== DONE ==="

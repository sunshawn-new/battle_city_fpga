#-------------------------------------------------------------------------------
# build_all.tcl
#
# 用真正的工程流（synth_1 -> impl_1 -> write_bitstream）重新构建一遍，
# 顺便把时序/资源报告写到 sim/build_report.txt。
#
# 用法：
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace ^
#       -source sim\build_all.tcl
#-------------------------------------------------------------------------------
set root "E:/college_studies/semester202609/battle_city_fpga"
set out  "$root/sim/build_report.txt"

open_project "$root/battle_city_fpga.xpr"

reset_run synth_1
launch_runs synth_1 -jobs 8
wait_on_run synth_1
if {[get_property PROGRESS [get_runs synth_1]] ne "100%"} {
    error "synthesis FAILED - see $root/battle_city_fpga.runs/synth_1/runme.log"
}
puts "=== synthesis done ==="

reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs 8
wait_on_run impl_1
if {[get_property PROGRESS [get_runs impl_1]] ne "100%"} {
    error "implementation FAILED - see $root/battle_city_fpga.runs/impl_1/runme.log"
}
puts "=== implementation + bitstream done ==="

open_run impl_1

set fh [open $out w]
puts $fh "WNS = [get_property STATS.WNS [get_runs impl_1]] ns"
puts $fh "TNS = [get_property STATS.TNS [get_runs impl_1]] ns"
puts $fh "WHS = [get_property STATS.WHS [get_runs impl_1]] ns"
puts $fh "THS = [get_property STATS.THS [get_runs impl_1]] ns"
puts $fh "failing endpoints = [get_property STATS.FAILING_ENDPOINTS [get_runs impl_1]]"
close $fh
puts "WNS = [get_property STATS.WNS [get_runs impl_1]] ns"
puts "WHS = [get_property STATS.WHS [get_runs impl_1]] ns"
puts "failing endpoints = [get_property STATS.FAILING_ENDPOINTS [get_runs impl_1]]"

report_timing_summary -delay_type max -max_paths 10 -file $out -append
report_utilization -file $out -append

# 关键路径：地形查询/坦克状态机
set sc [get_cells -quiet -hier -filter {NAME =~ *snap_* || NAME =~ *scan_* || NAME =~ *g_tx_* || NAME =~ *g_front_*}]
if {[llength $sc]} {
    report_timing -from $sc -max_paths 5 -file $out -append
} else {
    puts "WARNING: no scan state cells found"
}

puts "REPORT WRITTEN TO $out"

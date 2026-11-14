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

# ---- 贴图颜色是 IP 的 .coe 决定的：先让所有 blk_mem_* 重新读一遍 coe ----
# 只改根目录的 *_16bit.coe 而不重新 generate_target，综合会用 IP 目录里的旧数据
# （上一版就因为这样，改完颜色上板还是老样子）。
foreach ip [get_ips -quiet] {
    if {[catch {
        reset_target all $ip
        generate_target all $ip
    } err]} {
        puts "WARNING: regenerate $ip failed: $err"
    } else {
        puts "=== regenerated IP: $ip ==="
    }
}

# reset_target 会把 IP 的“输出产物”从工程文件集里摘掉，generate_target 只把文件写回
# 磁盘；必须再 update_compile_order 才会重新进入综合的文件列表，
# 否则 synth 会报 "module 'blk_mem_xxx' not found"。
update_compile_order -fileset sources_1

# OOC（GENERATE_SYNTH_CHECKPOINT=1）的 IP 更麻烦：顶层综合用的是它综合出来的 .dcp，
# 那个 .dcp 的文件条目被 reset_target 删掉之后，综合阶段会直接报 module not found。
# 这里把它的 OOC 综合补跑一遍，并把 .dcp 重新挂回 sources_1。
foreach n {blk_mem_bullet blk_mem_headquarters} {
    if {[llength [get_ips -quiet $n]] == 0} { continue }
    set ipf [get_files -quiet "$root/battle_city_fpga.srcs/sources_1/ip/$n/$n.xci"]
    if {[llength $ipf] == 0} { continue }
    # 注意：GENERATE_SYNTH_CHECKPOINT 只能在 .xci 的 file 对象上问，问 IP 对象会告警
    if {![get_property GENERATE_SYNTH_CHECKPOINT [lindex $ipf 0]]} { continue }
    set rname "${n}_synth_1"
    if {[llength [get_runs -quiet $rname]]} {
        if {[get_property PROGRESS [get_runs $rname]] ne "100%"} {
            puts "=== re-launching OOC synthesis: $rname ==="
            reset_run $rname
            launch_runs $rname
            wait_on_run $rname
            if {[get_property PROGRESS [get_runs $rname]] ne "100%"} {
                error "OOC synthesis FAILED: $rname"
            }
        }
        set dcp "$root/battle_city_fpga.runs/$rname/$n.dcp"
        if {[file exists $dcp] && [llength [get_files -quiet $dcp]] == 0} {
            puts "=== re-attach $n.dcp to sources_1 ==="
            add_files -norecurse -fileset sources_1 $dcp
        }
    }
}
update_compile_order -fileset sources_1

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

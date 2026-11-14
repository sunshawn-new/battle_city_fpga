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

# ---- 新增的 RTL 源文件（HUD 相关）：工程里没有就加进去 ----
# 幂等：重复运行不会重复添加。hud.v / font5x7.v 是 600x600 + 侧栏那一版加的，
# 老工程文件（.xpr）里没有它们，综合会报 "module 'hud' not found"。
set src_dir "$root/battle_city_fpga.srcs/sources_1/new"
foreach f {hud.v font5x7.v fx_ctrl.v} {
    set p "$src_dir/$f"
    if {[llength [get_files -quiet $p]] == 0} {
        puts "=== add source: $f ==="
        add_files -norecurse -fileset sources_1 $p
    }
}
update_compile_order -fileset sources_1

# ---- 新增的贴图 ROM IP（爆炸动画两帧）：工程里没有就现场创建 ----
# 幂等：已经有同名 IP 就跳过。参数和 blk_mem_tank_* 完全一致
# （512x16 单口 ROM、1 拍读延迟、coe 指向工程根目录的 *_16bit.coe），
# 这样 vga.v 里两个实例的接口（clka/addra[8:0]/douta[15:0]）和坦克 ROM 一模一样。
foreach {ipn coef} [list blk_mem_tank_destroyed1 tank_destroyed1_16bit.coe \
                         blk_mem_tank_destroyed2 tank_destroyed2_16bit.coe] {
    if {[llength [get_ips -quiet $ipn]] != 0} {
        puts "=== IP exists: $ipn ==="
        continue
    }
    puts "=== create IP: $ipn ==="
    create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name $ipn
    set_property -dict [list \
        CONFIG.Memory_Type {Single_Port_ROM} \
        CONFIG.Write_Width_A {16} \
        CONFIG.Write_Depth_A {512} \
        CONFIG.Read_Width_A {16} \
        CONFIG.Write_Width_B {16} \
        CONFIG.Read_Width_B {16} \
        CONFIG.Operating_Mode_A {WRITE_FIRST} \
        CONFIG.Register_PortA_Output_of_Memory_Primitives {true} \
        CONFIG.Load_Init_File {true} \
        CONFIG.Coe_File "../../../../$coef" \
        CONFIG.Fill_Remaining_Memory_Locations {false} \
        CONFIG.Enable_A {Always_Enabled} \
        CONFIG.Enable_B {Always_Enabled} \
    ] [get_ips $ipn]
}
update_compile_order -fileset sources_1

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
#
# 【2026-11-14 的坑】只按 PROGRESS != 100% 判断是不够的：OOC run 只要跑过一次就
# 一直是 100%，重新 generate_target 出新的 .mif 也不会把它标脏。于是“改了
# headquarters_16bit.coe 但板上还是旧鹰”——顶层链接的是 11/13 那份旧 .dcp。
# 所以先按时间戳判新旧：IP 的 Coe_File 比它的 .dcp 新，就把这个 run 重置掉，
# 交给下面的循环重新综合。
foreach ip [get_ips -quiet] {
    set n [get_property NAME $ip]
    set stale_run "${n}_synth_1"
    if {[llength [get_runs -quiet $stale_run]] == 0} { continue }
    set stale_dcp "$root/battle_city_fpga.runs/$stale_run/$n.dcp"
    set coe_rel [get_property CONFIG.Coe_File $ip]
    if {$coe_rel eq ""} { continue }
    set coe_abs [file normalize "$root/battle_city_fpga.srcs/sources_1/ip/$n/$coe_rel"]
    if {![file exists $coe_abs]} {
        puts "WARNING: $n coe not found: $coe_abs"
        continue
    }
    if {![file exists $stale_dcp] || ([file mtime $coe_abs] > [file mtime $stale_dcp])} {
        puts "=== OOC stale: $stale_run (coe newer than dcp) -> reset_run ==="
        reset_run $stale_run
    }
}

foreach ip [get_ips -quiet] {
    set n [get_property NAME $ip]
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

# 最后再核一遍：任何 OOC IP 的 .dcp 比它的 Coe_File 旧，就说明贴图没进比特流，
# 直接让构建失败（这种错误在板子上只表现为“贴图没变”，极难发现）。
set stale_errs 0
foreach ip [get_ips -quiet] {
    set n [get_property NAME $ip]
    set chk_run "${n}_synth_1"
    if {[llength [get_runs -quiet $chk_run]] == 0} { continue }
    set chk_dcp "$root/battle_city_fpga.runs/$chk_run/$n.dcp"
    set coe_rel [get_property CONFIG.Coe_File $ip]
    if {$coe_rel eq ""} { continue }
    set coe_abs [file normalize "$root/battle_city_fpga.srcs/sources_1/ip/$n/$coe_rel"]
    if {![file exists $chk_dcp] || ([file mtime $coe_abs] > [file mtime $chk_dcp])} {
        puts "ERROR: $n 的 .dcp 比 coe 旧，贴图不会进比特流"
        incr stale_errs
    } else {
        puts "=== OOC fresh: $n ==="
    }
}
if {$stale_errs > 0} {
    error "$stale_errs 个 OOC IP 的 .dcp 仍是旧的（见上面 ERROR）"
}

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

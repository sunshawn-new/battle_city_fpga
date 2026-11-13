#-------------------------------------------------------------------------------
# report_timing.tcl
#
# Step 0 of the terrain-collision bug hunt: take the ALREADY routed design
# (the exact bitstream that is currently on the board), add the clock
# constraints that constr.xdc is missing, and ask Vivado what the real
# worst-case timing is.
#
# Nothing is re-synthesized / re-implemented, so this cannot change the
# bitstream - it only answers the question "was the design that is running on
# the board timings-clean or not?".
#
# Run with:
#   C:\Vivado\2021.1\bin\vivado.bat -mode batch -nojournal -nolog -notrace \
#       -source sim\report_timing.tcl
#-------------------------------------------------------------------------------

set root "E:/college_studies/semester202609/battle_city_fpga"
set out  "$root/sim/timing_report.txt"

open_checkpoint "$root/battle_city_fpga.runs/impl_1/top_routed.dcp"

# ---- the constraints that constr.xdc never had ------------------------------
create_clock -period 10.000 -name sys_clk_pin [get_ports clock]

set gc [get_pins -quiet u_vga/clk_50m_reg/Q]
if {[llength $gc]} {
    create_generated_clock -name vga_clk -source [get_ports clock] -divide_by 2 $gc
    puts "generated clock vga_clk created"
} else {
    puts "WARNING: u_vga/clk_50m_reg/Q not found - vga_clk has no definition"
}

# ---- the reports ------------------------------------------------------------
set ct [check_timing -return_string]
set fh [open $out w]
puts $fh $ct
close $fh
puts $ct

report_timing_summary -delay_type max -max_paths 10 -file $out -append

# worst paths that actually drive the terrain BRAM address
set rm [get_nets -quiet -hier *ram_addra*]
if {[llength $rm]} {
    report_timing -through $rm -max_paths 5 -file $out -append
} else {
    puts "WARNING: no net matching *ram_addra* found"
}

# worst paths that leave the player / scan state registers
set sc [get_cells -quiet -hier -filter {NAME =~ *snap_* || NAME =~ *scan_* || NAME =~ *g_tx_* || NAME =~ *g_front_*}]
if {[llength $sc]} {
    report_timing -from $sc -max_paths 5 -file $out -append
} else {
    puts "WARNING: no scan state cells found"
}

puts "REPORT WRITTEN TO $out"

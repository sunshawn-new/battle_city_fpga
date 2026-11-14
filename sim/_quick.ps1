# 临时：把 map.coe 转成 map_mem.hex 然后后台跑单个测试台（避免工具 30s 超时）
# 用法：Start-Process powershell -ArgumentList '-NoProfile','-File','sim\_quick.ps1','tb_terrain' -WindowStyle Hidden
param([string]$Tb = 'tb_terrain')

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

# ---- map.coe -> sim/map_mem.hex（和 run_sim.ps1 里的逻辑一致）----
$vals = New-Object System.Collections.Generic.List[string]
$inBody = $false
foreach ($line in (Get-Content -LiteralPath 'map.coe')) {
    if (-not $inBody) {
        if ($line -match 'memory_initialization_vector') { $inBody = $true }
        continue
    }
    foreach ($tok in ($line -split '[,\s;]+')) {
        if ($tok -ne '') { $vals.Add($tok) }
    }
}
if ($vals.Count -ne 19200) { throw "map.coe: expected 19200 entries, got $($vals.Count)" }
Set-Content -LiteralPath 'sim\map_mem.hex' -Value $vals -Encoding ASCII

Set-Location 'sim'
$src = Resolve-Path '..\battle_city_fpga.srcs\sources_1\new'
$design = @(
    (Join-Path $src 'top.v'),
    (Join-Path $src 'player.v'),
    (Join-Path $src 'enemy_ctrl.v'),
    (Join-Path $src 'vga.v'),
    (Join-Path $src 'terrain_probe.v'),
    (Join-Path $src 'map_bus.v'),
    (Join-Path $src 'bullet-ctrl.v')
)

Remove-Item -LiteralPath "$Tb.log" -ErrorAction SilentlyContinue
& xvlog @design 'bram_stubs.v' "$Tb.v" *> "$Tb.log"
& xelab '-debug' 'typical' $Tb '-s' "sim_$Tb" *>> "$Tb.log"
& xsim "sim_$Tb" '-R' *>> "$Tb.log"
'QUICKDONE' | Out-File -Append "$Tb.log"

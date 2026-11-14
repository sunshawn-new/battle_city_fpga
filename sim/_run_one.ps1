# 临时：后台跑单个测试台（避免工具 30s 超时）。用法：powershell -File sim\_run_one.ps1 tb_bullet
param([string]$Tb = 'tb_bullet')

$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

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
'DONE' | Out-File -Append "$Tb.log"

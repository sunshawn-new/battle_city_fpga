# 临时：把 map.coe / levels.coe 转成 sim 用的 hex，然后后台跑单个测试台
# （避免工具 30s 超时）
# 用法：Start-Process powershell -ArgumentList '-NoProfile','-File','sim\_quick.ps1','tb_terrain' -WindowStyle Hidden
param([string]$Tb = 'tb_terrain')

$ErrorActionPreference = 'Stop'
Set-Location (Split-Path $PSScriptRoot -Parent)

# ---- coe -> hex（和 run_sim.ps1 里的逻辑一致）----
function Convert-Coe([string]$Coe, [string]$Hex, [int]$Expect) {
    $vals = New-Object System.Collections.Generic.List[string]
    $inBody = $false
    foreach ($line in (Get-Content -LiteralPath $Coe)) {
        if (-not $inBody) {
            if ($line -match 'memory_initialization_vector') { $inBody = $true }
            continue
        }
        foreach ($tok in ($line -split '[,\s;]+')) {
            if ($tok -ne '') { $vals.Add($tok) }
        }
    }
    if ($vals.Count -ne $Expect) { throw "$Coe : expected $Expect entries, got $($vals.Count)" }
    Set-Content -LiteralPath $Hex -Value $vals -Encoding ASCII
}
Convert-Coe 'map.coe'    'sim\map_mem.hex'    19200
Convert-Coe 'levels.coe' 'sim\levels_mem.hex' 4096

Set-Location 'sim'
$src = Resolve-Path '..\battle_city_fpga.srcs\sources_1\new'
$design = @(
    (Join-Path $src 'top.v'),
    (Join-Path $src 'player.v'),
    (Join-Path $src 'enemy_ctrl.v'),
    (Join-Path $src 'vga.v'),
    (Join-Path $src 'hud.v'),
    (Join-Path $src 'font5x7.v'),
    (Join-Path $src 'terrain_probe.v'),
    (Join-Path $src 'tank_block.v'),
    (Join-Path $src 'map_bus.v'),
    (Join-Path $src 'bullet-ctrl.v'),
    (Join-Path $src 'fx_ctrl.v'),
    (Join-Path $src 'stage_ctrl.v'),
    (Join-Path $src 'level_loader.v')
)

Remove-Item -LiteralPath "$Tb.log" -ErrorAction SilentlyContinue
Remove-Item -LiteralPath "xsim.dir\sim_$Tb" -Recurse -Force -ErrorAction SilentlyContinue
& xvlog @design 'bram_stubs.v' "$Tb.v" *> "$Tb.log"
if ($LASTEXITCODE -ne 0) {
    # 编译失败必须停：xelab 会悄悄复用上一次的 xsim.dir 快照，
    # 于是“测试全过”其实跑的是旧代码（被这个坑坑过）。
    'XVLOG FAILED' | Out-File -Append "$Tb.log"
    exit 1
}
& xelab '-debug' 'typical' $Tb '-s' "sim_$Tb" *>> "$Tb.log"
if ($LASTEXITCODE -ne 0) {
    'XELAB FAILED' | Out-File -Append "$Tb.log"
    exit 1
}
& xsim "sim_$Tb" '-R' *>> "$Tb.log"
'QUICKDONE' | Out-File -Append "$Tb.log"


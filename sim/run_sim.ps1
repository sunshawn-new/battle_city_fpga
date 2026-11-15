# 用 xsim 运行全部仿真用例（在 PowerShell 里执行：.\run_sim.ps1）
#
# 做的事：
#   1. 把工程根目录的 map.coe / levels.coe 转成 map_mem.hex / levels_mem.hex
#      （bram_stubs.v 用 $readmemh 加载，仿真用的就是板上那两张表）
#   2. 用 BRAM_LATENCY = 0 / 1 / 2 / 3 编译并运行全部用例
#      —— 真实 IP 是 1 拍，但这里要把 0~3 拍全跑一遍，证明扫描逻辑与读延迟无关
#   3. 汇总每套用例的 [ OK ] / [FAIL] 数，任何一套没过就 exit 1
#
# 用例：
#   tb_terrain 地形碰撞（玩家移动 / 砖钢河树 / 基地顶盖 / 地图契约）
#   tb_bullet  炮弹（对象池 / 飞行 / 打砖 / 命中坦克 / 弹对弹 / 归属）
#   tb_enemy   敌人（AI / 兵种速度·血量·开火周期 / 冻结）
#   tb_combat  关卡流程（生命 / 无敌 / 分数 / GAME OVER / 爆炸时机）
#   tb_hud     侧栏（边界 / 底色 / 文字 / 数字 / 图标 / 横幅）
#   tb_fx      爆炸特效（槽池分配 / 相位 / 两帧 / 满池丢弃 / 复用）
#   tb_stage   关卡与波次（块图装载 / 补车节奏 / STAGE CLEAR / 换关循环）
param(
    [int[]]$Latency = @(0, 1, 2, 3)
)
$ErrorActionPreference = 'Stop'

# ---------- 找 Vivado 的 xvlog ----------
$xvlog  = (Get-Command xvlog.bat -ErrorAction SilentlyContinue)
$xelab  = (Get-Command xelab.bat -ErrorAction SilentlyContinue)
$xsim   = (Get-Command xsim.bat  -ErrorAction SilentlyContinue)
if (-not $xvlog) {
    $candidates = @()
    if ($env:XILINX_VIVADO) { $candidates += (Join-Path $env:XILINX_VIVADO 'bin') }
    $candidates += (Get-ChildItem 'C:\Xilinx\Vivado','C:\Vivado' -Directory -ErrorAction SilentlyContinue |
                    ForEach-Object { Join-Path $_.FullName 'bin' })
    foreach ($c in $candidates) {
        if (Test-Path (Join-Path $c 'xvlog.bat')) {
            $xvlog = Join-Path $c 'xvlog.bat'
            $xelab = Join-Path $c 'xelab.bat'
            $xsim  = Join-Path $c 'xsim.bat'
            break
        }
    }
}
if (-not $xvlog) { throw 'xvlog not found, please run this script in a Vivado environment' }

Push-Location $PSScriptRoot
try {
    # ---------- 1. coe -> hex（bram_stubs 用 $readmemh 加载）----------
    # 两个 .coe 都是“radix 16 + 一行一项”，转成一行一项的 hex 文本即可。
    function Convert-CoeToHex {
        param([string]$Coe, [string]$Hex, [int]$Expect)
        if (-not (Test-Path $Coe)) { throw "coe not found: $Coe" }
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
        if ($vals.Count -ne $Expect) {
            throw "$(Split-Path $Coe -Leaf): expected $Expect entries, got $($vals.Count)"
        }
        Set-Content -LiteralPath $Hex -Value $vals -Encoding ASCII
        Write-Host ("[{0}] -> {1} ({2} entries)" -f (Split-Path $Coe -Leaf),
                    (Split-Path $Hex -Leaf), $vals.Count) -ForegroundColor Cyan
    }

    $root = Split-Path $PSScriptRoot -Parent
    Convert-CoeToHex (Join-Path $root 'map.coe')    (Join-Path $PSScriptRoot 'map_mem.hex')    19200
    Convert-CoeToHex (Join-Path $root 'levels.coe') (Join-Path $PSScriptRoot 'levels_mem.hex') 4096

    # ---------- 2. 每种 BRAM 读延迟各跑一遍 ----------
    $src = Resolve-Path (Join-Path $PSScriptRoot '..\battle_city_fpga.srcs\sources_1\new')
    $design = @(
        (Join-Path $src 'top.v'),
        (Join-Path $src 'player.v'),
        (Join-Path $src 'enemy_ctrl.v'),
        (Join-Path $src 'vga.v'),
        (Join-Path $src 'hud.v'),
        (Join-Path $src 'font5x7.v'),
        (Join-Path $src 'terrain_probe.v'),
        (Join-Path $src 'map_bus.v'),
        (Join-Path $src 'bullet-ctrl.v'),
        (Join-Path $src 'fx_ctrl.v'),
        (Join-Path $src 'stage_ctrl.v'),
        (Join-Path $src 'level_loader.v')
    )
    # 每套用例：名字 / 顶层 / 最少应通过的断言数
    # （Min 只是“下限”，防止某个用例被整段跳过还显示 PASS；
    #   改了测试台就顺手把这里上调，别让它长期偏小）
    $tbs = @(
        [pscustomobject]@{ Name = 'tb_terrain'; File = 'tb_terrain.v'; Min = 24 },
        [pscustomobject]@{ Name = 'tb_bullet';  File = 'tb_bullet.v';  Min = 88 },
        [pscustomobject]@{ Name = 'tb_enemy';   File = 'tb_enemy.v';   Min = 38 },
        [pscustomobject]@{ Name = 'tb_combat';  File = 'tb_combat.v';  Min = 28 },
        [pscustomobject]@{ Name = 'tb_hud';     File = 'tb_hud.v';     Min = 36 },
        [pscustomobject]@{ Name = 'tb_fx';      File = 'tb_fx.v';      Min = 30 },
        [pscustomobject]@{ Name = 'tb_stage';   File = 'tb_stage.v';   Min = 40 }
    )
    $results = @()

    foreach ($lat in $Latency) {
        Write-Host "`n===== BRAM read latency = $lat =====" -ForegroundColor Cyan

        if (Test-Path (Join-Path $PSScriptRoot 'xsim.dir')) {
            Remove-Item -LiteralPath (Join-Path $PSScriptRoot 'xsim.dir') -Recurse -Force
        }

        $defArgs = @()
        if ($lat -ne 1) { $defArgs += @('-d', "BRAM_LATENCY_$lat") }

        $tbFiles = $tbs | ForEach-Object { $_.File }
        & $xvlog @defArgs @design 'bram_stubs.v' @tbFiles
        if ($LASTEXITCODE -ne 0) { throw "xvlog failed (latency $lat)" }

        foreach ($tb in $tbs) {
            $snap = "sim_$($tb.Name)"
            & $xelab '-debug' 'typical' $tb.Name '-s' $snap
            if ($LASTEXITCODE -ne 0) { throw "xelab failed for $($tb.Name) (latency $lat)" }

            $log = Join-Path $PSScriptRoot "$($tb.Name)_latency_$lat.log"
            & $xsim $snap '-R' 2>&1 | Tee-Object -FilePath $log
            if ($LASTEXITCODE -ne 0) { throw "xsim failed for $($tb.Name) (latency $lat)" }

            $text  = Get-Content -LiteralPath $log -Raw
            $okCnt = ([regex]::Matches($text, '\[ OK \]')).Count
            $ngCnt = ([regex]::Matches($text, '\[FAIL\]')).Count
            $passed = $text -match 'ALL TESTS PASSED'
            $results += [pscustomobject]@{
                Tb      = $tb.Name
                Latency = $lat
                Passed  = $okCnt
                Failed  = $ngCnt
                Result  = $(if ($passed) { 'PASS' } else { 'FAIL' })
                Min     = $tb.Min
            }
        }
    }

    Write-Host "`n============ summary ============" -ForegroundColor Cyan
    $results | Format-Table -AutoSize | Out-String | Write-Host

    $bad = 0
    foreach ($r in $results) { if ($r.Result -ne 'PASS' -or $r.Passed -lt $r.Min) { $bad++ } }
    if ($bad -gt 0) {
        Write-Host "$bad test run(s) FAILED" -ForegroundColor Red
        exit 1
    }
    Write-Host "ALL BRAM LATENCY CONFIGURATIONS PASSED" -ForegroundColor Green
}
finally {
    Pop-Location
}

# 用 xsim 运行地形碰撞测试（在 PowerShell 里执行：.\run_sim.ps1）
#
# 做的事：
#   1. 把工程根目录的 map.coe 转成 map_mem.hex（bram_stubs.v 用 $readmemh 加载）
#   2. 分别用 BRAM_LATENCY = 0 / 1 / 2 / 3 编译并运行 tb_terrain
#      —— 真实 IP 是 1 拍，但这里要把 0~3 拍全跑一遍，证明扫描逻辑与读延迟无关
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
    # ---------- 1. map.coe -> map_mem.hex ----------
    $coe = Join-Path (Split-Path $PSScriptRoot -Parent) 'map.coe'
    if (-not (Test-Path $coe)) { throw "map.coe not found: $coe" }

    $vals = New-Object System.Collections.Generic.List[string]
    $inBody = $false
    foreach ($line in (Get-Content -LiteralPath $coe)) {
        if (-not $inBody) {
            if ($line -match 'memory_initialization_vector') { $inBody = $true }
            continue
        }
        foreach ($tok in ($line -split '[,\s;]+')) {
            if ($tok -ne '') { $vals.Add($tok) }
        }
    }
    if ($vals.Count -ne 19200) {
        throw "map.coe: expected 19200 entries (160x120), got $($vals.Count)"
    }
    Set-Content -LiteralPath (Join-Path $PSScriptRoot 'map_mem.hex') -Value $vals -Encoding ASCII
    Write-Host ("[map] map.coe -> map_mem.hex ({0} entries)" -f $vals.Count) -ForegroundColor Cyan

    # ---------- 2. 每种 BRAM 读延迟各跑一遍 ----------
    $src = Resolve-Path (Join-Path $PSScriptRoot '..\battle_city_fpga.srcs\sources_1\new')
    $results = @()

    foreach ($lat in $Latency) {
        Write-Host "`n===== BRAM read latency = $lat =====" -ForegroundColor Cyan

        if (Test-Path (Join-Path $PSScriptRoot 'xsim.dir')) {
            Remove-Item -LiteralPath (Join-Path $PSScriptRoot 'xsim.dir') -Recurse -Force
        }

        $defArgs = @()
        if ($lat -ne 1) { $defArgs += @('-d', "BRAM_LATENCY_$lat") }

        & $xvlog @defArgs `
                 (Join-Path $src 'top.v') (Join-Path $src 'player.v') (Join-Path $src 'vga.v') `
                 'bram_stubs.v' 'tb_terrain.v'
        if ($LASTEXITCODE -ne 0) { throw "xvlog failed (latency $lat)" }

        & $xelab '-debug' 'typical' 'tb_terrain' '-s' 'tb_sim'
        if ($LASTEXITCODE -ne 0) { throw "xelab failed (latency $lat)" }

        $log = Join-Path $PSScriptRoot "sim_latency_$lat.log"
        & $xsim 'tb_sim' '-R' 2>&1 | Tee-Object -FilePath $log
        if ($LASTEXITCODE -ne 0) { throw "xsim failed (latency $lat)" }

        $text  = Get-Content -LiteralPath $log -Raw
        $okCnt = ([regex]::Matches($text, '\[ OK \]')).Count
        $ngCnt = ([regex]::Matches($text, '\[FAIL\]')).Count
        $passed = $text -match 'ALL TESTS PASSED'
        $results += [pscustomobject]@{ Latency = $lat; Passed = $okCnt; Failed = $ngCnt; Result = $(if ($passed) { 'PASS' } else { 'FAIL' }) }
    }

    Write-Host "`n============ summary ============" -ForegroundColor Cyan
    $results | Format-Table -AutoSize | Out-String | Write-Host

    $bad = 0
    foreach ($r in $results) { if ($r.Result -ne 'PASS' -or $r.Passed -lt 15) { $bad++ } }
    if ($bad -gt 0) {
        Write-Host "$bad latency configuration(s) FAILED" -ForegroundColor Red
        exit 1
    }
    Write-Host "ALL BRAM LATENCY CONFIGURATIONS PASSED" -ForegroundColor Green
}
finally {
    Pop-Location
}

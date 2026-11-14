# 临时：后台跑一次完整 synth+impl+bitstream（避免工具 30s 超时）。
# 用法：powershell -NoProfile -ExecutionPolicy Bypass -File sim\_run_build.ps1
# 结果：sim/build.log（Vivado 全部输出）、sim/build_report.txt（时序/资源摘要）
$ErrorActionPreference = 'Stop'
Set-Location $PSScriptRoot

Remove-Item -LiteralPath 'build.log' -ErrorAction SilentlyContinue
Remove-Item -LiteralPath 'build_report.txt' -ErrorAction SilentlyContinue

& 'C:\Vivado\2021.1\bin\vivado.bat' -mode batch -nojournal -nolog -notrace -source 'build_all.tcl' *> 'build.log'
'BUILD_EXIT ' + $LASTEXITCODE | Out-File -Append -Encoding utf8 'build.log'

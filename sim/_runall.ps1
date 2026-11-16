# 后台批量跑用例：逐个调 _quick.ps1，最后写 _all.done 结束标记
# 用法：Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','sim\_runall.ps1' -WindowStyle Hidden
param([string[]]$Only = @('tb_terrain','tb_bullet','tb_enemy','tb_combat','tb_hud','tb_fx','tb_stage'))
$ErrorActionPreference = 'Continue'
$here = $PSScriptRoot
Remove-Item -LiteralPath (Join-Path $here '_all.done') -ErrorAction SilentlyContinue
foreach ($t in $Only) {
    & (Join-Path $here '_quick.ps1') -Tb $t
}
'ALLDONE' | Out-File -Append (Join-Path $here '_all.done')

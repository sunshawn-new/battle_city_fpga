# 临时：按顺序跑一批测试台（后台启动，避免工具 30s 超时）
# 用法：Start-Process powershell -ArgumentList '-NoProfile','-ExecutionPolicy','Bypass','-File','sim\_quick_rest.ps1' -WindowStyle Hidden
param([string[]]$Tbs = @('tb_stage', 'tb_hud', 'tb_fx', 'tb_combat', 'tb_bullet'))

foreach ($tb in $Tbs) {
    & (Join-Path $PSScriptRoot '_quick.ps1') $tb
}
'ALLDONE' | Out-File -Append (Join-Path $PSScriptRoot '_quick_rest.log')

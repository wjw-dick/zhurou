# ============================================================
#  猪事大吉 · 一键停止
#  只结束「猪事大吉」自身的进程（命令行含 zhushi-admin.jar
#  或 zhushidaji.com），不影响同机其他项目。
# ============================================================

$ErrorActionPreference = 'Continue'

Write-Host '================================================================' -ForegroundColor DarkCyan
Write-Host '                    猪事大吉 · 一键停止' -ForegroundColor White
Write-Host '================================================================' -ForegroundColor DarkCyan
Write-Host ''
Write-Host '  正在结束本项目进程 ...'

$killed = 0

Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    $c = $_.CommandLine
    if ($c -and ($c -like '*zhushi-admin.jar*' -or $c -like '*zhushidaji.com*')) {
        Write-Host ("  结束后端 java  PID " + $_.ProcessId) -ForegroundColor DarkGray
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $script:killed++
    }
}

Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    $c = $_.CommandLine
    if ($c -and $c -like '*zhushidaji.com*') {
        Write-Host ("  结束前端 node  PID " + $_.ProcessId) -ForegroundColor DarkGray
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $script:killed++
    }
}

Write-Host ''
if ($killed -eq 0) {
    Write-Host '  没有发现正在运行的猪事大吉进程。' -ForegroundColor Yellow
} else {
    Write-Host ("  共结束 " + $killed + " 个进程。") -ForegroundColor Green
}
Write-Host '================================================================' -ForegroundColor DarkCyan

if (-not [Console]::IsInputRedirected) {
    Write-Host ''
    Read-Host '按回车键关闭此窗口'
}

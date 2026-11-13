# ============================================================
#  猪事大吉 · 一键启动
#  用法：
#    一键启动.cmd             启动「后端 + 后台管理」并打开浏览器
#    一键启动.cmd all         再额外启动「PC 官网(5174) + H5(5175)」
#    一键启动.cmd rebuild     强制重新构建后端
#    一键启动.cmd all rebuild
#
#  安全说明：只结束「猪事大吉」自身的进程
#            （命令行含 zhushi-admin.jar 或 zhushidaji.com），
#            不影响同一台机器上的其他项目。
# ============================================================

[CmdletBinding()]
param(
    [switch]$All,
    [switch]$Rebuild
)

$ErrorActionPreference = 'Continue'
$Root        = Split-Path -Parent $PSScriptRoot
$BackendPort = 8090
$Jar         = Join-Path $Root 'backend\zhushi-admin\target\zhushi-admin.jar'
$BackendDir  = Join-Path $Root 'backend'

function Say($text, $color = 'Gray') { Write-Host $text -ForegroundColor $color }

Say '================================================================' 'DarkCyan'
Say '                    猪事大吉 · 一键启动' 'White'
Say '================================================================' 'DarkCyan'
Say ("  项目目录 : " + $Root)
Say ("  后端端口 : " + $BackendPort)
if ($All) { Say '  启动内容 : 后端 + 后台管理 + PC官网 + H5' }
else      { Say '  启动内容 : 后端 + 后台管理' }
Say '----------------------------------------------------------------'

# ---------- 0. 环境检查 ----------
$hasJava = [bool](Get-Command java -ErrorAction SilentlyContinue)
$hasMvn  = [bool](Get-Command mvn  -ErrorAction SilentlyContinue)
$hasNode = [bool](Get-Command node -ErrorAction SilentlyContinue)

if (-not $hasJava) {
    Say '[错误] 未找到 java，请安装 JDK 17 并加入 PATH' 'Red'
    return
}
if (-not $hasMvn)  { Say '[提示] 未找到 mvn，将直接使用已有 jar' 'Yellow' }
if (-not $hasNode) { Say '[提示] 未找到 node，将跳过前端启动' 'Yellow' }

# ---------- 1. 清理本项目旧进程 ----------
Say ''
Say '[1/4] 清理猪事大吉旧进程 ...'
$killed = 0
Get-CimInstance Win32_Process -Filter "Name='java.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    $c = $_.CommandLine
    if ($c -and ($c -like '*zhushi-admin.jar*' -or $c -like '*zhushidaji.com*')) {
        Say ("       结束后端 PID " + $_.ProcessId) 'DarkGray'
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $script:killed++
    }
}
Get-CimInstance Win32_Process -Filter "Name='node.exe'" -ErrorAction SilentlyContinue | ForEach-Object {
    $c = $_.CommandLine
    if ($c -and $c -like '*zhushidaji.com*') {
        Say ("       结束前端 PID " + $_.ProcessId) 'DarkGray'
        Stop-Process -Id $_.ProcessId -Force -ErrorAction SilentlyContinue
        $script:killed++
    }
}
if ($killed -eq 0) {
    Say '       没有正在运行的旧进程' 'DarkGray'
} else {
    Start-Sleep -Seconds 2
}

# ---------- 2. 准备后端 jar ----------
Say ''
Say '[2/4] 准备后端 jar ...'
$needBuild = $Rebuild -or (-not (Test-Path $Jar))
if ($needBuild) {
    if (-not $hasMvn) {
        Say '[错误] 缺少后端 jar 且未安装 mvn，无法构建' 'Red'
        Say '       请安装 Maven 3.9+ 后重试'
        return
    }
    Say '       正在构建（mvn package -DskipTests），首次可能需要 1-2 分钟 ...' 'Yellow'
    Push-Location $BackendDir
    & mvn -q package -DskipTests
    $rc = $LASTEXITCODE
    Pop-Location
    if ($rc -ne 0) {
        Say '[错误] 后端构建失败，请检查上面的输出' 'Red'
        return
    }
    Say '       构建完成' 'Green'
} else {
    Say '       已存在 jar，跳过构建（强制重建：一键启动.cmd rebuild）' 'DarkGray'
}

# ---------- 3. 启动后端 ----------
Say ''
Say '[3/4] 启动后端 ...'
Start-Process -FilePath (Join-Path $PSScriptRoot 'run-backend.cmd') -WorkingDirectory $BackendDir

Say '       等待后端就绪 ...' 'DarkGray'
$ready = $false
$deadline = (Get-Date).AddSeconds(180)
while ((Get-Date) -lt $deadline) {
    Start-Sleep -Seconds 3
    try {
        $resp = Invoke-WebRequest -UseBasicParsing -TimeoutSec 3 "http://127.0.0.1:$BackendPort/api/public/config"
        if ($resp.Content -match 'site\.name') { $ready = $true; break }
    } catch { }
}
if ($ready) { Say ("       后端已就绪：http://127.0.0.1:" + $BackendPort + "/api") 'Green' }
else        { Say '       [警告] 后端未在预期时间内就绪，请查看「后端」窗口的日志' 'Yellow' }

# ---------- 4. 启动前端 ----------
Say ''
Say '[4/4] 启动前端 ...'
if ($hasNode) {
    $jobs = @( @{ dir = 'admin-web'; port = 5173; script = 'run-admin-web.cmd' } )
    if ($All) {
        $jobs += @{ dir = 'pc-web'; port = 5174; script = 'run-pc-web.cmd' }
        $jobs += @{ dir = 'h5-web'; port = 5175; script = 'run-h5-web.cmd' }
    }
    foreach ($job in $jobs) {
        Start-Process -FilePath (Join-Path $PSScriptRoot $job.script) -WorkingDirectory (Join-Path $Root $job.dir)
        Say ("       " + $job.dir + " : http://localhost:" + $job.port) 'DarkGray'
    }
} else {
    Say '       [跳过] 未找到 node，前端未启动' 'Yellow'
}

# ---------- 汇总 ----------
Say ''
Say '================================================================' 'DarkCyan'
Say '                        启动完成' 'Green'
Say '================================================================' 'DarkCyan'
Say ("  后端接口 : http://127.0.0.1:" + $BackendPort + "/api")
Say ("  接口文档 : http://127.0.0.1:" + $BackendPort + "/api/swagger-ui.html")
if ($hasNode) { Say '  后台管理 : http://localhost:5173' }
Say ''
Say '  默认账号 : admin / admin123   （超级管理员，拥有全部维护权限）' 'Yellow'
Say '  停止服务 : 双击「一键停止.cmd」' 'Yellow'
Say '================================================================'

if ($hasNode) {
    Start-Sleep -Seconds 3
    Start-Process 'http://localhost:5173' | Out-Null
}

if (-not [Console]::IsInputRedirected) {
    Say ''
    Read-Host '按回车键关闭此窗口（各服务在独立窗口中继续运行）'
}

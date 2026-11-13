@echo off
title ZhuShi-DaJi PC-Web
cd /d "%~dp0..\pc-web"

if not exist "node_modules" (
  echo [PC-Web] installing dependencies, please wait...
  call npm install --no-fund --no-audit
  if errorlevel 1 ( echo [PC-Web] npm install failed & pause & exit /b 1 )
)

echo [PC-Web] http://localhost:5174   (close this window to stop)
echo ------------------------------------------------------------
call npm run dev
pause >nul

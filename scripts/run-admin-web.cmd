@echo off
title ZhuShi-DaJi AdminWeb
cd /d "%~dp0..\admin-web"

if not exist "node_modules" (
  echo [AdminWeb] installing dependencies, please wait...
  call npm install --no-fund --no-audit
  if errorlevel 1 ( echo [AdminWeb] npm install failed & pause & exit /b 1 )
)

echo [AdminWeb] http://localhost:5173   (close this window to stop)
echo ------------------------------------------------------------
call npm run dev
pause >nul

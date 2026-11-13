@echo off
title ZhuShi-DaJi H5
cd /d "%~dp0..\h5-web"

if not exist "node_modules" (
  echo [H5] installing dependencies, please wait...
  call npm install --no-fund --no-audit
  if errorlevel 1 ( echo [H5] npm install failed & pause & exit /b 1 )
)

echo [H5] http://localhost:5175   (close this window to stop)
echo ------------------------------------------------------------
call npm run dev
pause >nul

@echo off
title ZhuShi-DaJi Backend
cd /d "%~dp0..\backend"
if not exist "logs" mkdir "logs" 2>nul

set "JAR=zhushi-admin\target\zhushi-admin.jar"
if not exist "%JAR%" (
  echo [Backend] jar not found: %JAR%
  echo [Backend] please run: mvn package -DskipTests
  pause
  exit /b 1
)

echo [Backend] starting... (port/data source: zhushi-admin\src\main\resources\application.yml)
echo [Backend] close this window to stop the service
echo ------------------------------------------------------------
java -Dfile.encoding=UTF-8 -jar "%JAR%"
echo ------------------------------------------------------------
echo [Backend] process exited. Press any key to close.
pause >nul

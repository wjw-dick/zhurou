@echo off
rem ZhuShi DaJi - one-click stop (entry; pure ASCII on purpose)
rem Logic: scripts\stop-all.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\stop-all.ps1" %*

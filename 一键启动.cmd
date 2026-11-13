@echo off
rem ZhuShi DaJi - one-click start (entry; pure ASCII on purpose)
rem Logic: scripts\start-all.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-all.ps1" %*

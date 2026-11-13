@echo off
rem ASCII alias: start-all.cmd [all] [rebuild]
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\start-all.ps1" %*

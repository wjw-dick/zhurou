@echo off
rem ASCII alias: stop-all.cmd
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\stop-all.ps1" %*

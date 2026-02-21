@echo off
cd /d "%~dp0"
powershell -ExecutionPolicy Bypass -File "%~dp0deploy-auto.ps1"
pause

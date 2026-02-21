@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo.
echo === Katana Auto - Upload to server ===
echo.
echo [1] Create ZIP (for panel upload)
echo [2] SCP upload (needs SSH)
echo [3] FTP upload (needs FTP)
echo [4] Exit
echo.
set /p choice="Choose 1-4: "

if "%choice%"=="1" goto zip
if "%choice%"=="2" goto scp
if "%choice%"=="3" goto ftp
if "%choice%"=="4" exit
goto end

:zip
echo Creating archive...
powershell -Command "Compress-Archive -Path 'index.html','styles.css','script.js','data.js','admin.html','images','README.md' -DestinationPath '..\katanaauto-website.zip' -Force"
echo Done: C:\Users\user\katanaauto-website.zip
echo Upload this file via hosting panel.
goto end

:scp
echo Starting SCP...
scp -r -o StrictHostKeyChecking=no "%cd%\*" root@95.81.124.28:/var/www/html/
goto end

:ftp
powershell -ExecutionPolicy Bypass -File "%~dp0deploy-ftp.ps1"
goto end

:end
echo.
pause

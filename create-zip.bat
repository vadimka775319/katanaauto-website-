@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo Создание архива...
powershell -Command "Compress-Archive -Path 'index.html','styles.css','script.js','data.js','admin.html','images','README.md' -DestinationPath '..\katanaauto-website.zip' -Force"
echo.
echo Готово! Архив: C:\Users\user\katanaauto-website.zip
echo Загрузите его через панель хостинга.
pause

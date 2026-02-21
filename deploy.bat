@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ========================================
echo   Загрузка сайта на katanaauto38.ru
echo ========================================
echo.
echo Сервер: root@95.81.124.28
echo Путь:   /var/www/html
echo.
echo Введите пароль root при запросе.
echo.

set PORT=22
if not "%1"=="" set PORT=%1

if %PORT%==22 (
    scp -r -o StrictHostKeyChecking=no -o ConnectTimeout=10 "%cd%\*" root@95.81.124.28:/var/www/html/
) else (
    scp -P %PORT% -r -o StrictHostKeyChecking=no -o ConnectTimeout=10 "%cd%\*" root@95.81.124.28:/var/www/html/
)

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Готово! Сайт загружен.
    echo https://katanaauto38.ru
) else (
    echo.
    echo Ошибка. Попробуйте другой порт: deploy.bat 2222
    echo Или загрузите через панель хостинга.
)

pause

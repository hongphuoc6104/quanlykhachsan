@echo off
cd /d "%~dp0"

echo ======================================================================
echo             KHOI DONG HE THONG STAYGO TREN WINDOWS
echo ======================================================================
echo.

:: Kiem tra neu chua cai dat dependencies
if not exist "backend\vendor" (
    echo [Thong bao] Phat hien he thong chua duoc thiet lap.
    echo Dang tu dong chay setup.bat de khoi tao du an...
    echo.
    call setup.bat
)

echo Dang khoi chay 3 dich vu StayGo:
echo   1. Backend Laravel 12 API (Port 8000)
echo   2. Realtime WebSocket Server (Port 3001)
echo   3. Frontend Vue 3 SPA (Port 3000)
echo.

start "StayGo - 1. Backend Server (8000)" cmd /k "cd /d %~dp0backend && php artisan serve"
start "StayGo - 2. Realtime Service (3001)" cmd /k "cd /d %~dp0realtime && npm start"
start "StayGo - 3. Frontend Web (3000)" cmd /k "cd /d %~dp0frontend && npm run dev"

echo Da khoi dong thanh cong tat ca dich vu!
echo Mo trinh duyet va truy cap: http://localhost:3000
echo.
pause

@echo off
cd /d "%~dp0"

echo ======================================================================
echo             DANG KHOI DONG HE THONG STAYGO TREN WINDOWS
echo ======================================================================
echo.
echo Dang mo 3 cua so dich vu:
echo   1. Backend Laravel 12 API (Port 8000)
echo   2. Realtime WebSocket Server (Port 3001)
echo   3. Frontend Vue 3 SPA (Port 3000)
echo.

start "StayGo - 1. Backend Server (8000)" cmd /k "cd /d %~dp0backend && php artisan serve"
start "StayGo - 2. Realtime Service (3001)" cmd /k "cd /d %~dp0realtime && npm start"
start "StayGo - 3. Frontend Web (3000)" cmd /k "cd /d %~dp0frontend && npm run dev"

echo Da khoi dong xong! 
echo Mo trinh duyet va truy cap: http://localhost:3000
echo.
pause

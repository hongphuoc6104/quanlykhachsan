@echo off
setlocal enabledelayedexpansion
cd /d "%~dp0"

echo ======================================================================
echo          KHOI TAO VA CAI DAT DU AN STAYGO TREN WINDOWS
echo ======================================================================
echo.

:: 1. Kiem tra PHP
where php >nul 2>&1
if errorlevel 1 (
    echo [Loi] Khong tim thay PHP trong he thong!
    echo Vui long cai dat PHP 8.2+ hoac them PHP vao bien moi truong PATH.
    pause
    exit /b 1
)

:: 2. Kiem tra Composer
where composer >nul 2>&1
if errorlevel 1 (
    echo [Loi] Khong tim thay Composer trong he thong!
    echo Vui long cai dat Composer tai: https://getcomposer.org/
    pause
    exit /b 1
)

:: 3. Kiem tra Node.js va npm
where node >nul 2>&1
if errorlevel 1 (
    echo [Loi] Khong tim thay Node.js trong he thong!
    echo Vui long cai dat Node.js (v20+) tai: https://nodejs.org/
    pause
    exit /b 1
)

echo [1/3] DANG THIET LAP BACKEND (Laravel 12)...
cd /d "%~dp0backend"
if not exist .env (
    echo   - Dang tao file .env tu .env.example...
    copy .env.example .env >nul
)

echo   - Dang cai dat dependencies PHP (Composer)...
call composer install --no-interaction --prefer-dist

echo   - Dang tao Application Key...
call php artisan key:generate --force

echo   - Dang tao lien ket luu tru Storage Link...
call php artisan storage:link >nul 2>&1

echo   - Dang chay CSDL Migration va Seeder du lieu mau...
call php artisan migrate --seed --force
if errorlevel 1 (
    echo [Canh bao] Chua migrate duoc CSDL. Hay dam bao MySQL/MongoDB dang chay va da tao database 'datphong'.
)

echo.
echo [2/3] DANG THIET LAP REALTIME SERVICE (Socket.IO)...
cd /d "%~dp0realtime"
echo   - Dang cai dat dependencies Node.js cho Realtime...
call npm install --no-audit --no-fund

echo.
echo [3/3] DANG THIET LAP FRONTEND (Vue 3)...
cd /d "%~dp0frontend"
if not exist .env (
    if exist .env.example (
        echo   - Dang tao file frontend/.env...
        copy .env.example .env >nul
    )
)
echo   - Dang cai dat dependencies Node.js cho Frontend...
call npm install --no-audit --no-fund

cd /d "%~dp0"
echo.
echo ======================================================================
echo               THIET LAP DU AN HOAN TAT THANH CONG!
echo ======================================================================
echo.
echo Ban co the khoi dong du an bang 1 trong 2 cach sau:
echo   - Cach 1: Nhap dup vao file "start.bat" de tu dong mo ca 3 dich vu.
echo   - Cach 2: Mo 3 cua so CMD rieng biet va chay:
echo       1) Backend:   cd backend  ^&^& php artisan serve
echo       2) Realtime:  cd realtime ^&^& npm start
echo       3) Frontend:  cd frontend ^&^& npm run dev
echo.
echo Truy cap giao dien tai: http://localhost:3000
echo.
pause

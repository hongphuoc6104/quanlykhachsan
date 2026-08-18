@echo off
setlocal
cd /d "%~dp0"

where docker >nul 2>&1
if errorlevel 1 (
    echo [Loi] Khong tim thay Docker trong he thong.
    echo Vui long cai dat Docker Desktop tai: https://www.docker.com/products/docker-desktop/
    pause
    exit /b 1
)

docker compose version >nul 2>&1
if errorlevel 1 (
    echo [Loi] Docker Compose khong san sang. Vui long cap nhat Docker Desktop.
    pause
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo [Loi] Docker Engine chua chay.
    echo Hay mo ung dung Docker Desktop tren Windows va cho bieu tuong o goc duoi chuyen sang mau XANH LA CAY (Running).
    pause
    exit /b 1
)

if not exist .env (
    echo [Khoi tao] Chua tim thay file .env, dang tu dong tao tu .env.example...
    copy .env.example .env >nul
)

echo [Bat dau] Dang khoi chay he thong StayGo bang Docker Compose...
docker compose up --build

if errorlevel 1 (
    echo [Thong bao] Tien trinh dung hoac co loi.
    pause
)

exit /b %errorlevel%

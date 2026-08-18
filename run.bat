@echo off
setlocal

where docker >nul 2>&1
if errorlevel 1 (
    echo Khong tim thay Docker. Hay cai dat va khoi dong Docker Desktop.
    exit /b 1
)

docker compose version >nul 2>&1
if errorlevel 1 (
    echo Docker Compose khong san sang. Hay cap nhat Docker Desktop.
    exit /b 1
)

docker info >nul 2>&1
if errorlevel 1 (
    echo [Loi] Docker Engine chua chay. Hay mo ung dung Docker Desktop va cho bieu tuong chuyen sang mau xanh la cay.
    pause
    exit /b 1
)

if not exist .env (
    echo [Khoi tao] Chua tim thay file .env, dang tu dong tao tu .env.example...
    copy .env.example .env >nul
)

echo [Bat dau] Dang khoi chay he thong StayGo qua Docker Compose...
docker compose up --build
exit /b %errorlevel%

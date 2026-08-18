# StayGo - Hệ thống Đặt phòng và Quản lý Khách sạn

> **GitHub Repository:** [https://github.com/hongphuoc6104/quanlykhachsan](https://github.com/hongphuoc6104/quanlykhachsan)  
> **Tài liệu hướng dẫn chi tiết:** Xem file [HUONG_DAN_DU_AN.md](HUONG_DAN_DU_AN.md) hoặc [huong_dan_cai_dat_windows.pdf](huong_dan_cai_dat_windows.pdf).

StayGo là hệ thống web đặt phòng và quản lý khách sạn hiện đại, áp dụng kiến trúc phân tách Client - Server (SPA + REST API + Realtime WebSocket + Polyglot Persistence MySQL/MongoDB/Redis).

---

## Hướng dẫn Cài đặt & Khởi chạy nhanh trên Windows (1-Click)

### 1. Yêu cầu chuẩn bị
- Cài đặt phần mềm **Docker Desktop** for Windows (Tải tại [docker.com/products/docker-desktop](https://www.docker.com/products/docker-desktop/)).
- Mở ứng dụng Docker Desktop và chờ biểu tượng cá voi ở góc dưới chuyển sang **màu xanh lá cây (Running)**.

### 2. Tải mã nguồn
Mở cửa sổ dòng lệnh (**Command Prompt** hoặc **PowerShell**) và chạy:
```bash
git clone https://github.com/hongphuoc6104/quanlykhachsan.git
cd quanlykhachsan
```

### 3. File chạy cài đặt và khởi động tất cả (`run.bat`)
Dự án đã có sẵn file script tự động hóa **`run.bat`** tại thư mục gốc. Bạn chỉ cần:
- **Nhấp đúp chuột (Double-click) vào file `run.bat`** (hoặc gõ `run.bat` trong cửa sổ dòng lệnh).

> 💡 **File `run.bat` sẽ tự động thực hiện từ A-Z:**
> 1. Kiểm tra trạng thái Docker Engine.
> 2. Tự động khởi tạo file cấu hình `.env` từ `.env.example` (nếu chưa có).
> 3. Tự động tải hình ảnh Docker, build backend PHP 8.2, frontend Vue 3, realtime Node.js.
> 4. Khởi tạo replica set MongoDB `rs0`, chạy migration CSDL và nạp sẵn toàn bộ dữ liệu mẫu (Seeder).

---

## Các cổng dịch vụ mặc định

| Thành phần | Địa chỉ truy cập | Ghi chú |
| --- | --- | --- |
| **Giao diện Web Khách hàng & Admin** | [http://localhost:3000](http://localhost:3000) | Giao diện Vue 3 SPA |
| **Backend REST API** | [http://localhost:8000/api/v1](http://localhost:8000/api/v1) | Laravel 12 API |
| **Kiểm tra Backend Health** | [http://localhost:8000/up](http://localhost:8000/up) | Trạng thái Laravel |
| **Kiểm tra Realtime WebSocket** | [http://localhost:3001/health](http://localhost:3001/health) | Socket.IO Health Check |
| **Cơ sở dữ liệu MySQL 8.0** | `localhost:3306` | User: `root`, DB: `datphong` |
| **Cơ sở dữ liệu MongoDB 8.0** | `localhost:27017` | Database: `datphong` (Replica Set `rs0`) |

Nếu cổng `27017` hoặc `3306` bị trùng với dịch vụ có sẵn trên máy (như XAMPP), chỉ cần mở file `.env` và đổi `MYSQL_HOST_PORT=3307` hoặc `MONGODB_HOST_PORT=27018`.

## Cấu hình

Các giá trị development mặc định nằm trong `docker-compose.yml`. Có thể tạo `.env` ở thư mục gốc dựa trên `.env.example` để ghi đè chúng. Frontend dùng:

```dotenv
VITE_API_BASE_URL=http://localhost:8000/api/v1
VITE_SOCKET_URL=http://localhost:3001
```

Đây là URL dành cho trình duyệt trên máy host, không đổi thành hostname service `backend`. Không dùng các mật khẩu development mẫu trong môi trường triển khai thật.

MongoDB lưu dữ liệu bền vững trong volume `datphong_v2_mongodb`; ảnh upload lưu trong `datphong_v2_public_storage`. Redis chỉ giữ cache, queue và outbox, không phải nguồn dữ liệu nghiệp vụ. Không lưu nội dung nhị phân trong MongoDB hoặc Redis.

Google/Facebook OAuth mặc định bị tắt. Provider chỉ được bật khi khai báo đủ `CLIENT_ID`, `CLIENT_SECRET` và `REDIRECT_URI` tương ứng trong `.env`; hệ thống không chứa credential mẫu.

## Dữ liệu động

Seeder không tạo dữ liệu nghiệp vụ cứng như khách sạn, khu vực, hạng phòng, phòng vật lý, dịch vụ hoặc voucher. Các dữ liệu này nằm trong MongoDB và được quản lý qua Admin/API; trang chủ, tìm kiếm, điểm đến, voucher và phòng đều đọc từ API. Nếu trước đó đã seed dữ liệu mẫu, dữ liệu vẫn nằm trong volume MongoDB và có thể sửa/xóa trực tiếp qua Admin/API mà không cần sửa source code.

Endpoint điểm đến lấy động từ khách sạn đang hoạt động:

```bash
GET http://localhost:8000/api/v1/destinations
```

Seeder chỉ có thể tạo tài khoản super admin ban đầu nếu khai báo biến môi trường, ví dụ:

```dotenv
SEED_ADMIN_EMAIL=admin@example.test
SEED_ADMIN_PASSWORD=change-me
SEED_ADMIN_NAME=System Admin
```

Không commit dữ liệu vận hành hoặc mật khẩu thật vào repository. Muốn nạp lại seeder tối thiểu khi hệ thống đang chạy, dùng `docker compose exec backend php artisan db:seed --force`.

### Tài khoản mặc định hệ thống

Sau khi cơ sở dữ liệu được khởi tạo, hệ thống sẽ có sẵn các tài khoản demo sau để kiểm nghiệm phân quyền (RBAC) với các mật khẩu tương ứng:

| Vai trò | Email | Mật khẩu | Ghi chú |
| --- | --- | --- | --- |
| Super Admin | `admin@gmail.com` | `admin123` | Quyền tối cao, quản trị toàn hệ thống |
| Quản lý (Manager) | `manager@gmail.com` | `manager123` | Thuộc khách sạn "An Nhiên Đà Lạt Hotel", quản lý cấu hình khách sạn |
| Lễ tân (Receptionist) | `receptionist@gmail.com` | `receptionist123` | Thuộc khách sạn "An Nhiên Đà Lạt Hotel", quản lý check-in/out, sơ đồ phòng |
| Kế toán (Accountant) | `accountant@gmail.com` | `accountant123` | Thuộc khách sạn "An Nhiên Đà Lạt Hotel", quản lý hóa đơn, doanh thu |
| Khách hàng (Customer) | `customer@gmail.com` | `customer123` | Khách hàng thông thường đặt phòng online |

## Chức năng chính

- Tìm kiếm theo ngày, khách, hạng phòng, hoàn hủy, số sao và giá; tồn phòng được tính theo booking trùng ngày.
- Quote và booking transactional, khóa tồn phòng, idempotency, dịch vụ bổ sung và voucher.
- Booking online giữ phòng 15 phút; scheduler tự hết hạn và giải phóng tồn phòng/voucher nếu chưa thanh toán mock.
- Checkout 12:00, trừ hao trả trễ 30 phút và dọn phòng 150 phút; phòng kế tiếp sẵn sàng mặc định lúc 15:00.
- Chính sách hủy được snapshot khi đặt: miễn phí trước hạn, tính phí trễ hoặc không hoàn hủy, kèm refund mô phỏng.
- Thanh toán giả lập Card, PayPal, VietQR; lễ tân có thể ghi nhận tiền mặt tại quầy.
- Sanctum Bearer auth, OTP đặt lại mật khẩu demo, OAuth tùy chọn, cập nhật hồ sơ, RBAC và giới hạn dữ liệu theo khách sạn.
- Admin CRUD, upload ảnh, booking tại quầy, check-in/out, dọn phòng, hóa đơn, review moderation và analytics.
- Tìm kiếm giọng nói `vi-VN` mức demo và tracking hành vi không lưu audio/PII thô.
- Chat khách/nhân viên lưu lịch sử trong MongoDB; Socket.io nhận domain events từ transactional outbox qua Redis và có polling fallback.

## Lệnh thường dùng

Xem trạng thái và log:

```bash
docker compose ps
docker compose logs -f mongodb mongo-init redis backend frontend realtime outbox-publisher queue-worker scheduler
```

Chạy test backend và kiểm tra build frontend khi hệ thống đang chạy:

```bash
docker compose exec backend php artisan test
docker compose exec backend vendor/bin/pint --test
docker compose exec frontend npm run smoke
docker compose exec frontend npm run build
docker compose exec realtime npm test
```

Dừng dịch vụ nhưng giữ dữ liệu:

```bash
docker compose down
```

### Reset MongoDB

Reset sẽ xóa toàn bộ dữ liệu và chỉ nên dùng khi chủ động cần làm sạch môi trường development. Không dùng lệnh này như cách khởi động thông thường:

```bash
docker compose exec mongodb mongosh --quiet --eval "db.getSiblingDB('datphong').dropDatabase()"
docker compose exec backend php artisan migrate --force
docker compose exec backend php artisan db:seed --force
```

Nếu đã đổi `MONGODB_DATABASE`, thay `datphong` trong lệnh trên bằng tên database tương ứng. Muốn xóa cả dữ liệu và ảnh upload sau khi dừng hệ thống, xóa riêng hai volume `datphong_v2_mongodb` và `datphong_v2_public_storage`; lần khởi động sau, `mongo-init` sẽ tạo lại replica set `rs0`. Hãy kiểm tra tên volume và sao lưu dữ liệu cần thiết trước khi thực hiện.

## Cấu trúc

```text
DatPhong/
|-- backend/                 Laravel 12 REST API
|   |-- app/                 Models, services, controllers
|   |-- database/            MongoDB index migrations, factories, seeders
|   |-- routes/              Định tuyến web/API
|   |-- storage/app/public/  File storage local cho ảnh upload
|   `-- docker/              Entrypoint của backend
|-- frontend/                Vue 3 + Vite
|   |-- public/              Tài nguyên tĩnh
|   `-- src/                 Giao diện ứng dụng
|-- realtime/                Node.js + Socket.io Redis subscriber
|-- docker-compose.yml       MongoDB rs0, Redis, backend, scheduler, realtime, frontend
|-- .env.example             Cấu hình Docker mẫu
`-- run.bat                  Khởi chạy nhanh trên Windows
```

## Trạng thái tích hợp

Card, PayPal và VietQR hiện là sandbox giả lập, không kết nối payment provider và không xử lý tiền thật. Backend không nhận hoặc lưu CVC/số thẻ đầy đủ. Các client secret và webhook không được cấu hình trong repository cho tới khi provider thật được triển khai và kiểm thử.

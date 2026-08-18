# StayGo - Hệ thống Đặt phòng và Quản lý Khách sạn

> **GitHub Repository:** [https://github.com/hongphuoc6104/quanlykhachsan](https://github.com/hongphuoc6104/quanlykhachsan)  
> **Tài liệu hướng dẫn chi tiết:** Xem file [HUONG_DAN_DU_AN.md](HUONG_DAN_DU_AN.md) hoặc [huong_dan_cai_dat_windows.pdf](huong_dan_cai_dat_windows.pdf).

StayGo là hệ thống web đặt phòng và quản lý khách sạn hiện đại, áp dụng kiến trúc phân tách Client - Server (SPA + REST API + Realtime WebSocket + Polyglot Persistence MySQL/MongoDB/Redis).

---

## Hướng dẫn Cài đặt & Khởi chạy nhanh trên Windows (1-Click)

### 1. Yêu cầu chuẩn bị
- **PHP 8.2+** (bật các extension `pdo_mysql`, `mongodb`, `curl`, `mbstring`, `fileinfo`).
- **Composer** (Tải tại [getcomposer.org](https://getcomposer.org/)).
- **Node.js LTS (v20 hoặc v22)** & **npm** (Tải tại [nodejs.org](https://nodejs.org/)).
- **MySQL 8.0** (qua XAMPP, Laragon hoặc MySQL Server) & **MongoDB 8.0 Community Server**.

### 2. Tải mã nguồn
Mở cửa sổ dòng lệnh (**Command Prompt** hoặc **PowerShell**) và chạy:
```bash
git clone https://github.com/hongphuoc6104/quanlykhachsan.git
cd quanlykhachsan
```

### 3. Khởi tạo và thiết lập tự động (`setup.bat`)
Chỉ cần nhấp đúp chuột vào file **`setup.bat`** (hoặc gõ `setup.bat` trong CMD), script sẽ tự động thực hiện:
1. Tạo file cấu hình `.env` cho Backend và Frontend.
2. Cài đặt toàn bộ dependencies (`composer install` và `npm install`).
3. Khởi tạo Application Key (`php artisan key:generate`) và liên kết lưu trữ (`php artisan storage:link`).
4. Chạy tạo bảng CSDL và nạp sẵn toàn bộ dữ liệu mẫu (`php artisan migrate --seed`).

### 4. Khởi chạy toàn bộ hệ thống (`start.bat` hoặc `run.bat`)
- Nhấp đúp chuột vào file **`start.bat`** (hoặc **`run.bat`**): Hệ thống sẽ tự động mở 3 cửa sổ chạy song song:
  - **Backend API**: `http://localhost:8000`
  - **Realtime Service**: `http://localhost:3001`
  - **Frontend Web**: `http://localhost:3000`

---

## Các cổng dịch vụ mặc định

| Thành phần | Địa chỉ truy cập | Ghi chú |
| --- | --- | --- |
| **Giao diện Web Khách hàng & Admin** | [http://localhost:3000](http://localhost:3000) | Giao diện Vue 3 SPA |
| **Backend REST API** | [http://localhost:8000/api/v1](http://localhost:8000/api/v1) | Laravel 12 API |
| **Kiểm tra Backend Health** | [http://localhost:8000/up](http://localhost:8000/up) | Trạng thái Laravel |
| **Kiểm tra Realtime WebSocket** | [http://localhost:3001/health](http://localhost:3001/health) | Socket.IO Health Check |
| **Cơ sở dữ liệu MySQL 8.0** | `localhost:3306` | User: `root`, DB: `datphong` |
| **Cơ sở dữ liệu MongoDB 8.0** | `localhost:27017` | Database: `datphong` |

---

## Tài khoản dùng thử tích hợp sẵn (RBAC)

Đăng nhập tại: [http://localhost:3000/login](http://localhost:3000/login)

| Vai trò (Role) | Email đăng nhập | Mật khẩu | Tính năng kiểm thử nổi bật |
| --- | --- | --- | --- |
| **Super Admin** | `admin@gmail.com` | `admin123` | Toàn quyền hệ thống, quản lý tất cả khách sạn, nhân sự, cấu hình hệ thống. |
| **Quản lý (Manager)** | `manager@gmail.com` | `manager123` | Quản lý khách sạn "An Nhiên Đà Lạt", sửa giá phòng, thêm voucher, xem báo cáo doanh thu. |
| **Lễ tân (Receptionist)** | `receptionist@gmail.com` | `receptionist123` | Sơ đồ phòng trực quan Realtime, xử lý Check-in/Check-out, tạo đơn tại quầy, xuất hóa đơn. |
| **Kế toán (Accountant)** | `accountant@gmail.com` | `accountant123` | Quản lý danh sách hóa đơn, đối soát dòng tiền thanh toán, kiểm tra hoàn tiền khi hủy phòng. |
| **Khách hàng (Customer)** | `customer@gmail.com` | `customer123` | Tìm kiếm phòng theo ngày, đặt phòng, chọn voucher, thanh toán giả lập, chat CSKH realtime. |

---

## Chức năng chính

- Tìm kiếm theo ngày, khách, hạng phòng, hoàn hủy, số sao và giá; tồn phòng được tính theo booking trùng ngày.
- Quote và booking transactional, khóa tồn phòng, idempotency, dịch vụ bổ sung và voucher.
- Booking online giữ phòng 15 phút; tự hết hạn và giải phóng tồn phòng/voucher nếu chưa thanh toán.
- Checkout 12:00, trừ hao trả trễ 30 phút và dọn phòng 150 phút; phòng kế tiếp sẵn sàng lúc 15:00.
- Chính sách hủy được snapshot khi đặt: miễn phí trước hạn, tính phí trễ hoặc không hoàn hủy, kèm refund mô phỏng.
- Thanh toán giả lập Card, PayPal, VietQR; lễ tân có thể ghi nhận tiền mặt tại quầy.
- Sanctum Bearer auth, OTP đặt lại mật khẩu demo, OAuth tùy chọn, cập nhật hồ sơ, RBAC và giới hạn dữ liệu theo khách sạn.
- Admin CRUD, upload ảnh, booking tại quầy, check-in/out, dọn phòng, hóa đơn, review moderation và analytics.
- Tìm kiếm giọng nói `vi-VN` mức demo và tracking hành vi không lưu audio/PII thô.
- Chat khách/nhân viên lưu lịch sử trong MongoDB; Socket.io nhận domain events qua Redis.

---

## Cấu trúc thư mục

```text
quanlykhachsan/
|-- backend/                 Laravel 12 REST API (PHP 8.2)
|   |-- app/                 Models, Services, Controllers, Repositories
|   |-- database/            Migrations, Factories, Seeders
|   |-- routes/              Định tuyến Web / API v1
|   `-- storage/app/public/  Thư mục lưu trữ ảnh upload
|-- frontend/                Vue 3 + Vite SPA
|   |-- public/              Tài nguyên tĩnh
|   `-- src/                 Components, Views, Stores (Pinia), Router
|-- realtime/                Node.js + Socket.IO Realtime Service
|-- setup.bat                Script tự động thiết lập và cài đặt toàn bộ dự án
|-- start.bat                Script tự động bật 3 dịch vụ trên Windows
`-- run.bat                  Script khởi chạy nhanh hệ thống
```

---

## Trạng thái tích hợp

Card, PayPal và VietQR hiện là sandbox giả lập, không kết nối payment provider và không xử lý tiền thật. Backend không nhận hoặc lưu CVC/số thẻ đầy đủ.

# HƯỚNG DẪN CHẠY DỰ ÁN VÀ TÀI LIỆU HỆ THỐNG ĐẶT PHÒNG KHÁCH SẠN (STAYGO)

---

## 1. GIỚI THIỆU TỔNG QUAN

**StayGo** là hệ sinh thái web đặt phòng và quản lý khách sạn hiện đại, được xây dựng theo kiến trúc phân tách Client - Server (SPA + REST API + Realtime Server + Polyglot Persistence). Hệ thống cung cấp trải nghiệm đặt phòng mượt mà cho khách hàng và phân hệ quản trị nghiệp vụ toàn diện cho nhân viên/quản lý khách sạn.

---

## 2. CÔNG NGHỆ VÀ PHIÊN BẢN SỬ DỤNG

Dự án áp dụng mô hình kiến trúc hiện đại, tận dụng thế mạnh của các công nghệ chuyên biệt:

| Phân tầng | Công nghệ | Phiên bản | Vai trò & Trách nhiệm trong hệ thống |
| :--- | :--- | :--- | :--- |
| **Frontend UI** | **Vue.js** (Composition API) | `v3.5.40` | Xây dựng giao diện Single-Page Application (SPA) phản hồi nhanh, linh hoạt |
| **Build Tool** | **Vite** | `v8.2.0` | Công cụ đóng gói và phát triển frontend tốc độ cao |
| **Routing / State** | **Vue Router** / **Pinia** | `v4.6.4` / `v4.0.3` | Điều hướng trang, route guards phân quyền và quản lý trạng thái tập trung |
| **HTTP / Socket Client** | **Axios** / **Socket.io-client** | `v1.19.0` / `v4.8.3` | Giao tiếp REST API với backend và kết nối realtime với máy chủ Socket |
| **Backend Core** | **Laravel Framework** | `v12.x` (PHP 8.2+) | Xử lý toàn bộ logic nghiệp vụ, REST API v1, ORM, Transaction, Scheduler |
| **Xác thực API** | **Laravel Sanctum** | `v4.2.0` | Quản lý phiên đăng nhập và cấp phát Personal Access Token (Bearer Token) |
| **CSDL Quan hệ** | **MySQL** | `8.0` | Nguồn sự thật (Single Source of Truth) lưu trữ dữ liệu ACID: User, Room, Booking, Invoice, Room Nights (chống overbooking) |
| **CSDL Tài liệu** | **MongoDB** (Replica Set `rs0`)| `8.0` | Lưu trữ lịch sử tin nhắn trò chuyện (Realtime Chat) và nhật ký sự kiện/hoạt động (Activity Logs/Tracking) với cơ chế TTL index |
| **In-memory & Broker** | **Redis** | `7.0-alpine` | Bộ đệm cache, lưu session/queue và đóng vai trò Pub/Sub Message Broker cho Transactional Outbox |
| **Realtime Service** | **Node.js** + **Express** + **Socket.IO** | Node `22+` / Express `5.1.0` / Socket.IO `4.8.1` | Lắng nghe sự kiện từ Redis Pub/Sub và phát sóng (broadcast) tức thì tới Client (sơ đồ phòng, tin nhắn chat) |
| **Container Hóa** | **Docker** & **Docker Compose** | Compose `v2+` | Đóng gói toàn bộ 10 dịch vụ thành một môi trường chạy đồng nhất chỉ với 1 câu lệnh |

---

## 3. HƯỚNG DẪN KHỞI CHẠY DỰ ÁN

### 3.1. Chạy nhanh bằng Docker (Khuyên dùng)

Yêu cầu máy đã cài đặt **Docker Desktop** (hoặc Docker Engine + Docker Compose v2).

1. **Mở Terminal tại thư mục gốc dự án:**
   ```bash
   cd /path/to/qlks
   ```

2. **Khởi chạy toàn bộ hệ thống bằng Docker Compose:**
   ```bash
   docker compose up --build
   ```
   *(Hoặc chạy ngầm trong nền: `docker compose up -d --build`)*
   *(Trên Windows, bạn có thể click đúp chuột vào file `run.bat`)*

3. **Truy cập các dịch vụ:**
   * 🌐 **Giao diện Web Khách hàng & Quản trị:** [http://localhost:3000](http://localhost:3000)
   * 🔌 **Backend REST API:** [http://localhost:8000/api/v1](http://localhost:8000/api/v1)
   * 🟢 **Backend Health Check:** [http://localhost:8000/up](http://localhost:8000/up)
   * ⚡ **Realtime WebSocket Health:** [http://localhost:3001/health](http://localhost:3001/health)
   * 🗄️ **MySQL Host Port:** `localhost:3306` (User: `root`, Password: trống, Database: `datphong`)
   * 🍃 **MongoDB Host Port:** `localhost:27017` (Database: `datphong`)

---

### 3.2. Danh sách tài khoản demo có sẵn

Hệ thống đã tự động nạp (seed) sẵn các tài khoản để bạn kiểm tra phân quyền (RBAC):

| Vai trò (Role) | Email đăng nhập | Mật khẩu | Quyền hạn & Chức năng kiểm thử |
| :--- | :--- | :--- | :--- |
| **Super Admin** | `admin@gmail.com` | `admin123` | Toàn quyền quản trị hệ thống, quản lý khách sạn, người dùng, cấu hình chung |
| **Quản lý (Manager)** | `manager@gmail.com` | `manager123` | Quản lý hạng phòng, giá phòng, dịch vụ, voucher, báo cáo doanh thu của khách sạn |
| **Lễ tân (Receptionist)**| `receptionist@gmail.com` | `receptionist123` | Theo dõi sơ đồ phòng trực quan, check-in/check-out, tạo booking tại quầy, xuất hóa đơn |
| **Kế toán (Accountant)** | `accountant@gmail.com` | `accountant123` | Theo dõi hóa đơn, đối soát công nợ, doanh thu và dòng tiền thanh toán |
| **Khách hàng (Customer)**| `customer@gmail.com` | `customer123` | Tìm kiếm phòng, đặt phòng online, thanh toán giả lập, xem lịch sử đặt phòng, đánh giá và chat |

---

### 3.3. Các lệnh hữu ích khi vận hành

- **Xem danh sách các container đang chạy:**
  ```bash
  docker compose ps
  ```

- **Xem log thời gian thực của toàn bộ hệ thống:**
  ```bash
  docker compose logs -f
  ```

- **Dừng toàn bộ hệ thống:**
  ```bash
  docker compose down
  ```

- **Nạp lại dữ liệu mẫu (Seeder) khi cần thiết:**
  ```bash
  docker compose exec backend php artisan db:seed --force
  ```

- **Chạy bộ kiểm thử tự động (Unit / Feature Test):**
  ```bash
  docker compose exec backend php artisan test
  docker compose exec realtime npm test
  ```

---

## 4. TỔNG QUAN CÁC CHỨC NĂNG NỔI BẬT TRONG DỰ ÁN

### 4.1. Phân hệ Dành cho Khách hàng (Customer / Guest)
1. **Tìm kiếm phòng thông minh & đa tiêu chí:**
   * Tìm kiếm theo điểm đến/khách sạn, khoảng ngày nhận/trả phòng, số lượng khách và số phòng.
   * Bộ lọc động nâng cao: mức giá, số sao đánh giá, loại tiện ích (hồ bơi, wifi, buffet,...), chính sách hoàn hủy linh hoạt.
   * Tích hợp tìm kiếm bằng giọng nói tiếng Việt (`vi-VN`) trực quan.
2. **Chi tiết phòng & Khách sạn:**
   * Bộ sưu tập hình ảnh phòng chất lượng cao, thông số diện tích, giường ngủ, trang thiết bị đi kèm.
   * Tính toán tình trạng phòng trống theo thời gian thực (tồn phòng theo từng đêm lưu trú).
3. **Báo giá & Đặt phòng (Quote Engine):**
   * Tự động tính toán chi phí lưu trú, phụ thu dịch vụ tùy chọn (đưa đón sân bay, bữa sáng, spa,...).
   * Áp dụng mã giảm giá (Voucher) với điều kiện kiểm tra hợp lệ tức thì.
   * Khóa giữ phòng tạm thời 15 phút (Hold reservation) tránh tranh chấp phòng.
4. **Cổng thanh toán giả lập đa kênh (Mock Payment Gateway):**
   * Hỗ trợ quét mã VietQR ngân hàng, Thẻ tín dụng/ghi nợ (Visa/Mastercard), PayPal và Thanh toán tại quầy.
   * Hỗ trợ cơ chế Idempotency Key bảo đảm không bị trừ tiền hoặc tạo trùng đơn khi mạng chập chờn.
5. **Quản lý lịch sử đặt phòng & Hóa đơn:**
   * Tra cứu đơn đặt phòng theo mã đặt chỗ hoặc tài khoản cá nhân.
   * Xem và in hóa đơn thanh toán điện tử (Electronic Invoice).
   * Hủy phòng trực tuyến: Tự động tính toán số tiền hoàn dựa trên snapshot chính sách hủy (miễn phí trước hạn, trừ phí hoặc không hoàn tiền).
6. **Đánh giá & Phản hồi (Reviews):**
   * Đánh giá sao và nhận xét trải nghiệm sau khi hoàn tất kỳ nghỉ (sau khi Check-out thành công).
7. **Hỗ trợ trực tuyến thời gian thực (Realtime Chat Widget):**
   * Khung chat nổi trò chuyện trực tiếp 1-1 với nhân viên lễ tân/CSKH của khách sạn.
   * Nhận tin nhắn tức thời qua Socket.IO mà không cần tải lại trang.

---

### 4.2. Phân hệ Quản trị & Nghiệp vụ Khách sạn (Admin / Staff Portal)
1. **Sơ đồ phòng trực quan thời gian thực (Live Room Map):**
   * Trực quan hóa trạng thái từng phòng vật lý: *Trống (Available)*, *Đang có khách (Occupied)*, *Đang dọn dẹp (Cleaning)*, *Bảo trì (Maintenance)*.
   * Cập nhật màu sắc và trạng thái phòng tự động tức thì khi có khách nhận phòng hoặc dọn dẹp xong nhờ Socket.IO.
2. **Quản lý Đặt phòng (Booking Operations):**
   * Tiếp nhận đơn đặt phòng online, tạo booking trực tiếp tại quầy cho khách vãng lai (Walk-in booking).
   * Thực hiện quy trình Check-in (nhận phòng) và Check-out (trả phòng) chỉ với 1 click.
   * Xử lý trả phòng muộn (Late checkout) và thời gian dọn phòng đệm (Room Turnover Buffer 150 phút).
3. **Quản lý Tài nguyên Khách sạn:**
   * Quản lý danh sách Khách sạn, Khu vực, Hạng phòng (Room Types) và Phòng vật lý (Physical Rooms).
   * Quản lý gói Dịch vụ (Services) và Mã giảm giá (Vouchers).
   * Upload và quản lý thư viện hình ảnh phòng trực tiếp lên Storage.
4. **Quản trị Tài chính & Hóa đơn (Billing & Invoicing):**
   * Theo dõi toàn bộ dòng tiền thanh toán, phụ thu dịch vụ phát sinh, trạng thái hoàn tiền.
   * Xuất dữ liệu hóa đơn phục vụ kế toán đối soát.
5. **Kiểm duyệt Đánh giá (Review Moderation):**
   * Duyệt, ẩn hoặc phản hồi đánh giá của khách hàng.
6. **Hộp thư CSKH đa kênh (Staff Chat Inbox):**
   * Tiếp nhận các cuộc trò chuyện từ khách hàng theo từng khách sạn.
   * Phân chia trạng thái hỗ trợ và trả lời realtime.
7. **Báo cáo & Thống kê kinh doanh (Analytics Dashboard):**
   * Biểu đồ doanh thu theo thời gian, tỷ lệ lấp đầy phòng (Occupancy rate), số lượng booking theo trạng thái.

---

## 5. ĐIỂM NỔI BẬT VỀ MẶT KỸ THUẬT (ARCHITECTURAL HIGHLIGHTS)

1. **Transactional Outbox Pattern:**
   * Loại bỏ hoàn toàn lỗi **Dual-write** giữa Database và Message Broker. Khi có hành động nghiệp vụ (đặt phòng, thanh toán, đổi trạng thái phòng), backend lưu dữ liệu và bản ghi `outbox_events` trong cùng một MySQL Transaction.
   * Service `outbox-publisher` độc lập sẽ đọc bảng outbox và đẩy lên Redis Pub/Sub -> Socket.IO broadcast đến client.
2. **Ngăn chặn Overbooking bằng Ràng buộc Cơ sở dữ liệu:**
   * Bảng `room_nights` lưu thông tin từng đêm của từng phòng vật lý với khóa Unique `(room_id, night)`. Đảm bảo tuyệt đối không có 2 đơn đặt phòng nào có thể giữ trùng 1 phòng trong cùng một đêm.
3. **Khử trùng lặp yêu cầu (Idempotency Control):**
   * Áp dụng Idempotency Key cho các tác vụ nhạy cảm như tạo Booking và thực hiện Thanh toán.
4. **Tự động hóa xử lý hết hạn giữ phòng (Background Scheduler):**
   * Cron job của Laravel tự động quét và giải phóng các phòng đang giữ tạm (Hold) quá 15 phút mà khách chưa hoàn tất thanh toán.


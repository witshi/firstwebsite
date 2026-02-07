# First Website

Ứng dụng web full-stack sử dụng **Laravel** (backend API), **SvelteKit** (frontend), **Tailwind CSS** (giao diện), và **MySQL** (cơ sở dữ liệu). Chạy trên Docker thông qua Laravel Sail.

## Công nghệ sử dụng

| Tầng | Công nghệ |
|------|-----------|
| Backend / API | Laravel (PHP) |
| Frontend | SvelteKit |
| Giao diện | Tailwind CSS |
| Cơ sở dữ liệu | MySQL 8.4 |
| Môi trường phát triển | Docker (Laravel Sail) |

---

## Cấu trúc dự án

```
firstwebsite/
│
├── app/                        # ⚙️ BACKEND — Code PHP chính
│   ├── Http/
│   │   └── Controllers/        #   Xử lý request (logic nghiệp vụ)
│   ├── Models/                  #   Eloquent models (bảng DB dưới dạng class PHP)
│   └── Providers/               #   Service providers (khởi tạo ứng dụng)
│
├── routes/                     # 🔀 ĐỊNH TUYẾN (ROUTING)
│   ├── web.php                  #   Routes web (trả về HTML/views)
│   └── api.php                  #   Routes API (trả về JSON, SvelteKit gọi vào đây)
│
├── database/                   # 🗄️ CƠ SỞ DỮ LIỆU
│   ├── migrations/              #   Định nghĩa bảng (tạo/sửa bảng)
│   ├── seeders/                 #   Dữ liệu mẫu (điền dữ liệu test vào bảng)
│   └── factories/               #   Factory (tạo dữ liệu giả cho testing)
│
├── resources/                  # 🎨 FRONTEND LARAVEL (Blade templates, sẽ thay bằng SvelteKit)
│   ├── views/                   #   Blade templates (.blade.php)
│   ├── css/                     #   File CSS
│   └── js/                      #   File JavaScript
│
├── frontend/                   # 🖥️ FRONTEND SVELTEKIT (sẽ tạo sau)
│   ├── src/
│   │   ├── routes/              #   Các trang & layout SvelteKit
│   │   ├── lib/                 #   Components & tiện ích dùng chung
│   │   └── app.html             #   HTML gốc
│   ├── static/                  #   File tĩnh (ảnh, font)
│   ├── svelte.config.js         #   Cấu hình SvelteKit
│   ├── tailwind.config.js       #   Cấu hình Tailwind CSS
│   └── package.json             #   Dependencies Node.js
│
├── config/                     # ⚡ CẤU HÌNH
│   ├── database.php             #   Kết nối cơ sở dữ liệu
│   ├── auth.php                 #   Xác thực người dùng
│   ├── app.php                  #   Cấu hình ứng dụng
│   └── ...                      #   Các file cấu hình khác
│
├── public/                     # 📁 PUBLIC — File truy cập công khai
│   └── index.php                #   Điểm vào của Laravel
│
├── storage/                    # 📦 LƯU TRỮ — Logs, cache, views đã biên dịch
│   ├── logs/                    #   Log ứng dụng
│   └── framework/               #   Cache & sessions của framework
│
├── tests/                      # 🧪 KIỂM THỬ
│   ├── Feature/                 #   Test tích hợp
│   └── Unit/                    #   Test đơn vị
│
├── compose.yaml                # 🐳 Docker Compose (Laravel Sail)
├── composer.json                #   Dependencies PHP
├── package.json                 #   Dependencies Node.js (gốc)
├── vite.config.js               #   Cấu hình build Vite (cho Laravel assets)
├── artisan                      #   Công cụ dòng lệnh Laravel
└── .env                         #   Biến môi trường (thông tin DB, v.v.)
```

---

## Viết code ở đâu?

### Backend (Laravel API)

| Công việc | Lệnh | File nằm ở |
|-----------|-------|------------|
| Tạo Controller mới | `sail artisan make:controller ProductController` | `app/Http/Controllers/` |
| Tạo Model + Migration | `sail artisan make:model Product -m` | `app/Models/` + `database/migrations/` |
| Tạo Migration | `sail artisan make:migration create_products_table` | `database/migrations/` |
| Thêm route API | Sửa trực tiếp | `routes/api.php` |
| Thêm route web | Sửa trực tiếp | `routes/web.php` |
| Tạo Middleware | `sail artisan make:middleware CheckAdmin` | `app/Http/Middleware/` |
| Tạo Seeder | `sail artisan make:seeder ProductSeeder` | `database/seeders/` |

### Frontend (SvelteKit + Tailwind CSS)

| Công việc | File nằm ở |
|-----------|------------|
| Tạo trang mới | `frontend/src/routes/ten-trang/+page.svelte` |
| Tạo layout | `frontend/src/routes/+layout.svelte` |
| Component dùng chung | `frontend/src/lib/components/Button.svelte` |
| Gọi API từ Laravel | `frontend/src/routes/ten-trang/+page.server.ts` |
| Cấu hình Tailwind | `frontend/tailwind.config.js` |
| CSS toàn cục | `frontend/src/app.css` |

### Cơ sở dữ liệu (MySQL)

| Công việc | Cách làm |
|-----------|----------|
| Tạo bảng mới | `sail artisan make:migration create_products_table` → sửa file migration |
| Sửa bảng | `sail artisan make:migration add_color_to_products_table` → sửa file migration |
| Chạy migrations | `sail artisan migrate` |
| Hoàn tác migration | `sail artisan migrate:rollback` |
| Điền dữ liệu mẫu | `sail artisan db:seed` |
| Truy cập MySQL CLI | `sail mysql` |

---

## Bắt đầu

```bash
# 1. Clone repository
git clone https://github.com/witshi/firstwebsite.git
cd firstwebsite

# 2. Cài dependencies PHP
composer install

# 3. Sao chép file môi trường
cp .env.example .env

# 4. Khởi động Docker containers
./vendor/bin/sail up -d

# 5. Tạo application key
./vendor/bin/sail artisan key:generate

# 6. Chạy database migrations
./vendor/bin/sail artisan migrate

# 7. Truy cập ứng dụng
# Laravel: http://localhost
# SvelteKit: http://localhost:5173 (sau khi cài đặt)
```

### Các lệnh Sail thường dùng

```bash
alias sail='./vendor/bin/sail'

sail up -d          # Khởi động containers ở chế độ nền
sail down           # Tắt containers
sail artisan ...    # Chạy lệnh artisan
sail composer ...   # Chạy lệnh composer
sail npm ...        # Chạy lệnh npm
sail mysql          # Mở MySQL CLI
sail tinker         # Mở PHP REPL (chạy PHP trực tiếp)
sail test           # Chạy tests
```

---

## Tổng quan kiến trúc

```
Trình duyệt → SvelteKit (port 5173) → Laravel API (port 80) → MySQL (port 3306)
                   ↑                         ↑                       ↑
              Tailwind CSS              Eloquent ORM            Migrations
              Components                Controllers              Seeders
              Routing                   Middleware
```

SvelteKit xử lý giao diện và gọi đến các API endpoint của Laravel. Laravel xử lý request, tương tác với MySQL qua Eloquent ORM, và trả về dữ liệu JSON.

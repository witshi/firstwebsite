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

## Cài đặt & Chạy dự án

Có 2 cách để chạy dự án. Chọn cách phù hợp với bạn:

---

### Cách 1: Docker + Laravel Sail (khuyến khích)

> Ưu điểm: Môi trường giống nhau cho tất cả mọi người, không lo lỗi "máy tôi chạy được mà".
> Nhược điểm: Cần cài Docker, tốn RAM hơn.

#### Bước 1: Cài đặt Docker (chỉ làm 1 lần)

**Windows:**
1. Mở **PowerShell** với quyền **Administrator**, chạy:
   ```powershell
   wsl --install
   ```
2. **Khởi động lại máy tính**
3. Tải và cài [Docker Desktop](https://www.docker.com/products/docker-desktop/)
4. Mở Docker Desktop → vào **Settings** → **General** → đảm bảo **"Use the WSL 2 based engine"** đã được bật
5. Vào **Settings** → **Resources** → **WSL Integration** → bật distro Ubuntu

**macOS:**
1. Tải và cài [Docker Desktop](https://www.docker.com/products/docker-desktop/)
2. Xong.

**Linux:**
1. Cài Docker Engine theo [hướng dẫn chính thức](https://docs.docker.com/engine/install/)

#### Bước 2: Clone và chạy dự án

```bash
# Clone repo
git clone https://github.com/witshi/firstwebsite.git
cd firstwebsite

# Cài dependencies PHP (chạy trong Docker, không cần cài PHP trên máy)
docker run --rm -v $(pwd):/var/www/html -w /var/www/html laravelsail/php85-composer:latest composer install --ignore-platform-reqs

# Sao chép file môi trường
cp .env.example .env

# Khởi động containers (Laravel + MySQL)
./vendor/bin/sail up -d

# Tạo application key
./vendor/bin/sail artisan key:generate

# Chạy migrations (tạo bảng trong database)
./vendor/bin/sail artisan migrate

# Truy cập: http://localhost
```

#### Các lệnh Sail thường dùng

```bash
# Tạo alias cho tiện (thêm vào ~/.bashrc để không phải gõ lại)
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

### Cách 2: XAMPP / Laragon (không cần Docker)

> Ưu điểm: Đơn giản, quen thuộc, nhẹ máy.
> Nhược điểm: Có thể gặp lỗi do khác phiên bản PHP/MySQL giữa các máy.

#### Bước 1: Cài phần mềm cần thiết

1. Cài [XAMPP](https://www.apachefriends.org/) hoặc [Laragon](https://laragon.org/) (khuyến khích Laragon vì dễ dùng hơn)
2. Cài [Composer](https://getcomposer.org/download/) (quản lý dependencies PHP)
3. Cài [Git](https://git-scm.com/downloads)

> **Yêu cầu phiên bản:** PHP >= 8.2, MySQL >= 8.0

#### Bước 2: Clone và cấu hình

```bash
# Clone repo
git clone https://github.com/witshi/firstwebsite.git
cd firstwebsite

# Cài dependencies PHP
composer install

# Sao chép file môi trường
cp .env.example .env
```

#### Bước 3: Tạo database

1. Mở **XAMPP Control Panel** → Start **Apache** và **MySQL**
2. Mở trình duyệt → vào `http://localhost/phpmyadmin`
3. Tạo database mới tên: `laravel`

*(Hoặc với Laragon: chuột phải vào icon Laragon → MySQL → tạo database `laravel`)*

#### Bước 4: Cấu hình file `.env`

Mở file `.env` và sửa phần database:

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=
```

> **Lưu ý:** XAMPP mặc định MySQL user là `root`, password trống. Nếu bạn đã đặt password thì sửa lại cho đúng.

#### Bước 5: Chạy dự án

```bash
# Tạo application key
php artisan key:generate

# Chạy migrations (tạo bảng trong database)
php artisan migrate

# Khởi động server
php artisan serve

# Truy cập: http://localhost:8000
```

#### Các lệnh artisan thường dùng (không Docker)

```bash
php artisan serve              # Chạy server development
php artisan migrate            # Chạy migrations
php artisan migrate:rollback   # Hoàn tác migration
php artisan make:model X -m    # Tạo model + migration
php artisan make:controller X  # Tạo controller
php artisan db:seed            # Điền dữ liệu mẫu
php artisan tinker             # Mở PHP REPL
php artisan test               # Chạy tests
```

---

### So sánh nhanh 2 cách

| | Docker (Sail) | XAMPP / Laragon |
|---|---|---|
| Cần cài | Docker Desktop (+ WSL2 trên Windows) | XAMPP/Laragon + Composer |
| Lệnh chạy server | `sail up -d` | `php artisan serve` |
| Lệnh artisan | `sail artisan ...` | `php artisan ...` |
| Truy cập web | `http://localhost` | `http://localhost:8000` |
| MySQL | Tự động chạy trong Docker | Bật trong XAMPP/Laragon |
| Cấu hình DB | Không cần sửa `.env` | Phải sửa `.env` (host, user, pass) |
| RAM sử dụng | ~1-2 GB | ~200-400 MB |

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

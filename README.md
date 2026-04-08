# First Website

Ứng dụng web sử dụng Laravel 13 + Inertia + Svelte + Tailwind CSS + MySQL.

Tài liệu này dành cho thành viên trong nhóm chạy dự án trên máy cá nhân bằng XAMPP/Laragon + Composer (không dùng Sail).

## Tổng quan công nghệ

| Thành phần | Công nghệ |
|---|---|
| Backend | Laravel 13 (PHP) |
| Frontend | Inertia.js + Svelte 5 (nằm trong `resources/js`) |
| UI | Tailwind CSS 4 |
| Build frontend | Vite |
| Cơ sở dữ liệu | MySQL |

## Cấu trúc dự án hiện tại

```
firstwebsite/
|
|-- app/                       # Backend Laravel (Controllers, Models, Middleware...)
|-- bootstrap/
|-- config/
|-- database/
|   |-- factories/
|   |-- migrations/
|   `-- seeders/
|-- public/                    # Public entry (index.php) và tài nguyên build
|-- resources/
|   |-- css/app.css            # CSS tổng (Tailwind)
|   |-- js/
|   |   |-- app.ts             # Khởi tạo Inertia + Svelte
|   |   |-- pages/             # Các trang Svelte
|   |   |-- layouts/           # Layouts
|   |   `-- components/        # Components dùng chung
|   `-- views/app.blade.php    # Blade host cho Inertia
|-- routes/
|   |-- web.php                # Web routes hiện tại
|   |-- settings.php
|   `-- console.php
|-- storage/
|-- tests/
|-- composer.json
|-- package.json
|-- vite.config.ts
`-- artisan
```

## Yêu cầu môi trường cho thành viên

1. XAMPP hoặc Laragon (cần MySQL đang chạy).
2. PHP 8.3 trở lên (dự án yêu cầu `php:^8.3`).
3. Composer.
4. Node.js 20 trở lên + npm.
5. Git.

## Hướng dẫn clone và chạy dự án (XAMPP/Laragon)

### 1) Clone source code

```bash
git clone https://github.com/witshi/firstwebsite.git
cd firstwebsite
```

### 2) Cài dependencies

```bash
composer install
npm install
```

### 3) Tạo và cấu hình file môi trường

```bash
cp .env.example .env
php artisan key:generate
```

Mở file `.env`, cập nhật thông tin database theo máy của bạn (ví dụ với XAMPP mặc định):

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=
```

Nếu bạn đặt mật khẩu cho MySQL thì điền lại `DB_PASSWORD` cho đúng.

### 4) Tạo database và chạy migration

1. Mở phpMyAdmin (`http://localhost/phpmyadmin`) hoặc công cụ MySQL bạn đang dùng.
2. Tạo database mới (gợi ý: `laravel`).
3. Chạy lệnh:

```bash
php artisan migrate
```

Nếu cần dữ liệu mẫu:

```bash
php artisan db:seed
```

### 5) Chạy ứng dụng

Mở 2 terminal trong thư mục dự án:

Terminal 1 (Laravel server):

```bash
php artisan serve
```

Terminal 2 (Vite dev server):

```bash
npm run dev
```

Truy cập:

- App: http://127.0.0.1:8000
- Vite dev server: http://127.0.0.1:5173

Lưu ý: Để giao diện cập nhật hot-reload đúng cách, cần để `npm run dev` chạy song song với `php artisan serve`.

## Các lệnh hay dùng

```bash
php artisan serve
php artisan migrate
php artisan migrate:rollback
php artisan db:seed
php artisan test

npm run dev
npm run build
npm run lint
npm run types:check
```

## Các vị trí code thường sửa

- Route web: `routes/web.php`
- Controller: `app/Http/Controllers/`
- Model: `app/Models/`
- Migration: `database/migrations/`
- Trang Svelte: `resources/js/pages/`
- Layout Svelte: `resources/js/layouts/`
- Component dùng chung: `resources/js/components/`

## Xử lý lỗi thường gặp

1. Lỗi thiếu APP_KEY:

```bash
php artisan key:generate
```

2. Lỗi không kết nối được database:

- Kiểm tra MySQL đã start trong XAMPP/Laragon.
- Kiểm tra lại DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, DB_PASSWORD trong `.env`.

3. Trang không có CSS/JS hoặc không hot reload:

- Đảm bảo đang chạy `npm run dev`.
- Chạy lại `npm install` nếu chưa cài Node modules.

## Ghi chú về Docker

Team dev local không cần dùng Docker. Phần đóng gói Docker và triển khai VPS sẽ được quản lý riêng bởi maintainer.

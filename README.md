# First Website

Full-stack web application built with **Laravel** (backend API), **SvelteKit** (frontend), **Tailwind CSS** (styling), and **MySQL** (database). Runs on Docker via Laravel Sail.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Backend / API | Laravel (PHP) |
| Frontend | SvelteKit |
| Styling | Tailwind CSS |
| Database | MySQL 8.4 |
| Dev Environment | Docker (Laravel Sail) |

---

## Project Structure

```
firstwebsite/
│
├── app/                        # ⚙️ BACKEND — PHP application code
│   ├── Http/
│   │   └── Controllers/        #   Route handlers (business logic)
│   ├── Models/                  #   Eloquent models (DB tables as PHP classes)
│   └── Providers/               #   Service providers (app bootstrapping)
│
├── routes/                     # 🔀 ROUTING
│   ├── web.php                  #   Web routes (returns HTML/views)
│   └── api.php                  #   API routes (returns JSON, used by SvelteKit)
│
├── database/                   # 🗄️ DATABASE
│   ├── migrations/              #   Table definitions (create/alter tables)
│   ├── seeders/                 #   Seed data (populate tables with test data)
│   └── factories/               #   Model factories (generate fake data for testing)
│
├── resources/                  # 🎨 LARAVEL FRONTEND (Blade templates, can be replaced by SvelteKit)
│   ├── views/                   #   Blade templates (.blade.php)
│   ├── css/                     #   CSS source files
│   └── js/                      #   JavaScript source files
│
├── frontend/                   # 🖥️ SVELTEKIT FRONTEND (to be created)
│   ├── src/
│   │   ├── routes/              #   SvelteKit pages & layouts
│   │   ├── lib/                 #   Shared components & utilities
│   │   └── app.html             #   HTML shell
│   ├── static/                  #   Static assets (images, fonts)
│   ├── svelte.config.js         #   SvelteKit configuration
│   ├── tailwind.config.js       #   Tailwind CSS configuration
│   └── package.json             #   Node.js dependencies
│
├── config/                     # ⚡ CONFIGURATION
│   ├── database.php             #   Database connection settings
│   ├── auth.php                 #   Authentication settings
│   ├── app.php                  #   Application settings
│   └── ...                      #   Other config files
│
├── public/                     # 📁 PUBLIC — Publicly accessible files
│   └── index.php                #   Laravel entry point
│
├── storage/                    # 📦 STORAGE — Logs, cache, compiled views
│   ├── logs/                    #   Application logs
│   └── framework/               #   Framework cache & sessions
│
├── tests/                      # 🧪 TESTS
│   ├── Feature/                 #   Feature/integration tests
│   └── Unit/                    #   Unit tests
│
├── compose.yaml                # 🐳 Docker Compose (Laravel Sail)
├── composer.json                #   PHP dependencies
├── package.json                 #   Node.js dependencies (root)
├── vite.config.js               #   Vite build config (for Laravel assets)
├── artisan                      #   Laravel CLI tool
└── .env                         #   Environment variables (DB credentials, etc.)
```

---

## Where to Write Code

### Backend (Laravel API)

| Task | Command | File Location |
|------|---------|---------------|
| New Controller | `sail artisan make:controller ProductController` | `app/Http/Controllers/` |
| New Model + Migration | `sail artisan make:model Product -m` | `app/Models/` + `database/migrations/` |
| New Migration only | `sail artisan make:migration create_products_table` | `database/migrations/` |
| Add API route | Edit directly | `routes/api.php` |
| Add web route | Edit directly | `routes/web.php` |
| New Middleware | `sail artisan make:middleware CheckAdmin` | `app/Http/Middleware/` |
| New Seeder | `sail artisan make:seeder ProductSeeder` | `database/seeders/` |

### Frontend (SvelteKit + Tailwind CSS)

| Task | File Location |
|------|---------------|
| New page | `frontend/src/routes/page-name/+page.svelte` |
| New layout | `frontend/src/routes/+layout.svelte` |
| Shared component | `frontend/src/lib/components/Button.svelte` |
| API call to Laravel | `frontend/src/routes/page-name/+page.server.ts` |
| Tailwind config | `frontend/tailwind.config.js` |
| Global styles | `frontend/src/app.css` |

### Database (MySQL)

| Task | How |
|------|-----|
| Create table | `sail artisan make:migration create_products_table` → edit migration file |
| Modify table | `sail artisan make:migration add_color_to_products_table` → edit migration |
| Run migrations | `sail artisan migrate` |
| Rollback | `sail artisan migrate:rollback` |
| Seed data | `sail artisan db:seed` |
| Access MySQL CLI | `sail mysql` |

---

## Getting Started

```bash
# 1. Clone the repository
git clone https://github.com/witshi/firstwebsite.git
cd firstwebsite

# 2. Install PHP dependencies
composer install

# 3. Copy environment file
cp .env.example .env

# 4. Start Docker containers
./vendor/bin/sail up -d

# 5. Generate application key
./vendor/bin/sail artisan key:generate

# 6. Run database migrations
./vendor/bin/sail artisan migrate

# 7. Access the app
# Laravel: http://localhost
# SvelteKit: http://localhost:5173 (after setup)
```

### Useful Sail Commands

```bash
alias sail='./vendor/bin/sail'

sail up -d          # Start containers in background
sail down           # Stop containers
sail artisan ...    # Run artisan commands
sail composer ...   # Run composer commands
sail npm ...        # Run npm commands
sail mysql          # Open MySQL CLI
sail tinker         # Open PHP REPL
sail test           # Run tests
```

---

## Architecture Overview

```
Browser → SvelteKit (port 5173) → Laravel API (port 80) → MySQL (port 3306)
              ↑                         ↑                       ↑
         Tailwind CSS              Eloquent ORM            Migrations
         Components                Controllers              Seeders
         Routing                   Middleware
```

SvelteKit handles the UI and calls Laravel's API endpoints. Laravel processes requests, interacts with MySQL via Eloquent ORM, and returns JSON responses.

SET NAMES utf8mb4;
SET time_zone = '+00:00';
SET FOREIGN_KEY_CHECKS = 0;

-- --------------------------------------------------------------------------
-- 1. DROP ALL EXISTING TABLES 
-- --------------------------------------------------------------------------
DROP TABLE IF EXISTS user_recipe_access;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS payment_transactions;
DROP TABLE IF EXISTS recipe_reviews;
DROP TABLE IF EXISTS recipe_favorites;
DROP TABLE IF EXISTS recipe_steps;
DROP TABLE IF EXISTS recipe_ingredients;
DROP TABLE IF EXISTS recipe_tag_map;
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS media_assets;
DROP TABLE IF EXISTS pages;
DROP TABLE IF EXISTS blog_posts;
DROP TABLE IF EXISTS site_settings;
DROP TABLE IF EXISTS social_accounts;
DROP TABLE IF EXISTS sessions;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS failed_jobs;
DROP TABLE IF EXISTS job_batches;
DROP TABLE IF EXISTS jobs;
DROP TABLE IF EXISTS cache_locks;
DROP TABLE IF EXISTS cache;
DROP TABLE IF EXISTS migrations;

SET FOREIGN_KEY_CHECKS = 1;

-- --------------------------------------------------------------------------
-- 2. LARAVEL CORE & QUEUE
-- --------------------------------------------------------------------------

CREATE TABLE migrations (
    id          INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    migration   VARCHAR(255) NOT NULL,
    batch       INT          NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cache (
    `key`       VARCHAR(255) NOT NULL PRIMARY KEY,
    `value`     MEDIUMTEXT   NOT NULL,
    expiration  INT          NOT NULL,
    KEY cache_expiration_index (expiration)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cache_locks (
    `key`       VARCHAR(255) NOT NULL PRIMARY KEY,
    owner       VARCHAR(255) NOT NULL,
    expiration  INT          NOT NULL,
    KEY cache_locks_expiration_index (expiration)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE jobs (
    id           BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    queue        VARCHAR(255)     NOT NULL,
    payload      LONGTEXT         NOT NULL,
    attempts     TINYINT UNSIGNED NOT NULL,
    reserved_at  INT UNSIGNED     NULL,
    available_at INT UNSIGNED     NOT NULL,
    created_at   INT UNSIGNED     NOT NULL,
    KEY jobs_queue_index (queue)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE job_batches (
    id              VARCHAR(255) NOT NULL PRIMARY KEY,
    name            VARCHAR(255) NOT NULL,
    total_jobs      INT          NOT NULL,
    pending_jobs    INT          NOT NULL,
    failed_jobs     INT          NOT NULL,
    failed_job_ids  LONGTEXT     NOT NULL,
    options         MEDIUMTEXT   NULL,
    cancelled_at    INT          NULL,
    created_at      INT          NOT NULL,
    finished_at     INT          NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE failed_jobs (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    uuid        VARCHAR(255)    NOT NULL UNIQUE,
    connection  TEXT            NOT NULL,
    queue       TEXT            NOT NULL,
    payload     LONGTEXT        NOT NULL,
    exception   LONGTEXT        NOT NULL,
    failed_at   TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE password_reset_tokens (
    email       VARCHAR(255) NOT NULL PRIMARY KEY,
    token       VARCHAR(255) NOT NULL,
    created_at  TIMESTAMP    NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------------
-- 3. USERS & AUTH
-- --------------------------------------------------------------------------

CREATE TABLE users (
    id                          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name                        VARCHAR(255)    NOT NULL,
    email                       VARCHAR(255)    NOT NULL UNIQUE,
    email_verified_at           TIMESTAMP       NULL,
    password                    VARCHAR(255)    NULL,           -- NULL cho phép Social Login bằng FB, Google
    role                        ENUM('owner', 'customer', 'admin') NOT NULL DEFAULT 'customer', --admin là tài khoản cho CTV đăng bài hộ
    avatar_url                  VARCHAR(2048)   NULL,

    phone_number                VARCHAR(20)     NULL,
    marketing_opt_in            TINYINT         NOT NULL DEFAULT 0,

    status                      ENUM('active', 'suspended') NOT NULL DEFAULT 'active',
    two_factor_secret           TEXT            NULL,
    two_factor_recovery_codes   TEXT            NULL,
    two_factor_confirmed_at     TIMESTAMP       NULL,
    remember_token              VARCHAR(100)    NULL,
    last_login_at               TIMESTAMP       NULL,
    created_at                  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at                  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at                  TIMESTAMP       NULL,           -- Soft delete

    KEY users_role_index       (role),
    KEY users_status_index     (status),
    KEY users_deleted_at_idx   (deleted_at)     -- Laravel luôn WHERE deleted_at IS NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE sessions (
    id            VARCHAR(255)    NOT NULL PRIMARY KEY,
    user_id       BIGINT UNSIGNED NULL,
    ip_address    VARCHAR(45)     NULL,
    user_agent    TEXT            NULL,
    payload       LONGTEXT        NOT NULL,
    last_activity INT             NOT NULL,
    KEY sessions_user_id_index       (user_id),
    KEY sessions_last_activity_index (last_activity),
    CONSTRAINT sessions_user_id_fk FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE social_accounts (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    user_id         BIGINT UNSIGNED NOT NULL,
    provider        VARCHAR(50)     NOT NULL,   -- 'google', 'facebook'
    provider_id     VARCHAR(255)    NOT NULL,
    token           TEXT            NULL,
    refresh_token   TEXT            NULL,
    created_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY social_accounts_provider_id_unique (provider, provider_id),
    CONSTRAINT social_accounts_user_fk FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------------
-- 4. MEDIA & TAXONOMY
-- --------------------------------------------------------------------------

CREATE TABLE media_assets (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    owner_user_id   BIGINT UNSIGNED NULL,
    disk            VARCHAR(40)     NOT NULL DEFAULT 'public',
    path            VARCHAR(1024)   NOT NULL,
    mime_type       VARCHAR(150)    NOT NULL,
    size_bytes      BIGINT UNSIGNED NOT NULL,
    alt_text        VARCHAR(255)    NULL,
    created_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT media_assets_owner_fk FOREIGN KEY (owner_user_id) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE categories (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(120)    NOT NULL,
    slug        VARCHAR(160)    NOT NULL UNIQUE,
    description TEXT            NULL,
    is_active   TINYINT         NOT NULL DEFAULT 1,
    sort_order  INT             NOT NULL DEFAULT 0,
    created_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY categories_is_active_sort_idx (is_active, sort_order)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE tags (
    id          BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    name        VARCHAR(80)     NOT NULL,
    slug        VARCHAR(120)    NOT NULL UNIQUE,
    created_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- --------------------------------------------------------------------------
-- 5. RECIPES
-- --------------------------------------------------------------------------

CREATE TABLE recipes (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    author_id       BIGINT UNSIGNED NOT NULL,
    category_id     BIGINT UNSIGNED NULL,        -- NULL = chưa phân loại
    cover_media_id  BIGINT UNSIGNED NULL,
    video_url       VARCHAR(1024)   NULL,
    title           VARCHAR(255)    NOT NULL,
    slug            VARCHAR(255)    NOT NULL UNIQUE,
    excerpt         TEXT            NULL,
    description     LONGTEXT        NULL,
    difficulty      ENUM('easy', 'medium', 'hard') NOT NULL DEFAULT 'easy',
    prep_minutes    SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    cook_minutes    SMALLINT UNSIGNED NOT NULL DEFAULT 0,
    total_minutes   SMALLINT UNSIGNED GENERATED ALWAYS AS (prep_minutes + cook_minutes) STORED,
    servings        SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    calories_kcal   SMALLINT UNSIGNED NULL,
    is_published    TINYINT         NOT NULL DEFAULT 0,
    published_at    TIMESTAMP       NULL,
    access_type     ENUM('free', 'paid') NOT NULL DEFAULT 'free',
    price           BIGINT UNSIGNED NOT NULL DEFAULT 0,  -- VND, 0 nếu free
    currency        CHAR(3)         NOT NULL DEFAULT 'VND',
    seo_title       VARCHAR(255)    NULL,
    seo_description VARCHAR(500)    NULL,
    seo_keywords    VARCHAR(255)    NULL,
    view_count      INT UNSIGNED    NOT NULL DEFAULT 0,
    created_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP       NULL,                -- Soft delete: không xóa cứng vì có order/access

    KEY recipes_publish_access_idx (is_published, access_type, published_at),
    KEY recipes_deleted_at_idx     (deleted_at),         -- Laravel luôn WHERE deleted_at IS NULL
    FULLTEXT KEY recipes_search_ft (title, excerpt),
    CONSTRAINT recipes_author_fk      FOREIGN KEY (author_id)      REFERENCES users        (id) ON DELETE RESTRICT,
    CONSTRAINT recipes_category_fk    FOREIGN KEY (category_id)    REFERENCES categories   (id) ON DELETE SET NULL,
    CONSTRAINT recipes_cover_media_fk FOREIGN KEY (cover_media_id) REFERENCES media_assets (id) ON DELETE SET NULL,
    -- Đảm bảo: free thì price = 0, paid thì price > 0
    CONSTRAINT recipes_paid_price_chk CHECK ((access_type = 'free' AND price = 0) OR (access_type = 'paid' AND price > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recipe_tag_map (
    recipe_id   BIGINT UNSIGNED NOT NULL,
    tag_id      BIGINT UNSIGNED NOT NULL,
    PRIMARY KEY (recipe_id, tag_id),
    CONSTRAINT recipe_tag_map_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
    CONSTRAINT recipe_tag_map_tag_fk    FOREIGN KEY (tag_id)    REFERENCES tags    (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recipe_ingredients (
    id              BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id       BIGINT UNSIGNED   NOT NULL,
    line_number     SMALLINT UNSIGNED NOT NULL,  -- Thứ tự hiển thị
    ingredient_name VARCHAR(255)      NOT NULL, 
    quantity        DECIMAL(8,2)      NULL,
    unit            VARCHAR(50)       NULL,
    note            VARCHAR(255)      NULL,
    created_at      TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY recipe_ingredients_recipe_line_unique (recipe_id, line_number),
    CONSTRAINT recipe_ingredients_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recipe_steps (
    id              BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id       BIGINT UNSIGNED   NOT NULL,
    step_number     SMALLINT UNSIGNED NOT NULL,
    instruction     TEXT              NOT NULL,
    media_asset_id  BIGINT UNSIGNED   NULL,
    timer_seconds   INT UNSIGNED      NULL,
    created_at      TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY recipe_steps_recipe_step_unique (recipe_id, step_number),
    CONSTRAINT recipe_steps_recipe_fk FOREIGN KEY (recipe_id)      REFERENCES recipes      (id) ON DELETE CASCADE,
    CONSTRAINT recipe_steps_media_fk  FOREIGN KEY (media_asset_id) REFERENCES media_assets (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recipe_favorites (
    user_id     BIGINT UNSIGNED NOT NULL,
    recipe_id   BIGINT UNSIGNED NOT NULL,
    created_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, recipe_id),
    -- Index ngược để query "bài này có bao nhiêu lượt yêu thích"
    KEY recipe_favorites_recipe_idx (recipe_id),
    CONSTRAINT recipe_favorites_user_fk   FOREIGN KEY (user_id)   REFERENCES users   (id) ON DELETE CASCADE,
    CONSTRAINT recipe_favorites_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE recipe_reviews (
    id          BIGINT UNSIGNED  NOT NULL AUTO_INCREMENT PRIMARY KEY,
    recipe_id   BIGINT UNSIGNED  NOT NULL,
    user_id     BIGINT UNSIGNED  NOT NULL,
    rating      TINYINT UNSIGNED NOT NULL,
    title       VARCHAR(140)     NULL,
    body        TEXT             NULL,
    is_approved TINYINT          NOT NULL DEFAULT 0,
    created_at  TIMESTAMP        NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP        NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Mỗi user chỉ review 1 lần cho mỗi recipe
    UNIQUE KEY recipe_reviews_recipe_user_unique (recipe_id, user_id),
    -- Trang chi tiết chỉ lấy review đã duyệt: WHERE recipe_id = ? AND is_approved = 1
    KEY recipe_reviews_approved_idx (recipe_id, is_approved),
    CONSTRAINT recipe_reviews_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
    CONSTRAINT recipe_reviews_user_fk   FOREIGN KEY (user_id)   REFERENCES users   (id) ON DELETE CASCADE,
    CONSTRAINT recipe_reviews_rating_chk CHECK (rating BETWEEN 1 AND 5)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------------
-- 6. E-COMMERCE & ACCESS CONTROL
-- --------------------------------------------------------------------------

CREATE TABLE orders (
    id               BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_number     VARCHAR(30)     NOT NULL UNIQUE,
    user_id          BIGINT UNSIGNED NOT NULL,
    status           ENUM('pending', 'paid', 'failed', 'refunded', 'cancelled') NOT NULL DEFAULT 'pending',
    subtotal         BIGINT UNSIGNED NOT NULL,
    discount         BIGINT UNSIGNED NOT NULL DEFAULT 0,
    tax              BIGINT UNSIGNED NOT NULL DEFAULT 0,
    total            BIGINT UNSIGNED NOT NULL,
    currency         CHAR(3)         NOT NULL DEFAULT 'VND',
    payment_provider VARCHAR(50)     NOT NULL,
    paid_at          TIMESTAMP       NULL,
    failure_reason   VARCHAR(255)    NULL,
    created_at       TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at       TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    KEY orders_user_status_idx (user_id, status),
    CONSTRAINT orders_user_fk  FOREIGN KEY (user_id) REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT orders_total_chk CHECK (total = (subtotal - discount + tax))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE order_items (
    id          BIGINT UNSIGNED   NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id    BIGINT UNSIGNED   NOT NULL,
    recipe_id   BIGINT UNSIGNED   NOT NULL,
    unit_price  BIGINT UNSIGNED   NOT NULL,
    quantity    SMALLINT UNSIGNED NOT NULL DEFAULT 1,
    line_total  BIGINT UNSIGNED   GENERATED ALWAYS AS (unit_price * quantity) STORED,
    created_at  TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP         NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    -- Mỗi recipe chỉ xuất hiện 1 lần trong 1 đơn hàng
    UNIQUE KEY order_items_order_recipe_unique (order_id, recipe_id),
    CONSTRAINT order_items_order_fk  FOREIGN KEY (order_id)  REFERENCES orders  (id) ON DELETE CASCADE,
    CONSTRAINT order_items_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_transactions (
    id                      BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    order_id                BIGINT UNSIGNED NOT NULL,
    provider                VARCHAR(50)     NOT NULL,
    provider_transaction_id VARCHAR(191)    NOT NULL,
    type                    ENUM('authorization', 'capture', 'refund', 'void') NOT NULL DEFAULT 'capture',
    amount                  BIGINT UNSIGNED NOT NULL,
    currency                CHAR(3)         NOT NULL DEFAULT 'VND',
    status                  ENUM('pending', 'succeeded', 'failed')             NOT NULL DEFAULT 'pending',
    raw_payload             JSON            NULL,   -- Lưu toàn bộ response gốc từ cổng thanh toán
    processed_at            TIMESTAMP       NULL,
    created_at              TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at              TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY pt_provider_tx_unique (provider, provider_transaction_id, type),
    CONSTRAINT payment_transactions_order_fk FOREIGN KEY (order_id) REFERENCES orders (id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE user_recipe_access (
    -- Kiểm soát quyền xem công thức có phí
    -- Logic: user xem được nếu (access_type = 'free') HOẶC (có row trong bảng này)
    user_id     BIGINT UNSIGNED NOT NULL,
    recipe_id   BIGINT UNSIGNED NOT NULL,
    order_id    BIGINT UNSIGNED NULL,   -- NULL = owner cấp quyền thủ công
    granted_at  TIMESTAMP       NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, recipe_id),
    CONSTRAINT ura_user_fk   FOREIGN KEY (user_id)   REFERENCES users   (id) ON DELETE CASCADE,
    CONSTRAINT ura_recipe_fk FOREIGN KEY (recipe_id) REFERENCES recipes (id) ON DELETE CASCADE,
    CONSTRAINT ura_order_fk  FOREIGN KEY (order_id)  REFERENCES orders  (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------------
-- 7. CMS & SETTINGS
-- --------------------------------------------------------------------------

CREATE TABLE blog_posts (
    id              BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    author_id       BIGINT UNSIGNED NOT NULL,
    cover_media_id  BIGINT UNSIGNED NULL,
    title           VARCHAR(255)    NOT NULL,
    slug            VARCHAR(255)    NOT NULL UNIQUE,
    excerpt         TEXT            NULL,
    content         LONGTEXT        NOT NULL,
    is_published    TINYINT         NOT NULL DEFAULT 0,
    published_at    TIMESTAMP       NULL,
    created_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at      TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    deleted_at      TIMESTAMP       NULL,           -- Soft delete: lỡ xóa vẫn khôi phục được

    KEY blog_posts_deleted_at_idx (deleted_at),     -- Laravel luôn WHERE deleted_at IS NULL
    FULLTEXT KEY blog_posts_search_ft (title, excerpt),
    CONSTRAINT blog_posts_author_fk      FOREIGN KEY (author_id)      REFERENCES users        (id) ON DELETE RESTRICT,
    CONSTRAINT blog_posts_cover_media_fk FOREIGN KEY (cover_media_id) REFERENCES media_assets (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE pages (
    -- Trang tĩnh: About, Contact, Terms, ...
    id           BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
    slug         VARCHAR(255)    NOT NULL UNIQUE,
    title        VARCHAR(255)    NOT NULL,
    content      LONGTEXT        NOT NULL,
    is_published TINYINT         NOT NULL DEFAULT 0,
    created_at   TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at   TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE site_settings (
    `key`       VARCHAR(120)    NOT NULL PRIMARY KEY,
    `value`     JSON            NOT NULL,
    description VARCHAR(255)    NULL,
    updated_by  BIGINT UNSIGNED NULL,
    created_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at  TIMESTAMP       NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    CONSTRAINT site_settings_updated_by_fk FOREIGN KEY (updated_by) REFERENCES users (id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------------------------
-- 8. BOOTSTRAP SEED DATA
-- --------------------------------------------------------------------------


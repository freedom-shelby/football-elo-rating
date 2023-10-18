--
-- Скрипт сгенерирован Devart dbForge Studio for MySQL, Версия 8.0.40.0
-- Домашняя страница продукта: http://www.devart.com/ru/dbforge/mysql/studio
-- Дата скрипта: 23-Jul-18 5:27:01 PM
-- Версия сервера: 5.7.20
-- Версия клиента: 4.1
--

-- 
-- Отключение внешних ключей
-- 
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;

-- 
-- Установить режим SQL (SQL mode)
-- 
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- 
-- Установка кодировки, с использованием которой клиент будет посылать запросы на сервер
--
SET NAMES 'utf8';

DROP DATABASE IF EXISTS sunrise_football_elo;

CREATE DATABASE IF NOT EXISTS sunrise_football_elo
CHARACTER SET utf8
COLLATE utf8_general_ci;

--
-- Установка базы данных по умолчанию
--
USE sunrise_football_elo;

--
-- Создать таблицу `roles`
--
CREATE TABLE IF NOT EXISTS roles (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  display_name varchar(255) NOT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 3,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `roles_name_unique` для объекта типа таблица `roles`
--
ALTER TABLE roles
ADD UNIQUE INDEX roles_name_unique (name);

--
-- Создать таблицу `users`
--
CREATE TABLE IF NOT EXISTS users (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  role_id int(10) UNSIGNED DEFAULT NULL,
  name varchar(255) NOT NULL,
  email varchar(255) NOT NULL,
  avatar varchar(255) DEFAULT 'users/default.png',
  password varchar(255) NOT NULL,
  remember_token varchar(100) DEFAULT NULL,
  settings text DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `users_email_unique` для объекта типа таблица `users`
--
ALTER TABLE users
ADD UNIQUE INDEX users_email_unique (email);

--
-- Создать внешний ключ
--
ALTER TABLE users
ADD CONSTRAINT users_role_id_foreign FOREIGN KEY (role_id)
REFERENCES roles (id);

--
-- Создать таблицу `user_roles`
--
CREATE TABLE IF NOT EXISTS user_roles (
  user_id int(10) UNSIGNED NOT NULL,
  role_id int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (user_id, role_id)
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `user_roles_role_id_index` для объекта типа таблица `user_roles`
--
ALTER TABLE user_roles
ADD INDEX user_roles_role_id_index (role_id);

--
-- Создать индекс `user_roles_user_id_index` для объекта типа таблица `user_roles`
--
ALTER TABLE user_roles
ADD INDEX user_roles_user_id_index (user_id);

--
-- Создать внешний ключ
--
ALTER TABLE user_roles
ADD CONSTRAINT user_roles_role_id_foreign FOREIGN KEY (role_id)
REFERENCES roles (id) ON DELETE CASCADE;

--
-- Создать внешний ключ
--
ALTER TABLE user_roles
ADD CONSTRAINT user_roles_user_id_foreign FOREIGN KEY (user_id)
REFERENCES users (id) ON DELETE CASCADE;

--
-- Создать таблицу `tournaments`
--
CREATE TABLE IF NOT EXISTS tournaments (
  id int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(50) DEFAULT NULL,
  slug varchar(255) DEFAULT NULL,
  is_active tinyint(1) UNSIGNED DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
AVG_ROW_LENGTH = 16384,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `slug` для объекта типа таблица `tournaments`
--
ALTER TABLE tournaments
ADD UNIQUE INDEX slug (slug);

--
-- Создать таблицу `events`
--
CREATE TABLE IF NOT EXISTS events (
  id int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  result tinyint(1) DEFAULT NULL,
  slug varchar(255) DEFAULT NULL,
  trn_id int(11) UNSIGNED DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 13,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать внешний ключ
--
ALTER TABLE events
ADD CONSTRAINT FK_events_tournaments_id FOREIGN KEY (trn_id)
REFERENCES tournaments (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать таблицу `players`
--
CREATE TABLE IF NOT EXISTS players (
  id int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  slug varchar(50) DEFAULT NULL,
  name varchar(50) DEFAULT NULL,
  nick varchar(50) DEFAULT NULL,
  phone varchar(50) DEFAULT NULL,
  email varchar(50) DEFAULT NULL,
  rating int(11) DEFAULT 600,
  games int(11) UNSIGNED DEFAULT 0,
  won int(11) UNSIGNED DEFAULT 0,
  draw int(11) UNSIGNED DEFAULT 0,
  lost int(11) UNSIGNED DEFAULT 0,
  is_active tinyint(1) UNSIGNED DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 5,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8,
COLLATE utf8_general_ci;

--
-- Создать индекс `nick` для объекта типа таблица `players`
--
ALTER TABLE players
ADD UNIQUE INDEX nick (nick);

--
-- Создать индекс `phone` для объекта типа таблица `players`
--
ALTER TABLE players
ADD UNIQUE INDEX phone (phone);

--
-- Создать индекс `slug` для объекта типа таблица `players`
--
ALTER TABLE players
ADD UNIQUE INDEX slug (slug);

--
-- Создать индекс `slug_2` для объекта типа таблица `players`
--
ALTER TABLE players
ADD UNIQUE INDEX slug_2 (slug);

--
-- Создать таблицу `players_events`
--
CREATE TABLE IF NOT EXISTS players_events (
  id int(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  p_id int(11) UNSIGNED DEFAULT NULL,
  e_id int(11) UNSIGNED DEFAULT NULL,
  shift int(5) DEFAULT NULL,
  result tinyint(1) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
CHARACTER SET utf8,
COLLATE utf8_general_ci,
COMMENT = 'result  -1 = loss
result   0 = draw
result   1 = win';

--
-- Создать внешний ключ
--
ALTER TABLE players_events
ADD CONSTRAINT FK_players_events_events_id FOREIGN KEY (e_id)
REFERENCES events (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать внешний ключ
--
ALTER TABLE players_events
ADD CONSTRAINT FK_players_events_players_id FOREIGN KEY (p_id)
REFERENCES players (id) ON DELETE NO ACTION ON UPDATE NO ACTION;

--
-- Создать таблицу `permissions`
--
CREATE TABLE IF NOT EXISTS permissions (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  table_name varchar(255) DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 112,
AVG_ROW_LENGTH = 195,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `permissions_key_index` для объекта типа таблица `permissions`
--
ALTER TABLE permissions
ADD INDEX permissions_key_index (`key`);

--
-- Создать таблицу `permission_role`
--
CREATE TABLE IF NOT EXISTS permission_role (
  permission_id int(10) UNSIGNED NOT NULL,
  role_id int(10) UNSIGNED NOT NULL,
  PRIMARY KEY (permission_id, role_id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 202,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `permission_role_permission_id_index` для объекта типа таблица `permission_role`
--
ALTER TABLE permission_role
ADD INDEX permission_role_permission_id_index (permission_id);

--
-- Создать индекс `permission_role_role_id_index` для объекта типа таблица `permission_role`
--
ALTER TABLE permission_role
ADD INDEX permission_role_role_id_index (role_id);

--
-- Создать внешний ключ
--
ALTER TABLE permission_role
ADD CONSTRAINT permission_role_permission_id_foreign FOREIGN KEY (permission_id)
REFERENCES permissions (id) ON DELETE CASCADE;

--
-- Создать внешний ключ
--
ALTER TABLE permission_role
ADD CONSTRAINT permission_role_role_id_foreign FOREIGN KEY (role_id)
REFERENCES roles (id) ON DELETE CASCADE;

--
-- Создать таблицу `menus`
--
CREATE TABLE IF NOT EXISTS menus (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `menus_name_unique` для объекта типа таблица `menus`
--
ALTER TABLE menus
ADD UNIQUE INDEX menus_name_unique (name);

--
-- Создать таблицу `menu_items`
--
CREATE TABLE IF NOT EXISTS menu_items (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  menu_id int(10) UNSIGNED DEFAULT NULL,
  title varchar(255) NOT NULL,
  url varchar(255) NOT NULL,
  target varchar(255) NOT NULL DEFAULT '_self',
  icon_class varchar(255) DEFAULT NULL,
  color varchar(255) DEFAULT NULL,
  parent_id int(11) DEFAULT NULL,
  `order` int(11) NOT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  route varchar(255) DEFAULT NULL,
  parameters text DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 28,
AVG_ROW_LENGTH = 780,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать внешний ключ
--
ALTER TABLE menu_items
ADD CONSTRAINT menu_items_menu_id_foreign FOREIGN KEY (menu_id)
REFERENCES menus (id) ON DELETE CASCADE;

--
-- Создать таблицу `data_types`
--
CREATE TABLE IF NOT EXISTS data_types (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  name varchar(255) NOT NULL,
  slug varchar(255) NOT NULL,
  display_name_singular varchar(255) NOT NULL,
  display_name_plural varchar(255) NOT NULL,
  icon varchar(255) DEFAULT NULL,
  model_name varchar(255) DEFAULT NULL,
  policy_name varchar(255) DEFAULT NULL,
  controller varchar(255) DEFAULT NULL,
  description varchar(255) DEFAULT NULL,
  generate_permissions tinyint(1) NOT NULL DEFAULT 0,
  server_side tinyint(4) NOT NULL DEFAULT 0,
  details text DEFAULT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 31,
AVG_ROW_LENGTH = 1260,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `data_types_name_unique` для объекта типа таблица `data_types`
--
ALTER TABLE data_types
ADD UNIQUE INDEX data_types_name_unique (name);

--
-- Создать индекс `data_types_slug_unique` для объекта типа таблица `data_types`
--
ALTER TABLE data_types
ADD UNIQUE INDEX data_types_slug_unique (slug);

--
-- Создать таблицу `data_rows`
--
CREATE TABLE IF NOT EXISTS data_rows (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  data_type_id int(10) UNSIGNED NOT NULL,
  field varchar(255) NOT NULL,
  type varchar(255) NOT NULL,
  display_name varchar(255) NOT NULL,
  required tinyint(1) NOT NULL DEFAULT 0,
  browse tinyint(1) NOT NULL DEFAULT 1,
  `read` tinyint(1) NOT NULL DEFAULT 1,
  edit tinyint(1) NOT NULL DEFAULT 1,
  `add` tinyint(1) NOT NULL DEFAULT 1,
  `delete` tinyint(1) NOT NULL DEFAULT 1,
  details text DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 235,
AVG_ROW_LENGTH = 111,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать внешний ключ
--
ALTER TABLE data_rows
ADD CONSTRAINT data_rows_data_type_id_foreign FOREIGN KEY (data_type_id)
REFERENCES data_types (id) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Создать таблицу `translations`
--
CREATE TABLE IF NOT EXISTS translations (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  table_name varchar(255) NOT NULL,
  column_name varchar(255) NOT NULL,
  foreign_key int(10) UNSIGNED NOT NULL,
  locale varchar(255) NOT NULL,
  value text NOT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 31,
AVG_ROW_LENGTH = 546,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `translations_table_name_column_name_foreign_key_locale_unique` для объекта типа таблица `translations`
--
ALTER TABLE translations
ADD UNIQUE INDEX translations_table_name_column_name_foreign_key_locale_unique (table_name, column_name, foreign_key, locale);

--
-- Создать таблицу `settings`
--
CREATE TABLE IF NOT EXISTS settings (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `key` varchar(255) NOT NULL,
  display_name varchar(255) NOT NULL,
  value text DEFAULT NULL,
  details text DEFAULT NULL,
  type varchar(255) NOT NULL,
  `order` int(11) NOT NULL DEFAULT 1,
  `group` varchar(255) DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 11,
AVG_ROW_LENGTH = 1489,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `settings_key_unique` для объекта типа таблица `settings`
--
ALTER TABLE settings
ADD UNIQUE INDEX settings_key_unique (`key`);

--
-- Создать таблицу `posts`
--
CREATE TABLE IF NOT EXISTS posts (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  author_id int(11) NOT NULL,
  category_id int(11) DEFAULT NULL,
  title varchar(255) NOT NULL,
  seo_title varchar(255) DEFAULT NULL,
  excerpt text DEFAULT NULL,
  body text NOT NULL,
  image varchar(255) DEFAULT NULL,
  slug varchar(255) NOT NULL,
  meta_description text DEFAULT NULL,
  meta_keywords text DEFAULT NULL,
  status enum ('PUBLISHED', 'DRAFT', 'PENDING') NOT NULL DEFAULT 'DRAFT',
  featured tinyint(1) NOT NULL DEFAULT 0,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 4096,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `posts_slug_unique` для объекта типа таблица `posts`
--
ALTER TABLE posts
ADD UNIQUE INDEX posts_slug_unique (slug);

--
-- Создать таблицу `password_resets`
--
CREATE TABLE IF NOT EXISTS password_resets (
  email varchar(255) NOT NULL,
  token varchar(255) NOT NULL,
  created_at timestamp NULL DEFAULT NULL
)
ENGINE = INNODB,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `password_resets_email_index` для объекта типа таблица `password_resets`
--
ALTER TABLE password_resets
ADD INDEX password_resets_email_index (email);

--
-- Создать таблицу `pages`
--
CREATE TABLE IF NOT EXISTS pages (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  author_id int(11) NOT NULL,
  title varchar(255) NOT NULL,
  excerpt text DEFAULT NULL,
  body text DEFAULT NULL,
  image varchar(255) DEFAULT NULL,
  slug varchar(255) NOT NULL,
  meta_description text DEFAULT NULL,
  meta_keywords text DEFAULT NULL,
  status enum ('ACTIVE', 'INACTIVE') NOT NULL DEFAULT 'INACTIVE',
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 2,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `pages_slug_unique` для объекта типа таблица `pages`
--
ALTER TABLE pages
ADD UNIQUE INDEX pages_slug_unique (slug);

--
-- Создать таблицу `migrations`
--
CREATE TABLE IF NOT EXISTS migrations (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  migration varchar(255) NOT NULL,
  batch int(11) NOT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AUTO_INCREMENT = 27,
AVG_ROW_LENGTH = 630,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать таблицу `categories`
--
CREATE TABLE IF NOT EXISTS categories (
  id int(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  parent_id int(10) UNSIGNED DEFAULT NULL,
  `order` int(11) NOT NULL DEFAULT 1,
  name varchar(255) NOT NULL,
  slug varchar(255) NOT NULL,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
)
ENGINE = INNODB,
AVG_ROW_LENGTH = 8192,
CHARACTER SET utf8mb4,
COLLATE utf8mb4_unicode_ci;

--
-- Создать индекс `categories_slug_unique` для объекта типа таблица `categories`
--
ALTER TABLE categories
ADD UNIQUE INDEX categories_slug_unique (slug);

--
-- Создать внешний ключ
--
ALTER TABLE categories
ADD CONSTRAINT categories_parent_id_foreign FOREIGN KEY (parent_id)
REFERENCES categories (id) ON DELETE SET NULL ON UPDATE CASCADE;

-- 
-- Вывод данных для таблицы roles
--
INSERT INTO roles VALUES
(1, 'admin', 'Administrator', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(2, 'user', 'Normal User', '2018-06-12 07:10:46', '2018-06-12 07:10:46');

-- 
-- Вывод данных для таблицы tournaments
--
INSERT INTO tournaments VALUES
(1, 'PES2018', 'pes2018', 1, '2018-07-19 11:27:39', '2018-07-19 11:27:39');

-- 
-- Вывод данных для таблицы users
--
INSERT INTO users VALUES
(1, 1, 'Admin', 'arsen@horizondvp.com', 'users\\June2018\\1UnHpRRqkOOmjqEqQTpN.png', '$2y$10$HwT26tBngvcN/DEXYNVPiOWmq3Lzx060Sjz8URNEJSV8l282PF27W', 'tIWU5tl2WytawWiyA0042vH1OvuRIl9Awt4KibXBOT1Js2Nzr4BHsoI4l1eZ', '{"locale":"en"}', '2018-06-12 07:10:49', '2018-06-12 07:13:16');

-- 
-- Вывод данных для таблицы players
--
INSERT INTO players VALUES
(1, 'ArmSALArm', 'Arsen Hovhannisyan', 'ArmSALArm', '+37455064667', 'arsen.hovhannisyan.1991@gmail.com', 605, 8, 2, 5, 1, 1, '2018-07-19 10:39:00', '2018-07-23 13:02:14'),
(2, 'monte', 'Sargis Sulyan', 'Monte', '+37493077053', 'sargissulyan91@mail.ru', 587, 7, 1, 4, 2, 1, '2018-07-19 10:47:18', '2018-07-23 13:01:37'),
(3, 'tiro', 'Tirayr Sulyan', 'Tiro', '+37494224781', 'tirayrsulya93@mail.ru', 500, NULL, NULL, NULL, NULL, 1, '2018-07-19 10:49:26', '2018-07-19 10:49:26'),
(4, 'zak', 'Zakar Paskhalyan', 'Zak', '37477155712', 'zakarpaskhalyan91@mail.ru', 312, 1, NULL, 1, NULL, 1, '2018-07-19 10:50:54', '2018-07-23 13:02:14');

-- 
-- Вывод данных для таблицы events
--
-- Таблица sunrise_football_elo.events не содержит данных

-- 
-- Вывод данных для таблицы permissions
--
INSERT INTO permissions VALUES
(1, 'browse_admin', NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(2, 'browse_bread', NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(3, 'browse_database', NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(4, 'browse_media', NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(5, 'browse_compass', NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(6, 'browse_menus', 'menus', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(7, 'read_menus', 'menus', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(8, 'edit_menus', 'menus', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(9, 'add_menus', 'menus', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(10, 'delete_menus', 'menus', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(16, 'browse_users', 'users', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(17, 'read_users', 'users', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(18, 'edit_users', 'users', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(19, 'add_users', 'users', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(20, 'delete_users', 'users', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(21, 'browse_settings', 'settings', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(22, 'read_settings', 'settings', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(23, 'edit_settings', 'settings', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(24, 'add_settings', 'settings', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(25, 'delete_settings', 'settings', '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(26, 'browse_categories', 'categories', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(27, 'read_categories', 'categories', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(28, 'edit_categories', 'categories', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(29, 'add_categories', 'categories', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(30, 'delete_categories', 'categories', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(31, 'browse_posts', 'posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(32, 'read_posts', 'posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(33, 'edit_posts', 'posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(34, 'add_posts', 'posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(35, 'delete_posts', 'posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(36, 'browse_pages', 'pages', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(37, 'read_pages', 'pages', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(38, 'edit_pages', 'pages', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(39, 'add_pages', 'pages', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(40, 'delete_pages', 'pages', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(41, 'browse_hooks', NULL, '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(52, 'browse_api-users', 'api-users', '2018-06-21 13:16:02', '2018-06-21 13:16:02'),
(53, 'read_api-users', 'api-users', '2018-06-21 13:16:02', '2018-06-21 13:16:02'),
(54, 'edit_api-users', 'api-users', '2018-06-21 13:16:02', '2018-06-21 13:16:02'),
(55, 'add_api-users', 'api-users', '2018-06-21 13:16:02', '2018-06-21 13:16:02'),
(56, 'delete_api-users', 'api-users', '2018-06-21 13:16:02', '2018-06-21 13:16:02'),
(72, 'browse_api_settings', 'api_settings', '2018-06-22 09:05:16', '2018-06-22 09:05:16'),
(73, 'read_api_settings', 'api_settings', '2018-06-22 09:05:16', '2018-06-22 09:05:16'),
(74, 'edit_api_settings', 'api_settings', '2018-06-22 09:05:16', '2018-06-22 09:05:16'),
(75, 'add_api_settings', 'api_settings', '2018-06-22 09:05:16', '2018-06-22 09:05:16'),
(76, 'delete_api_settings', 'api_settings', '2018-06-22 09:05:16', '2018-06-22 09:05:16'),
(97, 'browse_players', 'players', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(98, 'read_players', 'players', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(99, 'edit_players', 'players', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(100, 'add_players', 'players', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(101, 'delete_players', 'players', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(102, 'browse_tournaments', 'tournaments', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(103, 'read_tournaments', 'tournaments', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(104, 'edit_tournaments', 'tournaments', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(105, 'add_tournaments', 'tournaments', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(106, 'delete_tournaments', 'tournaments', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(107, 'browse_events', 'events', '2018-07-19 11:21:19', '2018-07-19 11:21:19'),
(108, 'read_events', 'events', '2018-07-19 11:21:19', '2018-07-19 11:21:19'),
(109, 'edit_events', 'events', '2018-07-19 11:21:19', '2018-07-19 11:21:19'),
(110, 'add_events', 'events', '2018-07-19 11:21:19', '2018-07-19 11:21:19'),
(111, 'delete_events', 'events', '2018-07-19 11:21:19', '2018-07-19 11:21:19');

-- 
-- Вывод данных для таблицы menus
--
INSERT INTO menus VALUES
(1, 'admin', '2018-06-12 07:10:46', '2018-06-12 07:10:46');

-- 
-- Вывод данных для таблицы data_types
--
INSERT INTO data_types VALUES
(1, 'users', 'users', 'User', 'Users', 'voyager-person', 'TCG\\Voyager\\Models\\User', 'TCG\\Voyager\\Policies\\UserPolicy', '', '', 1, 0, NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(2, 'menus', 'menus', 'Menu', 'Menus', 'voyager-list', 'TCG\\Voyager\\Models\\Menu', NULL, '', '', 1, 0, NULL, '2018-06-12 07:10:46', '2018-06-12 07:10:46'),
(4, 'categories', 'categories', 'Category', 'Categories', 'voyager-categories', 'TCG\\Voyager\\Models\\Category', NULL, '', '', 1, 0, NULL, '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(5, 'posts', 'posts', 'Post', 'Posts', 'voyager-news', 'TCG\\Voyager\\Models\\Post', 'TCG\\Voyager\\Policies\\PostPolicy', '', '', 1, 0, NULL, '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(6, 'pages', 'pages', 'Page', 'Pages', 'voyager-file-text', 'TCG\\Voyager\\Models\\Page', NULL, NULL, NULL, 1, 0, '{"order_column":null,"order_display_column":null}', '2018-06-12 07:10:49', '2018-06-19 06:54:28'),
(28, 'players', 'players', 'Player', 'Players', NULL, 'App\\Models\\Player', NULL, NULL, NULL, 1, 0, '{"order_column":null,"order_display_column":null}', '2018-07-19 10:35:20', '2018-07-19 10:35:20'),
(29, 'tournaments', 'tournaments', 'Tournament', 'Tournaments', NULL, 'App\\Models\\Tournament', NULL, NULL, NULL, 1, 0, '{"order_column":null,"order_display_column":null}', '2018-07-19 10:55:33', '2018-07-19 10:55:33'),
(30, 'events', 'events', 'Event', 'Events', NULL, 'App\\Models\\Event', NULL, 'Admin\\EventController', NULL, 1, 0, '{"order_column":null,"order_display_column":null}', '2018-07-19 11:21:19', '2018-07-19 11:25:26');

-- 
-- Вывод данных для таблицы user_roles
--
-- Таблица sunrise_football_elo.user_roles не содержит данных

-- 
-- Вывод данных для таблицы translations
--
INSERT INTO translations VALUES
(1, 'data_types', 'display_name_singular', 5, 'pt', 'Post', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(2, 'data_types', 'display_name_singular', 6, 'pt', 'Página', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(3, 'data_types', 'display_name_singular', 1, 'pt', 'Utilizador', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(4, 'data_types', 'display_name_singular', 4, 'pt', 'Categoria', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(5, 'data_types', 'display_name_singular', 2, 'pt', 'Menu', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(6, 'data_types', 'display_name_singular', 3, 'pt', 'Função', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(7, 'data_types', 'display_name_plural', 5, 'pt', 'Posts', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(8, 'data_types', 'display_name_plural', 6, 'pt', 'Páginas', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(9, 'data_types', 'display_name_plural', 1, 'pt', 'Utilizadores', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(10, 'data_types', 'display_name_plural', 4, 'pt', 'Categorias', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(11, 'data_types', 'display_name_plural', 2, 'pt', 'Menus', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(12, 'data_types', 'display_name_plural', 3, 'pt', 'Funções', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(13, 'categories', 'slug', 1, 'pt', 'categoria-1', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(14, 'categories', 'name', 1, 'pt', 'Categoria 1', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(15, 'categories', 'slug', 2, 'pt', 'categoria-2', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(16, 'categories', 'name', 2, 'pt', 'Categoria 2', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(17, 'pages', 'title', 1, 'pt', 'Olá Mundo', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(18, 'pages', 'slug', 1, 'pt', 'ola-mundo', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(19, 'pages', 'body', 1, 'pt', '<p>Olá Mundo. Scallywag grog swab Cat o''nine tails scuttle rigging hardtack cable nipper Yellow Jack. Handsomely spirits knave lad killick landlubber or just lubber deadlights chantey pinnace crack Jennys tea cup. Provost long clothes black spot Yellow Jack bilged on her anchor league lateen sail case shot lee tackle.</p>\r\n<p>Ballast spirits fluke topmast me quarterdeck schooner landlubber or just lubber gabion belaying pin. Pinnace stern galleon starboard warp carouser to go on account dance the hempen jig jolly boat measured fer yer chains. Man-of-war fire in the hole nipperkin handsomely doubloon barkadeer Brethren of the Coast gibbet driver squiffy.</p>', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(20, 'menu_items', 'title', 1, 'pt', 'Painel de Controle', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(21, 'menu_items', 'title', 2, 'pt', 'Media', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(22, 'menu_items', 'title', 12, 'pt', 'Publicações', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(23, 'menu_items', 'title', 3, 'pt', 'Utilizadores', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(24, 'menu_items', 'title', 11, 'pt', 'Categorias', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(25, 'menu_items', 'title', 13, 'pt', 'Páginas', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(26, 'menu_items', 'title', 4, 'pt', 'Funções', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(27, 'menu_items', 'title', 5, 'pt', 'Ferramentas', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(28, 'menu_items', 'title', 6, 'pt', 'Menus', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(29, 'menu_items', 'title', 7, 'pt', 'Base de dados', '2018-06-12 07:10:49', '2018-06-12 07:10:49'),
(30, 'menu_items', 'title', 10, 'pt', 'Configurações', '2018-06-12 07:10:49', '2018-06-12 07:10:49');

-- 
-- Вывод данных для таблицы settings
--
INSERT INTO settings VALUES
(1, 'site.title', 'Site Title', NULL, '', 'text', 1, NULL),
(2, 'site.description', 'Site Description', NULL, '', 'text', 2, NULL),
(3, 'site.logo', 'Site Logo', 'settings\\June2018\\eEpz25lfCjf7hozqCR2o.png', '', 'image', 3, 'Site'),
(4, 'site.google_analytics_tracking_id', 'Google Analytics Tracking ID', NULL, '', 'text', 4, NULL),
(5, 'admin.bg_image', 'Admin Background Image', '', '', 'image', 5, 'Admin'),
(6, 'admin.title', 'Admin Title', 'PickPac', '', 'text', 1, 'Admin'),
(7, 'admin.description', 'Admin Description', 'Welcome to PickPac Admin Panel', '', 'text', 2, 'Admin'),
(8, 'admin.loader', 'Admin Loader', '', '', 'image', 3, 'Admin'),
(9, 'admin.icon_image', 'Admin Icon Image', 'settings\\June2018\\tWeGuOtETl00s6DTyufq.png', '', 'image', 4, 'Admin'),
(10, 'admin.google_analytics_client_id', 'Google Analytics Client ID (used for admin dashboard)', NULL, '', 'text', 1, 'Admin');

-- 
-- Вывод данных для таблицы posts
--
-- Таблица sunrise_football_elo.posts не содержит данных

-- 
-- Вывод данных для таблицы players_events
--
-- Таблица sunrise_football_elo.players_events не содержит данных

-- 
-- Вывод данных для таблицы permission_role
--
INSERT INTO permission_role VALUES
(1, 1),
(2, 1),
(3, 1),
(4, 1),
(5, 1),
(6, 1),
(7, 1),
(8, 1),
(9, 1),
(10, 1),
(16, 1),
(17, 1),
(18, 1),
(19, 1),
(20, 1),
(21, 1),
(22, 1),
(23, 1),
(24, 1),
(25, 1),
(26, 1),
(27, 1),
(28, 1),
(29, 1),
(30, 1),
(31, 1),
(32, 1),
(33, 1),
(34, 1),
(35, 1),
(36, 1),
(37, 1),
(38, 1),
(39, 1),
(40, 1),
(41, 1),
(52, 1),
(53, 1),
(54, 1),
(55, 1),
(56, 1),
(72, 1),
(73, 1),
(74, 1),
(75, 1),
(76, 1),
(97, 1),
(98, 1),
(99, 1),
(100, 1),
(101, 1),
(102, 1),
(103, 1),
(104, 1),
(105, 1),
(106, 1),
(107, 1),
(108, 1),
(109, 1),
(110, 1),
(111, 1);

-- 
-- Вывод данных для таблицы password_resets
--
-- Таблица sunrise_football_elo.password_resets не содержит данных

-- 
-- Вывод данных для таблицы pages
--
INSERT INTO pages VALUES
(1, 0, 'Hello World', 'Hang the jib grog grog blossom grapple dance the hempen jig gangway pressgang bilge rat to go on account lugger. Nelsons folly gabion line draught scallywag fire ship gaff fluke fathom case shot. Sea Legs bilge rat sloop matey gabion long clothes run a shot across the bow Gold Road cog league.', '<p>Hello World. Scallywag grog swab Cat o''nine tails scuttle rigging hardtack cable nipper Yellow Jack. Handsomely spirits knave lad killick landlubber or just lubber deadlights chantey pinnace crack Jennys tea cup. Provost long clothes black spot Yellow Jack bilged on her anchor league lateen sail case shot lee tackle.</p>\n<p>Ballast spirits fluke topmast me quarterdeck schooner landlubber or just lubber gabion belaying pin. Pinnace stern galleon starboard warp carouser to go on account dance the hempen jig jolly boat measured fer yer chains. Man-of-war fire in the hole nipperkin handsomely doubloon barkadeer Brethren of the Coast gibbet driver squiffy.</p>', 'pages/page1.jpg', 'hello-world', 'Yar Meta Description', 'Keyword1, Keyword2', 'ACTIVE', '2018-06-12 07:10:49', '2018-06-12 07:10:49');

-- 
-- Вывод данных для таблицы migrations
--
INSERT INTO migrations VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_resets_table', 1),
(3, '2016_01_01_000000_add_voyager_user_fields', 1),
(4, '2016_01_01_000000_create_data_types_table', 1),
(5, '2016_05_19_173453_create_menu_table', 1),
(6, '2016_10_21_190000_create_roles_table', 1),
(7, '2016_10_21_190000_create_settings_table', 1),
(8, '2016_11_30_135954_create_permission_table', 1),
(9, '2016_11_30_141208_create_permission_role_table', 1),
(10, '2016_12_26_201236_data_types__add__server_side', 1),
(11, '2017_01_13_000000_add_route_to_menu_items_table', 1),
(12, '2017_01_14_005015_create_translations_table', 1),
(13, '2017_01_15_000000_make_table_name_nullable_in_permissions_table', 1),
(14, '2017_03_06_000000_add_controller_to_data_types_table', 1),
(15, '2017_04_21_000000_add_order_to_data_rows_table', 1),
(16, '2017_07_05_210000_add_policyname_to_data_types_table', 1),
(17, '2017_08_05_000000_add_group_to_settings_table', 1),
(18, '2017_11_26_013050_add_user_role_relationship', 1),
(19, '2017_11_26_015000_create_user_roles_table', 1),
(20, '2018_03_11_000000_add_user_settings', 1),
(21, '2018_03_14_000000_add_details_to_data_types_table', 1),
(22, '2018_03_16_000000_make_settings_value_nullable', 1),
(23, '2016_01_01_000000_create_pages_table', 2),
(24, '2016_01_01_000000_create_posts_table', 2),
(25, '2016_02_15_204651_create_categories_table', 2),
(26, '2017_04_11_000000_alter_post_nullable_fields_table', 2);

-- 
-- Вывод данных для таблицы menu_items
--
INSERT INTO menu_items VALUES
(1, 1, 'Dashboard', '', '_self', 'voyager-boat', NULL, NULL, 1, '2018-06-12 07:10:46', '2018-06-12 07:10:46', 'voyager.dashboard', NULL),
(2, 1, 'Media', '', '_self', 'voyager-images', NULL, 5, 2, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.media.index', NULL),
(3, 1, 'Users', '', '_self', 'voyager-person', NULL, 5, 4, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.users.index', NULL),
(4, 1, 'Roles', '', '_self', 'voyager-lock', NULL, 5, 3, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.roles.index', NULL),
(5, 1, 'Tools', '', '_self', 'voyager-tools', NULL, NULL, 5, '2018-06-12 07:10:46', '2018-07-19 11:21:44', NULL, NULL),
(6, 1, 'Menu Builder', '', '_self', 'voyager-list', NULL, 5, 5, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.menus.index', NULL),
(7, 1, 'Database', '', '_self', 'voyager-data', NULL, 5, 6, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.database.index', NULL),
(8, 1, 'Compass', '', '_self', 'voyager-compass', NULL, 5, 7, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.compass.index', NULL),
(9, 1, 'BREAD', '', '_self', 'voyager-bread', NULL, 5, 8, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.bread.index', NULL),
(10, 1, 'Settings', '', '_self', 'voyager-settings', NULL, 5, 1, '2018-06-12 07:10:46', '2018-07-18 12:39:30', 'voyager.settings.index', NULL),
(14, 1, 'Hooks', '', '_self', 'voyager-hook', NULL, 5, 9, '2018-06-12 07:10:49', '2018-07-18 12:39:30', 'voyager.hooks', NULL),
(25, 1, 'Players', '', '_self', 'voyager-people', '#000000', NULL, 2, '2018-07-19 10:35:20', '2018-07-19 10:36:15', 'voyager.players.index', 'null'),
(26, 1, 'Tournaments', '', '_self', 'voyager-medal-rank-star', '#000000', NULL, 4, '2018-07-19 10:55:33', '2018-07-19 11:23:22', 'voyager.tournaments.index', 'null'),
(27, 1, 'Events', '', '_self', 'voyager-pirate-swords', '#000000', NULL, 3, '2018-07-19 11:21:19', '2018-07-19 11:24:41', 'voyager.events.index', 'null');

-- 
-- Вывод данных для таблицы data_rows
--
INSERT INTO data_rows VALUES
(1, 1, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, '', 1),
(2, 1, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '', 2),
(3, 1, 'email', 'text', 'Email', 1, 1, 1, 1, 1, 1, '', 3),
(4, 1, 'password', 'password', 'Password', 1, 0, 0, 1, 1, 0, '', 4),
(5, 1, 'remember_token', 'text', 'Remember Token', 0, 0, 0, 0, 0, 0, '', 5),
(6, 1, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 0, 0, 0, '', 6),
(7, 1, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '', 7),
(8, 1, 'avatar', 'image', 'Avatar', 0, 1, 1, 1, 1, 1, '', 8),
(9, 1, 'user_belongsto_role_relationship', 'relationship', 'Role', 0, 1, 1, 1, 1, 0, '{"model":"TCG\\\\Voyager\\\\Models\\\\Role","table":"roles","type":"belongsTo","column":"role_id","key":"id","label":"display_name","pivot_table":"roles","pivot":"0"}', 10),
(10, 1, 'user_belongstomany_role_relationship', 'relationship', 'Roles', 0, 1, 1, 1, 1, 0, '{"model":"TCG\\\\Voyager\\\\Models\\\\Role","table":"roles","type":"belongsToMany","column":"id","key":"id","label":"display_name","pivot_table":"user_roles","pivot":"1","taggable":"0"}', 11),
(11, 1, 'locale', 'text', 'Locale', 0, 1, 1, 1, 1, 0, '', 12),
(12, 1, 'settings', 'hidden', 'Settings', 0, 0, 0, 0, 0, 0, '', 12),
(13, 2, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, '', 1),
(14, 2, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '', 2),
(15, 2, 'created_at', 'timestamp', 'Created At', 0, 0, 0, 0, 0, 0, '', 3),
(16, 2, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '', 4),
(22, 1, 'role_id', 'text', 'Role', 1, 1, 1, 1, 1, 1, '', 9),
(23, 4, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, '', 1),
(24, 4, 'parent_id', 'select_dropdown', 'Parent', 0, 0, 1, 1, 1, 1, '{"default":"","null":"","options":{"":"-- None --"},"relationship":{"key":"id","label":"name"}}', 2),
(25, 4, 'order', 'text', 'Order', 1, 1, 1, 1, 1, 1, '{"default":1}', 3),
(26, 4, 'name', 'text', 'Name', 1, 1, 1, 1, 1, 1, '', 4),
(27, 4, 'slug', 'text', 'Slug', 1, 1, 1, 1, 1, 1, '{"slugify":{"origin":"name"}}', 5),
(28, 4, 'created_at', 'timestamp', 'Created At', 0, 0, 1, 0, 0, 0, '', 6),
(29, 4, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '', 7),
(30, 5, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, '', 1),
(31, 5, 'author_id', 'text', 'Author', 1, 0, 1, 1, 0, 1, '', 2),
(32, 5, 'category_id', 'text', 'Category', 1, 0, 1, 1, 1, 0, '', 3),
(33, 5, 'title', 'text', 'Title', 1, 1, 1, 1, 1, 1, '', 4),
(34, 5, 'excerpt', 'text_area', 'Excerpt', 1, 0, 1, 1, 1, 1, '', 5),
(35, 5, 'body', 'rich_text_box', 'Body', 1, 0, 1, 1, 1, 1, '', 6),
(36, 5, 'image', 'image', 'Post Image', 0, 1, 1, 1, 1, 1, '{"resize":{"width":"1000","height":"null"},"quality":"70%","upsize":true,"thumbnails":[{"name":"medium","scale":"50%"},{"name":"small","scale":"25%"},{"name":"cropped","crop":{"width":"300","height":"250"}}]}', 7),
(37, 5, 'slug', 'text', 'Slug', 1, 0, 1, 1, 1, 1, '{"slugify":{"origin":"title","forceUpdate":true},"validation":{"rule":"unique:posts,slug"}}', 8),
(38, 5, 'meta_description', 'text_area', 'Meta Description', 1, 0, 1, 1, 1, 1, '', 9),
(39, 5, 'meta_keywords', 'text_area', 'Meta Keywords', 1, 0, 1, 1, 1, 1, '', 10),
(40, 5, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{"default":"DRAFT","options":{"PUBLISHED":"published","DRAFT":"draft","PENDING":"pending"}}', 11),
(41, 5, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 0, 0, 0, '', 12),
(42, 5, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, '', 13),
(43, 5, 'seo_title', 'text', 'SEO Title', 0, 1, 1, 1, 1, 1, '', 14),
(44, 5, 'featured', 'checkbox', 'Featured', 1, 1, 1, 1, 1, 1, '', 15),
(45, 6, 'id', 'number', 'ID', 1, 0, 0, 0, 0, 0, NULL, 1),
(46, 6, 'author_id', 'text', 'Author', 1, 0, 0, 0, 0, 0, NULL, 2),
(47, 6, 'title', 'text', 'Title', 1, 1, 1, 1, 1, 1, NULL, 3),
(48, 6, 'excerpt', 'text_area', 'Excerpt', 0, 0, 1, 1, 1, 1, NULL, 4),
(49, 6, 'body', 'rich_text_box', 'Body', 0, 0, 1, 1, 1, 1, NULL, 5),
(50, 6, 'slug', 'text', 'Slug', 1, 0, 1, 1, 1, 1, '{"slugify":{"origin":"title"},"validation":{"rule":"unique:pages,slug"}}', 6),
(51, 6, 'meta_description', 'text', 'Meta Description', 0, 0, 1, 1, 1, 1, NULL, 7),
(52, 6, 'meta_keywords', 'text', 'Meta Keywords', 0, 0, 1, 1, 1, 1, NULL, 8),
(53, 6, 'status', 'select_dropdown', 'Status', 1, 1, 1, 1, 1, 1, '{"default":0,"options":{"0":"Pending","1":"Completed","2":"To Pickup","3":"To Delivery","4":"Deadline Passed","5":"Aborted","6":"Did''n come","7":"Not Rated"}}', 9),
(54, 6, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 0, 0, 0, NULL, 10),
(55, 6, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, NULL, 11),
(56, 6, 'image', 'image', 'Page Image', 0, 1, 1, 1, 1, 1, NULL, 12),
(201, 28, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, NULL, 1),
(202, 28, 'name', 'text', 'Name', 0, 1, 1, 1, 1, 1, NULL, 2),
(203, 28, 'nick', 'text', 'Nick', 0, 1, 1, 1, 1, 1, NULL, 3),
(204, 28, 'phone', 'text', 'Phone', 0, 1, 1, 1, 1, 1, NULL, 4),
(205, 28, 'email', 'text', 'Email', 0, 1, 1, 1, 1, 1, NULL, 5),
(206, 28, 'rating', 'number', 'Rating', 0, 1, 1, 1, 1, 1, NULL, 6),
(207, 28, 'games', 'number', 'Games', 0, 1, 1, 1, 1, 1, NULL, 7),
(212, 28, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, NULL, 12),
(213, 28, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, NULL, 13),
(214, 28, 'slug', 'text', 'Slug', 0, 1, 1, 1, 1, 1, '{"slugify":{"origin":"nick"},"validation":{"rule":"unique:players,slug"}}', 2),
(215, 28, 'is_active', 'select_dropdown', 'Is Active', 0, 1, 1, 1, 1, 1, '{"default":1,"options":{"0":"Inactive","1":"Active"}}', 12),
(216, 29, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, NULL, 1),
(217, 29, 'name', 'text', 'Name', 0, 1, 1, 1, 1, 1, NULL, 2),
(218, 29, 'slug', 'text', 'Slug', 0, 1, 1, 1, 1, 1, '{"slugify":{"origin":"name"},"validation":{"rule":"unique:tournaments,slug"}}', 3),
(219, 29, 'is_active', 'select_dropdown', 'Is Active', 0, 1, 1, 1, 1, 1, '{"default":1,"options":{"0":"Inactive","1":"Active"}}', 4),
(220, 29, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, NULL, 5),
(221, 29, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, NULL, 6),
(222, 30, 'id', 'text', 'Id', 1, 0, 0, 0, 0, 0, NULL, 1),
(224, 30, 'slug', 'text', 'Slug', 0, 1, 1, 1, 1, 1, NULL, 7),
(225, 30, 'trn_id', 'text', 'Tournament', 0, 0, 0, 0, 0, 0, NULL, 5),
(226, 30, 'created_at', 'timestamp', 'Created At', 0, 1, 1, 1, 0, 1, NULL, 8),
(227, 30, 'updated_at', 'timestamp', 'Updated At', 0, 0, 0, 0, 0, 0, NULL, 9),
(228, 28, 'won', 'number', 'Won', 0, 1, 1, 1, 1, 1, NULL, 9),
(229, 28, 'draw', 'number', 'Draw', 0, 1, 1, 1, 1, 1, NULL, 10),
(230, 28, 'lost', 'number', 'Lost', 0, 1, 1, 1, 1, 1, NULL, 11),
(231, 30, 'event_belongsto_tournament_relationship', 'relationship', 'Tournament', 0, 1, 1, 1, 1, 1, '{"model":"App\\\\Models\\\\Tournament","table":"tournaments","type":"belongsTo","column":"trn_id","key":"id","label":"name","pivot_table":"categories","pivot":"0","taggable":"0"}', 2),
(232, 30, 'event_hasmany_players_event_relationship', 'relationship', 'Player 1', 0, 1, 1, 0, 0, 0, '{"model":"App\\\\Models\\\\PlayerEvent","table":"players_events","type":"hasMany","column":"p_id","key":"p_id","label":"p_id","pivot_table":"categories","pivot":"0","taggable":"0"}', 3),
(233, 30, 'event_hasone_players_event_relationship', 'relationship', 'Player 2', 0, 1, 1, 0, 0, 0, '{"model":"App\\\\Models\\\\PlayerEvent","table":"players_events","type":"hasMany","column":"p_id","key":"p_id","label":"p_id","pivot_table":"categories","pivot":"0","taggable":"0"}', 4),
(234, 30, 'result', 'select_dropdown', 'Result', 0, 1, 1, 1, 1, 1, '{"default":0,"options":{"0":"Draw","1":"Player 1 Win","2":"Player 2 Win"}}', 3);

-- 
-- Вывод данных для таблицы categories
--
-- Таблица sunrise_football_elo.categories не содержит данных

-- 
-- Восстановить предыдущий режим SQL (SQL mode)
-- 
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;

-- 
-- Включение внешних ключей
-- 
/*!40014 SET FOREIGN_KEY_CHECKS = @OLD_FOREIGN_KEY_CHECKS */;
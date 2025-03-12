FROM php:8.2-cli

# نصب اکستنشن‌های مورد نیاز
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    && docker-php-ext-install zip pdo pdo_mysql

# نصب Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# تنظیم مسیر کار
WORKDIR /var/www/html

# کپی فایل‌های پروژه
COPY . .

# نصب Laravel و NativePHP
RUN composer install --no-interaction --prefer-dist
RUN php artisan native:init

# تنظیم دسترسی‌ها
RUN chmod -R 777 storage bootstrap/cache

# ساخت فایل اجرایی (exe)
RUN php artisan native:build --windows

# اجرای برنامه
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]

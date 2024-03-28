# ビルドステージ
FROM php:8.2-fpm-alpine as builder

# 必要なパッケージと拡張機能のインストール
RUN apk add --no-cache --virtual .build-deps \
        icu-dev \
        zlib-dev \
        jpeg-dev \
        g++ \
        make \
        automake \
        autoconf \
        libzip-dev \
        imagemagick-dev \
        libpng-dev \
        libwebp-dev \
        libjpeg-turbo-dev \
        freetype-dev && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg --with-webp && \
    pecl install imagick && \
    docker-php-ext-install pdo pdo_mysql gd intl opcache exif zip && \
    docker-php-ext-enable imagick && \
    docker-php-ext-install gd

# Composerのインストール
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Laravelアプリケーションのコピーと依存関係のインストール
WORKDIR /var/www
COPY ./backend /var/www
RUN composer install --no-dev --optimize-autoloader && \
    php artisan config:cache && \
    php artisan route:cache && \
    php artisan view:cache

# 本番ステージ
FROM php:8.2-fpm-alpine as production

# ビルドステージから必要なファイルのコピー
COPY --from=builder /var/www /var/www
COPY --from=builder /usr/local/etc/php/conf.d /usr/local/etc/php/conf.d
COPY --from=builder /usr/local/lib/php/extensions /usr/local/lib/php/extensions
COPY --from=builder /usr/local/bin/composer /usr/local/bin/composer
COPY ecrDocker/php.ini /usr/local/etc/php/conf.d/php.ini

# ワーキングディレクトリの設定
WORKDIR /var/www

# これは本来不要（セキュリティ上のリスクを伴うため、適切なパーミッション設定を検討してください）
RUN chmod 777 database/database.sqlite

# PHP-FPMの設定ファイルの調整（必要に応じて）
RUN sed -i "s/user = www-data/user = www-data/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/group = www-data/group = www-data/g" /usr/local/etc/php-fpm.d/www.conf && \
    echo "php_admin_flag[log_errors] = on" >> /usr/local/etc/php-fpm.d/www.conf

# コンテナ起動時に実行されるコマンド
CMD ["php-fpm", "-y", "/usr/local/etc/php-fpm.conf", "-R"]

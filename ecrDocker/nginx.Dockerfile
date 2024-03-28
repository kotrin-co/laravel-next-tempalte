FROM nginx:1.25.4-alpine

# ユーザーとグループの設定
ARG UID=1111
ARG GID=1111

# 不要なグループの削除とlaravelグループとユーザーの作成
RUN delgroup dialout && \
    addgroup -g ${GID} --system laravel && \
    adduser -G laravel --system -D -s /bin/sh -u ${UID} laravel

# Nginxのユーザーをnginxからlaravelに変更
RUN sed -i "s/user  nginx;/user laravel;/" /etc/nginx/nginx.conf

# Laravelプロジェクトのディレクトリを作成
RUN mkdir -p /var/www

COPY ./backend/public /var/www/public

# ホストからコピーする設定ファイル
COPY ecrDocker/default.conf /etc/nginx/conf.d/default.conf

# Nginxのログディレクトリのパーミッションを変更
RUN chown -R laravel:laravel /var/log/nginx && \
    chown -R laravel:laravel /var/cache/nginx && \
    chown -R laravel:laravel /var/www

# ポート80を公開
EXPOSE 80

# Nginxをフォアグラウンドで実行
CMD ["nginx", "-g", "daemon off;"]
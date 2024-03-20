FROM node:20-slim

ENV TZ Asia/Tokyo
ENV LANG=C.UTF-8

WORKDIR /var/www/html

RUN apt-get update \
    && apt-get install -y \
    git \
    vim

EXPOSE 3000
EXPOSE 24678

ENV HOST 0.0.0.0
FROM composer as deps

ADD . /app/
RUN composer install

FROM php:7.3-fpm-alpine 

COPY . /var/www/
WORKDIR /var/www/
COPY --from=deps /app/vendor/ vendor/
RUN cp .env.example .env \
    && php artisan key:generate \
    && docker-php-ext-install pdo_mysql
ENV DB_HOST=database DB_USERNAME=app DB_PASSWORD=123456
RUN chmod a+w -R storage/*
CMD ["./init.sh", "php-fpm"]
RUN apk add --no-cache openssl
ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

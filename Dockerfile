FROM php:7.3-fpm-alpine 

COPY . /var/www/
WORKDIR /var/www/
COPY --from=deps /app/vendor/ vendor/
RUN cp .env.example .env \
    && php artisan key:generate \
    && docker-php-ext-install pdo_mysql
ENV DB_HOST=database DB_USERNAME=app DB_PASSWORD=123456
RUN chmod a+w -R storage/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
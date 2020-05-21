FROM php:7.3-fpm-alpine 

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
COPY . /var/www/
WORKDIR /var/www/
RUN composer install 
RUN cp .env.example .env
RUN php artisan key:generate
RUN docker-php-ext-install pdo_mysql
RUN php artisan migrate

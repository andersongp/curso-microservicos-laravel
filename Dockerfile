FROM php:7.3.6-fpm-alpine3.9 as desenvolvimento
RUN apk add bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www

RUN rm -fr /var/www/html

RUN ln -s public html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

EXPOSE 9000
ENTRYPOINT ["php-fpm"]

FROM php:7.3.6-fpm-alpine3.9  as producao
RUN apk add bash mysql-client
RUN docker-php-ext-install pdo pdo_mysql

WORKDIR /var/www

RUN rm -fr /var/www/html

COPY . /var/www

RUN ln -s public html

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN composer install
RUN cp .env.example .env
RUN php artisan key:generate
RUN php artisan config:cache

EXPOSE 9000
ENTRYPOINT ["php-fpm"]
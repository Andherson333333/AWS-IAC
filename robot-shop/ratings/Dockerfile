FROM php:7.4-apache
RUN apt-get update && apt-get install -yqq unzip libzip-dev \
    && docker-php-ext-install pdo_mysql opcache zip
RUN echo "instana.enable_auto_profile=1" > "/usr/local/etc/php/conf.d/zzz-instana-extras.ini"

COPY status.conf /etc/apache2/mods-available/status.conf
RUN a2enmod rewrite && a2enmod status

WORKDIR /var/www/html
COPY html/ /var/www/html

# Asegurarse de que el .env existe y copiarlo
COPY html/.env /var/www/html/.env

COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer install

RUN rm -Rf /var/www/var/*
RUN chown -R www-data /var/www
# Dar permisos específicos al .env
RUN chmod 600 /var/www/html/.env
RUN chmod -R 777 /var/www

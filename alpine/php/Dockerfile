#Ref: https://github.com/refresher/glpi-docker-alpine.git

FROM php:fpm-alpine3.16

RUN apk add --no-cache openldap-dev mariadb-dev libxml2-dev libxml2 libpng-dev icu-dev libzip-dev libzip xmlrpc-c

RUN PACKAGES="ldap mysqli"
RUN docker-php-ext-configure ldap && docker-php-ext-install ldap
RUN docker-php-ext-configure mysqli && docker-php-ext-install mysqli
RUN docker-php-ext-configure xml && docker-php-ext-install xml
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-configure exif && docker-php-ext-install exif
RUN docker-php-ext-configure zip && docker-php-ext-install zip
RUN docker-php-ext-configure bz2 && docker-php-ext-install -j$(nproc) bz2 
RUN docker-php-ext-configure opcache && docker-php-ext-install opcache
RUN docker-php-ext-configure gd && docker-php-ext-install gd
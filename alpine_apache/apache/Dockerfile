#Ref: https://github.com/refresher/glpi-docker-alpine.git
#Ref: https://nsmith.net/apcu-with-docker-and-php-fpm 
#Ref: https://gist.github.com/evansims/280d63378c9f422f7b5d72e6d16f3806

ARG BUILDER_IMAGE=php:7.4.0-fpm-alpine
ARG APP_IMAGE=httpd:2.4

#####
# Builder image
#####
FROM $BUILDER_IMAGE AS builder

RUN apk add --no-cache openldap-dev mariadb-dev libxml2-dev libxml2 libpng-dev icu-dev libzip-dev libzip xmlrpc-c git yarn autoconf g++ make openssl-dev

# Setup bzip2 extension
RUN apk add --no-cache \
    bzip2-dev \
    && docker-php-ext-install -j$(nproc) bz2 \
    && docker-php-ext-enable bz2 \
    && rm -rf /tmp/*

RUN PACKAGES="ldap mysqli"
RUN docker-php-ext-configure ldap && docker-php-ext-install ldap
RUN docker-php-ext-configure mysqli && docker-php-ext-install mysqli
RUN docker-php-ext-configure xml && docker-php-ext-install xml
RUN docker-php-ext-configure xmlrpc && docker-php-ext-install xmlrpc
RUN docker-php-ext-configure exif && docker-php-ext-install exif
RUN docker-php-ext-configure zip && docker-php-ext-install zip
RUN docker-php-ext-install soap

# Install mbstring extension
RUN apk add --no-cache \
    oniguruma-dev \
    && docker-php-ext-install mbstring \
    && docker-php-ext-enable mbstring \
    && rm -rf /tmp/*


# Install intl extension
RUN apk add --no-cache \
    icu-dev \
    && docker-php-ext-install -j$(nproc) intl \
    && docker-php-ext-enable intl \
    && rm -rf /tmp/*

# Setup GD extension
RUN apk add --no-cache \
      freetype \
      libjpeg-turbo \
      libpng \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && docker-php-ext-configure gd \
      --with-freetype=/usr/include/ \
      # --with-png=/usr/include/ \ # No longer necessary as of 7.4; https://github.com/docker-library/php/pull/910#issuecomment-559383597
      --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-enable gd \
    && apk del --no-cache \
      freetype-dev \
      libjpeg-turbo-dev \
      libpng-dev \
    && rm -rf /tmp/*

# INstall opcache, xdebug
RUN docker-php-source extract \
    && pecl install opcache xdebug apcu \
    && echo "xdebug.remote_enable=on\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=on\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_port=9000\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_handler=dbgp\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_connect_back=1\n" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && docker-php-ext-enable opcache xdebug apcu \
    && docker-php-source delete \
    && rm -rf /tmp/*

FROM $APP_IMAGE


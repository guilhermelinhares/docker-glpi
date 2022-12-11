# https://github.com/glpi-project/docker-images/blob/master/glpi-nightly/Dockerfile
#https://www.php.net/manual/en/xmlrpc.installation.php

ARG BUILDER_IMAGE=php:cli-alpine
ARG APP_IMAGE=php:8.0-apache

#####
# Builder image
#####
FROM $BUILDER_IMAGE AS builder

# Copy composer binary from latest composer image.
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install required system packages.
RUN \
  # Update APK package list.
  apk update \
  \
  # Install bash that is used in for build script.
  && apk add bash \
  \
  # Install patch utility that may be usefull to patch dependencies.
  && apk add patch \
  \
  # Install gettext and perl required to compile locales.
  && apk add gettext perl \
  \
  # Install nodejs and npm.
  && apk add nodejs npm \
  \
  # Install git and zip used by composer when fetching dependencies.
  && apk add git unzip \
  \
  # Clean sources list.
  && rm -rf /var/cache/apk/*

 # Update PHP configuration.
RUN echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/docker-php-memory.ini

#####
# Application image
#####
FROM $APP_IMAGE

RUN apt-get update \
  \
  # Install APCU PHP extension.
  && pecl install apcu \
  && docker-php-ext-enable apcu \
  && echo "apc.enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
  \
  # Install bz2 PHP extension.
  && apt-get install --assume-yes --no-install-recommends --quiet libbz2-dev \
  && docker-php-ext-install bz2 \
  \
  # Install exif extension.
  && docker-php-ext-install exif \
  \
  # Install gd PHP extension.
  && apt-get install --assume-yes --no-install-recommends --quiet libfreetype6-dev libjpeg-dev libpng-dev \
  && docker-php-ext-configure gd --with-freetype --with-jpeg \
  && docker-php-ext-install gd \
  \
  # Install intl PHP extension.
  && apt-get install --assume-yes --no-install-recommends --quiet libicu-dev \
  && docker-php-ext-configure intl \
  && docker-php-ext-install intl \
  \
  # Install ldap PHP extension.
  && apt-get install --assume-yes --no-install-recommends --quiet libldap2-dev \
  && docker-php-ext-configure ldap \
  && docker-php-ext-install ldap \
  \
  #Install opcache PHP extension.
  && docker-php-ext-configure opcache \ 
  && docker-php-ext-install opcache \
  && docker-php-ext-enable opcache \
  \
  # Install mysqli PHP extension.
  && docker-php-ext-install mysqli \
  \
  # Install soap PHP extension (required for some plugins).
  && apt-get install --assume-yes --no-install-recommends --quiet libxml2-dev \
  && docker-php-ext-install soap \
  \
  #Install xmlrc PHP extension
  && pecl install channel://pecl.php.net/xmlrpc-1.0.0RC3 \
  && echo "extension=xmlrpc.so" >> /usr/local/etc/php/conf.d/docker-php-ext-xmlrpc.ini \
  \
  # Install zip PHP extension.
  && apt-get install --assume-yes --no-install-recommends --quiet libzip-dev \
  && docker-php-ext-configure zip \
  && docker-php-ext-install zip \
  \
  # Install cron service.
  && apt-get install --assume-yes --no-install-recommends --quiet cron \
  \
  # Install acl to manage acl of writable directories.
  && apt-get install --assume-yes --no-install-recommends --quiet acl \
  \
  # Clean sources list.
  && rm -rf /var/lib/apt/lists/*

COPY ./files/etc/cron.d/glpi /etc/cron.d/glpi
COPY ./files/opt/startup.sh /opt/startup.sh

# Install GLPI crontab.
RUN crontab -u www-data /etc/cron.d/glpi

# Define GLPI environment variables
ENV \
  GLPI_INSTALL_MODE=DOCKER \
  GLPI_CONFIG_DIR=/var/glpi/config \
  GLPI_VAR_DIR=/var/glpi/files

# Make startup script executable and executes it as default command.
RUN chmod u+x /opt/startup.sh
CMD /opt/startup.sh

WORKDIR /var/www/html/glpi/

EXPOSE 80 443


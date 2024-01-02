ARG PHP_VERSION=8.3
ARG WEBSERVER_VERSION=apache

FROM php:${PHP_VERSION}-${WEBSERVER_VERSION}

ARG WWW_GROUP_ID=1000
ARG WWW_USER_ID=1000

#setting up os and installing tools
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
#installing os tools
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y zip unzip git man gpg nano locales gosu
#installing php extensions
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions xdebug mysqli exif igbinary imagick intl zip apcu memcached opcache redis bcmath gd shmop ssh2 sockets
#setting os locale
COPY ./locale.gen /etc/locale.gen
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US
ENV LC_ALL=en_US.UTF-8
RUN dpkg-reconfigure locales && update-locale

#intalling wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./spin8_install_wp /usr/local/bin/spin8_install_wp
RUN chmod +x /usr/local/bin/spin8_install_wp

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

#creating user
RUN groupadd --force -g ${WWW_GROUP_ID} www-data
RUN useradd --create-home --shell /bin/bash --no-user-group -g www-data -u ${WWW_USER_ID} spin8

COPY entrypoint /usr/local/bin/entrypoint
RUN chmod +x /usr/local/bin/entrypoint
ENTRYPOINT [ "entrypoint" ]
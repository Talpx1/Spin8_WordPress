ARG WP_VERSION=6.4.2
ARG PHP_VERSION=8.3
ARG WEBSERVER_VERSION=apache

FROM wordpress:${WP_VERSION}-php${PHP_VERSION}-${WEBSERVER_VERSION}

#setting up os and installing tools
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US
ENV LC_ALL=en_US.UTF-8
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=UTC
#installing os tools
RUN apt-get update -y && apt-get upgrade -y
RUN apt-get install -y zip unzip git man gpg nano locales
#installing xdebug
ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions
RUN install-php-extensions xdebug mysqli
#setting os locale
COPY ./locale.gen /etc/locale.gen
RUN dpkg-reconfigure locales && update-locale

#intalling wp-cli
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY ./spin8_install_wp.bash /usr/local/bin/spin8_install_wp
RUN chmod +x /usr/local/bin/spin8_install_wp

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

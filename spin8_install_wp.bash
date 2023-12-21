#!/bin/bash
#TODO: add debug toggling

wp --allow-root config create \
    --dbhost=${WORDPRESS_DB_HOST} \
    --dbname=${WORDPRESS_DB_NAME} \
    --dbuser=${WORDPRESS_DB_USER} \
    --dbpass=${WORDPRESS_DB_PASSWORD} \
    --dbprefix=${WORDPRESS_TABLE_PREFIX} \
    --locale=${WORDPRESS_LOCALE} \
    --force \
    --skip-check &&
wp --allow-root core install \
    --url=${WORDPRESS_WEBSITE_URL_WITHOUT_HTTP} \
    --title="${WORDPRESS_WEBSITE_TITLE}" \
    --admin_user=${WORDPRESS_ADMIN_USER} \
    --admin_password=${WORDPRESS_ADMIN_PASSWORD} \
    --admin_email=${WORDPRESS_ADMIN_EMAIL} \
    --locale=${WORDPRESS_LOCALE} \
    --skip-email &&
wp --allow-root option update siteurl "${WORDPRESS_WEBSITE_URL}" &&
wp --allow-root rewrite structure "${WORDPRESS_WEBSITE_POST_URL_STRUCTURE}" &&
composer install --working-dir=${PLUGIN_ABS_PATH}
#!/bin/bash
DB_PASSWORD=$(cat /run/secrets/wp_user_password)

# 1) wp-config.php
wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${DB_PASSWORD}" \
    --path=/var/www/html \
    --allow-root \
    --skip-check
wp config set WP_HOME "https://${DOMAIN_NAME}:${PORT}" --type=constant --path=/var/www/html --allow-root
wp config set WP_SITEURL "https://${DOMAIN_NAME}:${PORT}/wp-admin" --type=constant --path=/var/www/html --allow-root
echo "wp-config.php created in WordPress container!"

# 2) edit PHP-FPM listen directive
#echo "listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}" >> /etc/php/7.4/fpm/pool.d/www.conf
sed -i "s/listen = .*/listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf

# 3) start PHP-FPM process
set -e # exit on error
VER=${PHP_VER}
echo "starting php-fpm$VER..."
exec php-fpm$VER -F

# this exec replace the current shell with CMD[]
#exec "$@"

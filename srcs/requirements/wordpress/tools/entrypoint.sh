#!/bin/bash
# 1) wp-config.php
wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${WORDPRESS_DB_PASSWORD}" \
    --path=/var/www/html \
    --allow-root \
    --skip-check
wp config set WP_HOME "https://${DOMAIN_NAME}:${PORT}" --type=constant --path=/var/www/html --allow-root
wp config set WP_SITEURL "https://${DOMAIN_NAME}:${PORT}/wp-admin" --type=constant --path=/var/www/html --allow-root
echo "wp-config.php created in WordPress container!"

# 2) #edit PHP-FPM listen directive
#echo "listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}" >> /etc/php/8.2/fpm/pool.d/www.conf
sed -i "s/listen = .*/listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}/" /etc/php/8.2/fpm/pool.d/www.conf

exec "$@"

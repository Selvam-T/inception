#!/bin/bash
echo "Executing entrypoint script in WordPress ..."

set -e
VER=${PHP_VER}
#DBUSER_PASSWORD=$(cat /run/secrets/wp_password)

DBUSER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password)
SUP_PASSWORD=$(sed -n '2p' /run/secrets/wp_password)
REG_PASSWORD=$(sed -n '3p' /run/secrets/wp_password)

echo "Testing DBUSER_PASSWORD : ${DBUSER_PASSWORD}"
echo "Testing SUP_PASSWORD : ${SUP_PASSWORD}"
echo "Testing REG_PASSWORD : ${REG_PASSWORD}"

# 1) wp-config.php
wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${DBUSER_PASSWORD}" \
    --path=/var/www/html \
    --allow-root \
    --skip-check
wp config set WP_HOME "https://${DOMAIN_NAME}:${PORT}" --type=constant --path=/var/www/html --allow-root
wp config set WP_SITEURL "https://${DOMAIN_NAME}:${PORT}" --type=constant --path=/var/www/html --allow-root
echo "1. wp-config.php created in WordPress container!"

# 2) edit PHP-FPM listen directive
sed -i "s/listen = .*/listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}/" /etc/php/${PHP_VER}/fpm/pool.d/www.conf
echo "2. listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT} edited in www.conf!"

# 3) start PHP-FPM process
echo "3. starting php-fpm$VER..."
exec php-fpm$VER -F

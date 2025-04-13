#!/bin/bash
echo "Executing entrypoint script in WordPress ..."

set -e
VER=${PHP_VER}

DBUSER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password) # add to wp-config file
SUP_PASSWORD=$(sed -n '2p' /run/secrets/wp_password) # add to Table
REG_PASSWORD=$(sed -n '3p' /run/secrets/wp_password) # add to Table

# 1) wp-config.php
wp config create \
    --dbname="${WORDPRESS_DB_NAME}" \
    --dbhost="${WORDPRESS_DB_HOST}" \
    --dbuser="${WORDPRESS_DB_USER}" \
    --dbpass="${DBUSER_PASSWORD}" \
    --path=/var/www/html \
    --allow-root \
    --skip-check
wp config set WP_HOME "https://${DOMAIN_NAME}:${PORT}" \
    --type=constant --path=/var/www/html --allow-root
wp config set WP_SITEURL "https://${DOMAIN_NAME}:${PORT}" \
    --type=constant --path=/var/www/html --allow-root
echo "1. wp-config.php created in WordPress container!"

# 2) edit PHP-FPM listen directive
sed -i "s/listen = .*/listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}/" \
        /etc/php/${PHP_VER}/fpm/pool.d/www.conf
echo "2. listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT} edited in www.conf!"

# 3) Ensure MariaDB setup created database and db user
for i in {1..5}; do
  if mysql \
        -h "${WORDPRESS_DB_HOST}" \
        -u "${WORDPRESS_DB_USER}" \
        -p"${DBUSER_PASSWORD}" \
        -e "SHOW DATABASES;" > /dev/null 2>&1; then
        break
  fi
  echo "3. Waiting for MariaDB to be fully ready..."
  sleep 2
done

# 4) Wordpress installation process
if ! wp core is-installed --allow-root --path=/var/www/html; then
  echo "4. Starting WordPress installation process..."
  wp core install --url=${DOMAIN_NAME} \
                --title=Inception_sthiagar \
                --admin_user=${WORDPRESS_SUPER} \
                --admin_password=${SUP_PASSWORD} \
                --admin_email=info@example.com \
                --path=/var/www/html \
                --skip-email \
                --allow-root
                #--quiet
  echo "   ... WordPress is initialized."
fi

# 5) Create regular user
echo "5. Creating WordPress regular user..."
wp user create ${WORDPRESS_REGULAR} ${WORDPRESS_REGULAR}@example.com \
        --role=author \
        --user_pass=${REG_PASSWORD} \
        --display_name=Dummy \
        --first_name=First_Dummy \
        --last_name=Last_Dummy \
        --description=User_created_in_mariadb_ENTRYPOINT \
        --path=/var/www/html \
        --allow-root
        #--skip-themes
        #--quiet     

# 6) start PHP-FPM process
echo "6. starting php-fpm$VER..."
exec php-fpm$VER -F

#!/bin/bash
echo -e "\033[36mExecuting entrypoint script in WordPress ...\033[0m"

set -e
VER=${PHP_VER}

DBUSER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password) # add to wp-config file
SUP_PASSWORD=$(sed -n '2p' /run/secrets/wp_password) # add to Table
REG_PASSWORD=$(sed -n '3p' /run/secrets/wp_password) # add to Table

# 1) wp-config.php
if ! [ -f /var/www/html/wp-config.php ] > /dev/null 2>&1; then
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
        echo -e "\t1/6. wp-config.php created in WordPress container!"
else
        echo -e "\t1/6. wp-config.php already exists. Skipping creation."
fi

# 2) edit PHP-FPM listen directive
sed -i "s/listen = .*/listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT}/" \
        /etc/php/${PHP_VER}/fpm/pool.d/www.conf
echo -e "\t2.a/6. listen = ${PHP_FPM_BIND_ADDR}:${PHP_FPM_PORT} edited in www.conf!"

sed -i 's/.*daemonize = .*/daemonize = no/' /etc/php/${PHP_VER}/fpm/php-fpm.conf
echo -e "\t2.b/6. set daemonize = no in php-fpm.conf!"

# 3) Ensure MariaDB setup created database and db user
for i in {1..5}; do
  if mysql \
        -h "${WORDPRESS_DB_HOST}" \
        -u "${WORDPRESS_DB_USER}" \
        -p"${DBUSER_PASSWORD}" \
        -e "SHOW DATABASES;" > /dev/null 2>&1; then
        break
  fi
  echo -e "\t3/6. Waiting for MariaDB to be fully ready..."
  sleep 2
done
echo -e "\t3/6. MariaDB is fully ready..."

# 4) Wordpress installation process
if ! wp core is-installed --allow-root --path=/var/www/html > /dev/null 2>&1; then
  echo -e "\t4.1/6. Starting WordPress installation process..."
  wp core install --url=${DOMAIN_NAME} \
                --title=Inception_sthiagar \
                --admin_user=${WORDPRESS_SUPER} \
                --admin_password=${SUP_PASSWORD} \
                --admin_email=info@example.com \
                --path=/var/www/html \
                --skip-email \
                --allow-root
                #--quiet
  echo -e "\t4.2/6   ... WordPress is initialized."
fi

# 5) Create regular user
if ! wp user get "${WORDPRESS_REGULAR}" --allow-root --path=/var/www/html > /dev/null 2>&1; then
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
        echo -e "\t5/6. WordPress user '${WORDPRESS_REGULAR}' created."
else
        echo -e "\t5/6. WordPress user '${WORDPRESS_REGULAR}' already exists. Skipping user creation."
fi
# 6) start PHP-FPM process
echo -e "\t6/6. starting php-fpm$VER..."
exec php-fpm$VER -F

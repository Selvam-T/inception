ARG DEBIAN_VERSION=bullseye
ARG PHP_VER=7.4

FROM debian:${DEBIAN_VERSION}

WORKDIR /var/www/html

# A) install tools
RUN apt update && apt upgrade -y
RUN apt install wget -y

# B) php7.4 default version for bullseye
# RUN apt install php${PHP_VER} -y

# C) latest stable version is 8.4
RUN apt install php-fpm -y

# to store PHP-FPM process ID file (php-fpm.pid)
# PHP8.2 creates by default, PHP7.4 does not
RUN mkdir -p /run/php

# D) provides mysqli extension, don't be confused with php-mysql
RUN apt install php-mysql -y

#to connect to the database
RUN apt install -y mariadb-client

#for debugging network
RUN apt install iputils-ping -y 
RUN apt install iproute2 -y

#download and install wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/* /var/www/html/
RUN rm -rf wordpress latest.tar.gz

#Install WP-CLI
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# verify that it is working
RUN php wp-cli.phar --info
# make the file executable and move it to somewhere in your PATH.
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

#remove installation files
RUN rm -rf /var/lib/apt/lists/*

# set permissions for web server to access WordPress files
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# script generates wp-config.php
COPY /tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

#for NGINX to communicate with PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["sh", "-c", "php-fpm7.4" "-F"]

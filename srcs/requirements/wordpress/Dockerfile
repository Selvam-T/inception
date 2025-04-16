ARG DEBIAN_VERSION=bullseye
ARG PHP_VER=7.4

FROM debian:${DEBIAN_VERSION}

WORKDIR /var/www/html

# install tools
RUN apt update && apt upgrade -y && \
    apt install -y \
        wget \
        php-fpm \
        php-mysql \
        mariadb-client \
        iputils-ping \
        iproute2

#remove installation files
RUN rm -rf /var/lib/apt/lists/*
    
# php7.4 default version for bullseye is automatically installed with php-fpm

#download and install wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/* /var/www/html/
RUN rm -rf wordpress latest.tar.gz

#Install WP-CLI
RUN wget -q https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
# make the file executable and move it to somewhere in your PATH.
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

# to store PHP-FPM process ID file (php-fpm.pid)
# PHP8.2 creates by default, PHP7.4 does not
RUN mkdir -p /run/php

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

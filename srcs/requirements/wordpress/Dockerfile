ARG DEBIAN_VERSION=bookworm 

FROM debian:${DEBIAN_VERSION}

WORKDIR /var/www/html

# A) install tools
RUN apt update && apt upgrade -y
RUN apt install wget -y

# B) latest stable version 8.3, did not complete successfully: exit code: 100
RUN apt install php8.2 -y

# C) latest stable version is 8.4
RUN apt install php-fpm -y
# provides mysqli extension, don't be confused with php-mysql
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

#edit listen directive
#RUN echo "listen = 0.0.0.0:9000" >> /etc/php/8.2/fpm/pool.d/www.conf
#RUN sed -i "s/listen = .*/listen = 0.0.0.0:9000/" /etc/php/8.2/fpm/pool.d/www.conf

# set permissions for web server to access WordPress files
RUN chown -R www-data:www-data /var/www/html

# generate 1) wp-config.php
COPY /tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# 2) custom.conf to update listen directive for FastCGI requests from Nginx
#COPY /conf/custom.conf custom.conf

#for NGINX to communicate with PHP-FPM
EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]
CMD ["php-fpm8.2", "-F"]
#or ENTRYPOINT ["php-fpm", "-F"] #cannot be overriden

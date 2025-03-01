ARG DEBIAN_VERSION=bookworm #default value provided

FROM debian:${DEBIAN_VERSION}

WORKDIR /var/www/html

# A) install tools
RUN apt update && apt upgrade -y
RUN apt install wget -y

# B) latest stable version 8.3, did not complete successfully: exit code: 100
RUN apt install php8.2 -y
# Alternatively, to auto detect latest stable version and install
#RUN apt update
#RUN apt install software-properties-common # provides scripts for managing software repository
#RUN add-apt-repository ppa:ondrej/php # reliable source
#RUN apt update  # This second update is needed after adding a new repository
#RUN apt install php

# C) latest stable version is 8.4
RUN apt install php-fpm -y
# provides mysqli extension, don't be confused with php-mysql
RUN apt install php-mysql -y

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

#temp to be removed
#RUN touch /etc/php/8.2/fpm/pool.d/custom.conf
#RUN chmod 644 /etc/php/8.2/fpm/pool.d/custom.conf

#edit listen directive
#RUN echo "listen = 0.0.0.0:9000" >> /etc/php/8.2/fpm/pool.d/www.conf
RUN sed -i 's/listen = .*/listen = 0.0.0.0:9000/' /etc/php/8.2/fpm/pool.d/www.conf

# set permissions for web server to access WordPress files
RUN chown -R www-data:www-data /var/www/html

#replace php.ini ?
#COPY php.ini /usr/locl/etc/php

#remove old php.ini files (without creating new image)?

#for NGINX to communicate with PHP-FPM
EXPOSE 9000

CMD ["php-fpm8.2", "-F"]
#or ENTRYPOINT ["php-fpm", "-F"] #cannot be overriden

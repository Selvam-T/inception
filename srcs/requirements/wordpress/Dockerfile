ARG DEBIAN_VERSION=bookworm #default value provided

FROM debian:${DEBIAN_VERSION}

WORKDIR /var/www/html

#install tools
RUN apt update && apt upgrade -y

RUN apt install php -y

#Review this. I am downloading php-fpm, but I hardcode 8.2 in CMD[] what is another ver was downloaded?
RUN apt install php-fpm -y

RUN apt install php-mysql -y

RUN apt install wget -y

RUN apt install iputils-ping -y 

RUN apt install iproute2 -y

#remove installation files
RUN rm -rf /var/lib/apt/lists/*

#download and install wordpress
RUN wget https://wordpress.org/latest.tar.gz
RUN tar -xvzf latest.tar.gz
RUN mv wordpress/* /var/www/html/
RUN rm -rf wordpress latest.tar.gz

# set permissions for web server to access WordPress files
RUN chown -R www-data:www-data /var/www/html

#temp to be removed
#RUN touch /etc/php/8.2/fpm/pool.d/custom.conf
#RUN chmod 644 /etc/php/8.2/fpm/pool.d/custom.conf

#edit listen directive
RUN echo "listen = 0.0.0.0:9000" >> /etc/php/8.2/fpm/pool.d/www.conf
#replace php.ini ?
#COPY php.ini /usr/locl/etc/php

#Install WP-CLI?

#remove old php.ini files (without creating new image)?

#you don't need port 80, because nginx is running in this container
#EXPOSE 80

#for NGINX to communicate with PHP-FPM
EXPOSE 9000

CMD ["php-fpm8.2", "-F"]
#or ENTRYPOINT ["php-fpm", "-F"] #cannot be overriden

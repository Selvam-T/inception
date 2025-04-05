ARG DEBIAN_VERSION=bullseye

FROM debian:${DEBIAN_VERSION}

RUN apt update && apt upgrade -y

RUN apt install nginx -y

RUN apt install openssl -y

RUN apt install curl -y

#for debugging network
RUN apt install wget -y
RUN apt install iputils-ping -y 
RUN apt install iproute2 -y

# apt update downloads package lists and stores then in /var/lib/apt/list/
# clean up cached package lists to reduce image size
RUN rm -rf /var/lib/apt/list/*

# Change owner and set file permission to access root user file.
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 443

# generate 1) wp-config.php
COPY /tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["nginx", "-g" , "daemon off;"]

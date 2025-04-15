ARG DEBIAN_VERSION=bullseye

FROM debian:${DEBIAN_VERSION}

RUN apt update && apt upgrade -y && \
    apt install -y \
        nginx \
        openssl \
        curl \
        wget \
        iputils-ping \
        iproute2

# apt update downloads package lists, saves in /var/lib/apt/list/
# clean up cached package lists to reduce image size
RUN rm -rf /var/lib/apt/list/*

# Change owner and set file permission to access root user file.
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

EXPOSE 443

# script mounts custom index.html
COPY /tools/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["nginx", "-g" , "daemon off;"]

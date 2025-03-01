ARG DEBIAN_VERSION=bookworm #default value provided

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

#Generate self-signed certificate using openssl
RUN mkdir -p /etc/nginx/ssl && \
	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=US/ST=California/L=Local/O=Localhost/OU=Localhost/CN=localhost"

# Change of Ownership: to www-data to the files
RUN chown -R www-data:www-data /etc/nginx/ssl /var/www/html

# Set permission to ensure NGINX can access all files.
RUN chmod -R 755 /var/www/html

#EXPOSE 80
EXPOSE 443

CMD ["nginx", "-g" , "daemon off;"]

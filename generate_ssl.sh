#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m" 

#Generate self-signed certificate using openssl
echo -e "${YELLOW}Generating self-signed certificate using openssl on host${RESET}"

openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /home/sthiagar/inception/secrets/nginx.key \
        -out /home/sthiagar/inception/secrets/nginx.crt \
        -subj "/C=US/ST=California/L=Local/O=Localhost/OU=Localhost/CN=localhost" \
        -quiet
exec "$@"
echo -e "\t${GREEN}nginx.key and nginx.crt generated successfully.${RESET}"

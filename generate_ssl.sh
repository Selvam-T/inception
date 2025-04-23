#!/bin/bash

MAGENTA="\033[35m"
BLUE="\033[34m"
RESET="\033[0m" 

# Generate self-signed certificate using openssl
echo -e "${MAGENTA}Generating self-signed certificate using openssl on host${RESET}"

# To inject key and crt using Compose's secrets: they must exist on host
# (I can generate the same in ENTRYPOINT, but that approach would rely on secrets:)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout ./secrets/nginx.key \
        -out ./secrets/nginx.crt \
        -subj "/C=US/ST=California/L=Local/O=Localhost/OU=Localhost/CN=localhost" \
        -quiet
exec "$@"
echo -e "\t${BLUE}nginx.key and nginx.crt generated successfully.${RESET}"

# Generate random DB passwords
echo -e "${MAGENTA}Generating random DB and WordPress passwords${RESET}"

if [ ! -f "./secrets/db_root_password.txt" ]; then
        < /dev/urandom tr -dc A-Za-z0-9 | head -c 8 > ./secrets/db_root_password.txt
        echo -e "\t${BLUE}db_root_password.txt created successfully.${RESET}"
fi

if [ ! -f "./secrets/db_password.txt" ]; then
        {
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
        } > ./secrets/db_password.txt
        echo -e "\t${BLUE}db_password.txt created successfully.${RESET}"
fi

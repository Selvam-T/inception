#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m" 

# Generate self-signed certificate using openssl
echo -e "${YELLOW}Generating self-signed certificate using openssl on host${RESET}"

# To inject key and crt using Compose's secrets: they must exist on host
# (I can generate the same in ENTRYPOINT, but that approach would rely on secrets:)
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /home/sthiagar/inception/secrets/nginx.key \
        -out /home/sthiagar/inception/secrets/nginx.crt \
        -subj "/C=US/ST=California/L=Local/O=Localhost/OU=Localhost/CN=localhost" \
        -quiet
exec "$@"
echo -e "\t${GREEN}nginx.key and nginx.crt generated successfully.${RESET}"

# Generate random DB passwords
echo -e "${YELLOW}Generating random DB and WordPress passwords${RESET}"

if [ ! -f "/home/sthiagar/inception/secrets/db_password.txt" ]; then
        < /dev/urandom tr -dc A-Za-z0-9 | head -c 8 > /home/sthiagar/inception/secrets/db_password.txt
        echo -e "\t${GREEN}db_password.txt created successfully.${RESET}"
fi

if [ ! -f "/home/sthiagar/inception/secrets/wp_password.txt" ]; then
        {
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
                < /dev/urandom tr -dc A-Za-z0-9 | head -c 8; echo
        } > /home/sthiagar/inception/secrets/wp_password.txt
        echo -e "\t${GREEN}wp_password.txt created successfully.${RESET}"
fi

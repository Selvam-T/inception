#!/bin/bash

YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m" 

echo -e "${YELLOW}Executing host initialization script ...${RESET}"

if ! grep -q "127.0.0.1 sthiagar.42.fr" /etc/hosts; then
	echo "127.0.0.1 sthiagar.42.fr" | sudo tee -a /etc/hosts
	echo -e "\t${GREEN}1. sthiagar.42.fr host name added to /etc/hosts."
else
	echo -e "\t${GREEN}1. sthiagar.42.fr already exists in /etc/hosts${RESET}"	
fi

if [ ! -d "/home/sthiagar/data/p_files" ]; then
        mkdir -p /home/sthiagar/data/wp_files
        echo -e "\t${GREEN}2. Host directory for WordPress created !${RESET}"
fi

if [ ! -d "/home/sthiagar/data/mysql_data" ]; then
        mkdir -p /home/sthiagar/data/mysql_data
        echo -e "\t${GREEN}3. Host directory for MariaDB created !${RESET}"
fi
echo -e "\n"

#!/bin/bash

MAGENTA="\033[35m"
BLUE="\033[34m"
RESET="\033[0m" 

echo -n "Please provide sudo root password: "; read -s pwd; echo;

echo -e "\t${BLUE}ROOT_PWD in .env updated !${RESET}"
sed -i "s/ROOT_PWD=.*/ROOT_PWD=$pwd/" ./srcs/.env

echo -e "${MAGENTA}Executing host initialization script ...${RESET}"

if ! grep -q "127.0.0.1 sthiagar.42.fr" /etc/hosts; then
        # modifying /etc/hosts requires root access but I must test this block again
	echo pwd | sudo -S bash -c 'echo "127.0.0.1 sthiagar.42.fr" >> /etc/hosts'
	echo -e "\t${BLUE}1. sthiagar.42.fr host name added to /etc/hosts.${RESET}"
else
	echo -e "\t${BLUE}1. sthiagar.42.fr is present in /etc/hosts${RESET}"	
fi

if [ ! -d "/home/sthiagar/data/wp_files" ]; then
        mkdir -p /home/sthiagar/data/wp_files
        echo -e "\t${BLUE}2. Host directory for WordPress created.${RESET}"
fi

if [ ! -d "/home/sthiagar/data/mysql_data" ]; then
        mkdir -p /home/sthiagar/data/mysql_data
        echo -e "\t${BLUE}3. Host directory for MariaDB created.${RESET}"
fi
#echo -e "\n"

#!/bin/bash

MAGENTA="\033[35m"
BLUE="\033[34m"
RESET="\033[0m" 

echo -n "Do you want to remove persistent data on host [y/n]? "; 
read choice
#rm volume wp_files
if [ "$choice" = "y" ] && [ -d "/home/sthiagar/data/wp_files" ]; then
    echo -e "${MAGENTA}Remove Wordpress mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/wp_files >/dev/null 2>&1
    echo -e "\n\t${BLUE}WordPress volume mounted files removed!${RESET}"
fi

#rm volume mysql_data
if [ "$choice" = "y" ] && [ -d "/home/sthiagar/data/mysql_data" ]; then
    echo -e "${MAGENTA}Remove MariaDB mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/mysql_data >/dev/null 2>&1
    echo -e "\t${BLUE}MariaDB volume mounted files removed!${RESET}"
fi

#rm ssl certs
if [ "$(ls -A ./secrets/nginx.* 2>/dev/null)" ]; then
        echo -e "${MAGENTA}Remove SSL key and cert ...${RESET}"
        rm -rf ./secrets/nginx.* > /dev/null
        echo -e "\t${BLUE}SSL key and cert removed!${RESET}"
fi

#rm password files
if [ "$choice" = "y" ] && [ "$(ls -A ./secrets/*.txt 2>/dev/null)" ]; then
        echo -e "${MAGENTA}Remove Passwords ...${RESET}"
        rm -rf ./secrets/*.txt > /dev/null
        echo -e "\t${BLUE}Password files removed!${RESET}"
fi

#rm log files
if [ "$choice" = "y" ]; then
        echo -e "${MAGENTA}Remove log files ...${RESET}"
        echo ${ROOT_PWD} | sudo -S chown -R $USER:$USER ./srcs/requirements/nginx/log 2>&1 /dev/null
        echo ${ROOT_PWD} | sudo -S chown -R $USER:$USER ./srcs/requirements/wordpress/log 2>&1 /dev/null
        echo ${ROOT_PWD} | sudo -S chown -R $USER:$USER ./srcs/requirements/mariadb/log 2>&1 /dev/null
fi

if [ "$choice" = "y" ] && [ "$(ls -A ./srcs/requirements/nginx/log/* 2>/dev/null)" ]; then
        rm -rf ./srcs/requirements/nginx/log/* > /dev/null
        echo -e "\t${BLUE}Nginx log files removed!${RESET}"
fi

if [ "$choice" = "y" ] && [ "$(ls -A ./srcs/requirements/wordpress/log/* 2>/dev/null)" ]; then
        rm -rf ./srcs/requirements/wordpress/log/* > /dev/null
        echo -e "\t${BLUE}WordPress log files removed!${RESET}"
fi

if [ "$choice" = "y" ] && [ "$(ls -A ./srcs/requirements/mariadb/log/* 2>/dev/null)" ]; then
        rm -rf ./srcs/requirements/mariadb/log/* > /dev/null
        echo -e "\t${BLUE}MariaDB log files removed!${RESET}"
fi

#reset ROOT_PWD in .env
sed -i "s/ROOT_PWD=.*/ROOT_PWD= #to be updated during make/" ./srcs/.env

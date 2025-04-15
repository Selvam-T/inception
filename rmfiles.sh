#!/bin/bash
MAGENTA="\033[35m"
BLUE="\033[34m"
RESET="\033[0m" 

#rm volume wp_files
if [ -d "/home/sthiagar/data/wp_files" ]; then
    echo -e "${MAGENTA}Remove Wordpress mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/wp_files >/dev/null 2>&1
    echo -e "\n\t${BLUE}WordPress volume mounted files removed!${RESET}"
fi

#rm volume mysql_data
if [ -d "/home/sthiagar/data/mysql_data" ]; then
    echo -e "${MAGENTA}Remove MariaDB mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/mysql_data >/dev/null 2>&1
    echo -e "\t${BLUE}MariaDB volume mounted files removed!${RESET}"
fi

#rm secrets
if [ "$(ls -A /home/sthiagar/inception/secrets/nginx.* 2>/dev/null)" ]; then
        echo -e "${MAGENTA}Remove Secrets ...${RESET}"
        rm -rf /home/sthiagar/inception/secrets/nginx.* > /dev/null
        echo -e "\t${BLUE}Secret files removed!${RESET}"
fi

#rm password files
if [ "$(ls -A /home/sthiagar/inception/secrets/*.txt 2>/dev/null)" ]; then
        echo -e "${MAGENTA}Remove Passwords ...${RESET}"
        rm -rf /home/sthiagar/inception/secrets/*.txt > /dev/null
        echo -e "\t${BLUE}Password files removed!${RESET}"
fi

#rm log files
echo -e "${MAGENTA}Remove log files ...${RESET}"

if [ "$(ls -A /home/sthiagar/inception/srcs/requirements/nginx/log/* 2>/dev/null)" ]; then
        rm -rf /home/sthiagar/inception/srcs/requirements/nginx/log/* > /dev/null
        echo -e "\t${BLUE}Nginx log files removed!${RESET}"
fi

if [ "$(ls -A /home/sthiagar/inception/srcs/requirements/wordpress/log/* 2>/dev/null)" ]; then
        rm -rf /home/sthiagar/inception/srcs/requirements/wordpress/log/* > /dev/null
        echo -e "\t${BLUE}WordPress log files removed!${RESET}"
fi

if [ "$(ls -A /home/sthiagar/inception/srcs/requirements/mariadb/log/* 2>/dev/null)" ]; then
        rm -rf /home/sthiagar/inception/srcs/requirements/mariadb/log/* > /dev/null
        echo -e "\t${BLUE}MariaDB log files removed!${RESET}"
fi

#reset ROOT_PWD in .env
sed -i "s/ROOT_PWD=.*/ROOT_PWD= #to be updated during make/" ./srcs/.env

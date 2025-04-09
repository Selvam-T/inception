#!/bin/bash
YELLOW="\033[33m"
GREEN="\033[32m"
RESET="\033[0m" 

#rm volume wp_files
if [ -d "/home/sthiagar/data/wp_files" ]; then
    echo -e "${YELLOW}Remove Wordpress mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/wp_files
    echo -e "\n\t${GREEN}WordPress volume mounted files removed!${RESET}"
fi

#rm volume mysql_data
if [ -d "/home/sthiagar/data/mysql_data" ]; then
    echo -e "${YELLOW}Remove MariaDB mounted volume files ...${RESET}"
    echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/mysql_data
    echo -e "\t${GREEN}MariaDB volume mounted files removed!${RESET}"
fi

#rm secrets
if [ "$(ls -A /home/sthiagar/inception/secrets/nginx.* 2>/dev/null)" ]; then
        echo -e "${YELLOW}Remove Secrets ...${RESET}"
        rm -rf /home/sthiagar/inception/secrets/nginx.* > /dev/null
        echo -e "\t${GREEN}Secret files removed!${RESET}"
fi

#rm password files
if [ "$(ls -A /home/sthiagar/inception/secrets/*.txt 2>/dev/null)" ]; then
        echo -e "${YELLOW}Remove Passwords ...${RESET}"
        rm -rf /home/sthiagar/inception/secrets/*.txt > /dev/null
        echo -e "\t${GREEN}Password files removed!${RESET}"
fi

#rm log files
echo -e "${YELLOW}Remove log files ...${RESET}"
rm -rf /home/sthiagar/inception/srcs/requirements/nginx/log/* > /dev/null
echo -e "\t${GREEN}Nginx log files removed!${RESET}"
rm -rf /home/sthiagar/inception/srcs/requirements/wordpress/log/* > /dev/null
echo -e "\t${GREEN}WordPress log files removed!${RESET}"
rm -rf /home/sthiagar/inception/srcs/requirements/mariadb/log/* > /dev/null
echo -e "\t${GREEN}MariaDB log files removed!${RESET}"

#reset ROOT_PWD in .env
sed -i "s/ROOT_PWD=.*/ROOT_PWD= #to be updated during make/" ./srcs/.env

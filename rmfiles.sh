#!/bin/bash
YELLOW="\033[33m"
RESET="\033[0m" 

if [ "$(ls -A /home/sthiagar/data/wp_files 2>/dev/null)" ]; then
	echo -e "${YELLOW}Remove Wordpress mounted volume files ...${RESET}"
	echo ${ROOT_PWD} | sudo -S chmod -R 755 /home/sthiagar/data/wp_files > /dev/null
	echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/wp_files/*
	echo ${ROOT_PWD} | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/wp_files
	echo -e "\n\tWordPress volume mounted files removed!"
fi

if [ "$(ls -A /home/sthiagar/data/mysql_data 2>/dev/null)" ]; then
	echo -e "${YELLOW}Remove Database mounted volume files ...${RESET}"
	echo ${ROOT_PWD} | sudo -S chmod -R 755 /home/sthiagar/data/mysql_data > /dev/null
	echo ${ROOT_PWD} | sudo -S rm -rf /home/sthiagar/data/mysql_data/*
	echo ${ROOT_PWD} | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/mysql_data
	echo -e "\tDatabase volume mounted files removed!"
fi
echo -e "${YELLOW}Remove Secrets ...${RESET}"
rm -rf /home/sthiagar/inception/secrets/nginx.* > /dev/null
echo -e "\tSecret files removed!"

echo -e "${YELLOW}Remove log files ...${RESET}"
rm -rf /home/sthiagar/inception/srcs/requirements/nginx/log/* > /dev/null
echo -e "\tNginx log files removed!"
rm -rf /home/sthiagar/inception/srcs/requirements/wordpress/log/* > /dev/null
echo -e "\tWordPress log files removed!"
rm -rf /home/sthiagar/inception/srcs/requirements/mariadb/log/* > /dev/null
echo -e "\tMariaDB log files removed!"

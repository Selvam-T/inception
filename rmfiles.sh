#!/bin/bash
#echo "ROOT_PWD in Script: ${ROOT_PWD}"
if [ "$(ls -A /home/sthiagar/data/wp_files 2>/dev/null)" ]; then
	echo "Remove Wordpress mounted volume files ..."
	echo "inception123" | sudo -S chmod -R 755 /home/sthiagar/data/wp_files > /dev/null
	echo "inception123" | sudo -S rm -rf /home/sthiagar/data/wp_files/*
	echo "inception123" | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/wp_files
	echo -e "\tWordPress volume mounted files removed!"
fi

if [ "$(ls -A /home/sthiagar/data/mysql_data 2>/dev/null)" ]; then
	echo "Remove Database mounted volume files ..."
	echo "inception123" | sudo -S chmod -R 755 /home/sthiagar/data/mysql_data > /dev/null
	echo "inception123" | sudo -S rm -rf /home/sthiagar/data/mysql_data/*
	echo "inception123" | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/mysql_data
	echo -e "\tDatabase volume mounted files removed!"
fi
echo "Remove Secrets ..."
rm -rf /home/sthiagar/inception/secrets/nginx.* > /dev/null
echo -e "\tSecret files removed!"

echo "Remove log files ..."
rm -rf /home/sthiagar/inception/srcs/requirements/nginx/log/* > /dev/null
rm -rf /home/sthiagar/inception/srcs/requirements/wordpress/log/* > /dev/null
echo -e "\tLog files removed!"

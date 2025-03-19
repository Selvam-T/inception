#!/bin/bash
if [ "$(ls -A /home/sthiagar/data/wp_files 2>/dev/null)" ]; then
	echo "Remove Wordpress mounted volume files ..."
	echo "inception123" | sudo -S chmod -R 755 /home/sthiagar/data/wp_files
	echo "inception123" | sudo -S rm -rf /home/sthiagar/data/wp_files/*
	echo "inception123" | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/wp_files
	echo "WordPress volume mounted files removed!"
fi

if [ "$(ls -A /home/sthiagar/data/mysql_data 2>/dev/null)" ]; then
	echo "Remove Database mounted volume files ..."
	echo "inception123" | sudo -S chmod -R 755 /home/sthiagar/data/mysql_data
	echo "inception123" | sudo -S rm -rf /home/sthiagar/data/mysql_data/*
	echo "inception123" | sudo -S chown -R ${USER}:${USER} /home/sthiagar/data/mysql_data
	echo "Database volume mounted files removed!"
fi

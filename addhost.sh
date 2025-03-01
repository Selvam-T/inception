#!/bin/bash
if ! grep -q "127.0.0.1 sthiagar.42.fr" /etc/hosts; then
	echo "127.0.0.1 sthiagar.42.fr" | sudo tee -a /etc/hosts
	echo "sthiagar.42.fr host name added to /etc/hosts."
else
	echo "sthiagar.42.fr already exists in /etc/hosts"
fi

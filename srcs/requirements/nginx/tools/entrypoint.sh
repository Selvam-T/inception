#!/bin/bash
echo -e "\033[36mExecuting entrypoint script in Nginx ...\033[0m"

set -e

if cp /mnt/html/selvam.html /var/www/html/selvam.html; then
    echo -e "\t1. Copy custom selvam.html from host to container successful."
else
    echo -e "\tWARNING: Copy custom selvam.html from host to container failed with status $?"
fi

exec nginx -g "daemon off;"


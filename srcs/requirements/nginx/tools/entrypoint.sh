#!/bin/bash
echo -e "\033[36mExecuting entrypoint script in Nginx ...\033[0m"

set -e

if cp /mnt/html/selvam.html /var/www/html/selvam.html; then
    echo -e "\t1/2. Copy custom selvam.html from host to container successful."
else
    echo -e "\t\033[33m1/2.WARNING: Copy custom selvam.html from host to container failed with status $?\033[0m"
fi
echo -e "\t2/2. starting nginx..."
exec nginx -g "daemon off;"

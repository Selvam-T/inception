#!/bin/bash
echo "Executing entrypoint script in Nginx ..."

set -e

#if cp /mnt/html/index.html /usr/share/nginx/html/index2.html; then
if cp /mnt/html/index.html /var/www/html/index.html; then
    echo "1. Copy custom index.html from host to container successful."  | tee -a file /var/log/nginx/nginx-debug.log
else
    echo "WARNING: Copy custom index.html from host to container failed with status $?"  | tee -a file /var/log/nginx/nginx-debug.log
fi

exec nginx -g "daemon off;"


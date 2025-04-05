#!/bin/bash

set -e
if cp /mnt/html/index.html /usr/share/nginx/html/index2.html; then
    echo "/usr/share/nginx/html/index2.html copied successfully." >> /var/log/nginx/nginx-debug.log
else
    echo "/usr/share/nginx/html/index2.html copy failed with status $?" >> /var/log/nginx/nginx-debug.log
fi

exec nginx -g "daemon off;"
#exec "$@"


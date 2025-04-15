#!/bin/bash
echo -e "\033[36mExecuting entrypoint script in MariaDB ...\033[0m"

set -e

MYSQL_USER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password)
#MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_password) # not using here

#1. Start MySQL in the background
echo -e "\t1. Starting MySQL in the background ..."
mysqld_safe --datadir=/var/lib/mysql & pid="$!"

#2. Blocks the subsequent line execution until the database is ready.
until mysqladmin ping -h localhost --silent; do
    echo -e "\t2. Waiting for database to be ready..."
    sleep 1
done

#3. Run initialization SQL file directly if it exists
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo -e "\t3. Running initialization script: init.sql"
    
    sed "s/\__MYSQL_DATABASE__/$MYSQL_DATABASE/g; \
        s/\__MYSQL_USER__/$MYSQL_USER/g; \
        s/\__MYSQL_USER_PASSWORD__/$MYSQL_USER_PASSWORD/g" \
        /docker-entrypoint-initdb.d/init.sql | mysql
else
    echo -e "\tError: Initialization script not found!"
fi

#4. Waiting for the MySQL process to complete
echo -e "\t4. MySQL is ready to accept connections ..."
wait $pid

#5. Check if Database, Users table in Database is created

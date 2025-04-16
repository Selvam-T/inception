#!/bin/bash

set -e
echo -e "\033[36mExecuting entrypoint script in MariaDB ...\033[0m"

MYSQL_USER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password)
#MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_password) # not using here

# mysqld_safe in 1. possibly automatically initialize MariaDB data directory 
# so I don't need to run maria-install-db below
#if [ ! -d "/var/lib/mysql/mysql" ]; then
#    echo -e "\t. Initializing MariaDB data directory ..."
#    mariadb-install-db --datadir=/var/lib/mysql --user=mysql
#    which mariadb-install-db
#fi

#1. Start MySQL in the background
echo -e "\t1/4. Starting MySQL in the background ..."
mysqld_safe --datadir=/var/lib/mysql & pid="$!"


#2. Blocks the subsequent line execution until the database is ready.
until mysqladmin ping -h localhost --silent; do
    echo -e "\t2/4. Waiting for database to be ready..."
    sleep 1
done

#3. Run initialization SQL file directly if it exists
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo -e "\t3/4. Running initialization script: init.sql"
    
    sed "s/\__MYSQL_DATABASE__/$MYSQL_DATABASE/g; \
        s/\__MYSQL_USER__/$MYSQL_USER/g; \
        s/\__MYSQL_USER_PASSWORD__/$MYSQL_USER_PASSWORD/g" \
        /docker-entrypoint-initdb.d/init.sql | mysql
else
    echo -e "\t\033[31m3/4Error: Initialization script not found!\033[0m"
fi

#4. Waiting for the MySQL process to complete
echo -e "\t4/4. MySQL is ready to accept connections ..."
wait $pid

#5. Check if Database, Users table in Database is created

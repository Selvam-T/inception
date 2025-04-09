#!/bin/bash
echo "Executing entrypoint script in MariaDB ..."

set -e

MYSQL_USER_PASSWORD=$(sed -n '1p' /run/secrets/wp_password)
#MYSQL_USER_PASSWORD=$(cat /run/secrets/wp_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_password)

#echo "MYSQL_DATABASE inside ENTRYPOINT '$MYSQL_DATABASE'" #delete
#echo "MYSQL_USER_PASSWORD inside ENTRYPOINT '$MYSQL_USER_PASSWORD'" #delete
#echo "MYSQL_ROOT_PASSWORD inside ENTRYPOINT '$MYSQL_ROOT_PASSWORD'" #delete

#1. Start MySQL in the background
echo -e "\t1. Starting MySQL in the background ..."
mysqld_safe --datadir=/var/lib/mysql & pid="$!"

#2. Wait for MySQL to become available
until mysqladmin ping -h localhost --silent; do
    echo -e "\t2. Waiting for database to be ready..."
    sleep 2
done

#3. Run initialization SQL file directly if it exists
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo -e "\t3. Running initialization script: init.sql"
    
    sed "s/\_MYSQL_DATABASE_/$MYSQL_DATABASE/g; \
        s/\_MYSQL_USER_/$MYSQL_USER/g; \
        s/\_MYSQL_USER_PASSWORD_/$MYSQL_USER_PASSWORD/g" \
        /docker-entrypoint-initdb.d/init.sql | mysql
else
    echo -e "\tError: Initialization script not found!"
fi

#4. Waiting for the MySQL process to complete
echo -e "\t4. MySQL is ready to accept connections ..."
wait $pid

#5. Check if Database, Users table in Database is created

#!/bin/bash
set -e

echo "Executing entrypoint script in MariaDB ..."

#1. Start MySQL in the background
echo -e "\t1. Starting MySQL in the background ..."
mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

#2. Wait for MySQL to become available
until mysqladmin ping -h localhost --silent; do
    echo -e "\t2. Waiting for database to be ready..."
    sleep 2
done

#3. Run initialization SQL file directly if it exists
if [ -f "/docker-entrypoint-initdb.d/init.sql" ]; then
    echo -e "\t3. Running initialization script: init.sql"
    mysql < /docker-entrypoint-initdb.d/init.sql
else
    echo -e "\t3. Initialization script not found!"
fi

#4. Waiting for the MySQL process to complete
echo -e "\t4. MySQL is ready to accept connections ..."
wait $pid

#5. Check if Database, Users table in Database is created

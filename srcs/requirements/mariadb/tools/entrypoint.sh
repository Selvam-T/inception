#!/bin/bash
set -e

# Start MySQL in the background
mysqld_safe --datadir=/var/lib/mysql &
pid="$!"

# Wait for MySQL to become available
until mysqladmin ping -h localhost --silent; do
    echo "Waiting for database to be ready..."
    sleep 2
done

# Run any SQL files in the initialization directory
if [ -d "/docker-entrypoint-initdb.d" ]; then
    echo "Running initialization scripts..."
    for f in /docker-entrypoint-initdb.d/*; do
        case "$f" in
            *.sql)    echo "Running $f"; mysql < "$f" ;;
            *.sql.gz) echo "Running $f"; gunzip -c "$f" | mysql ;;
            *)        echo "Ignoring $f" ;;
        esac
    done
fi

# Keep the container running
echo "MySQL is ready to accept connections"
wait $pid

ARG DEBIAN_VERSION=bullseye

FROM debian:${DEBIAN_VERSION}

RUN apt update && apt upgrade -y && \
    apt install -y \
        mariadb-server \
        mariadb-client

#directory for database data 
RUN mkdir -p /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql
RUN mariadb-install-db --datadir=/var/lib/mysql --user=mysql

#directory for socket file
RUN mkdir -p /run/mysqld 
RUN chown mysql:mysql /run/mysqld

# directory for initialization script
RUN mkdir -p /docker-entrypoint-initdb.d
RUN chown mysql:mysql /docker-entrypoint-initdb.d

EXPOSE 3306

# entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

#USER mysql --> using root

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["mysqld_safe", "--datadir=/var/lib/mysql"]

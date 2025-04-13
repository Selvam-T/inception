ARG DEBIAN_VERSION=bullseye

FROM debian:${DEBIAN_VERSION}

RUN apt update && apt upgrade -y
RUN apt install -y mariadb-server
RUN apt install -y mariadb-client

#configure MariaDB
RUN mariadb-install-db --datadir=/var/lib/mysql --user=mysql
RUN which mariadb-install-db >> /var/build_log
RUN chown -R mysql:mysql /var/lib/mysql

#directory for socket file with system user permission
RUN mkdir -p /run/mysqld 
RUN chown mysql:mysql /run/mysqld

# directory for initialization script
RUN mkdir -p /docker-entrypoint-initdb.d
RUN chown mysql:mysql /docker-entrypoint-initdb.d

EXPOSE 3306

# entrypoint script
COPY tools/entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh

#USER mysql

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["mysqld_safe", "--datadir=/var/lib/mysql"]

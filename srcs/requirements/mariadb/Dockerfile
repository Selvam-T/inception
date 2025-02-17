ARG DEBIAN_VERSION=bookworm #default value provided

FROM debian:${DEBIAN_VERSION}

RUN echo 'Debian version: $DEBIAN_VERSION' > /var/build_log

RUN apt update && apt upgrade -y

RUN apt install -y mariadb-server

#configure MariaDB
RUN mariadb-install-db --user=mysql

RUN which mariadb-install-db > /var/build_log
EXPOSE 3306

CMD ["mysqld_safe", "--datadir=/var/lib/mysql"]

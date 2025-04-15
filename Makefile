# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: sthiagar <marvin@42.fr>                    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/01/28 16:17:38 by sthiagar          #+#    #+#              #
#    Updated: 2025/01/28 16:17:43 by sthiagar         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

include ./srcs/.env

PROJECT_NAME =	inception

YELLOW = \033[33m
GREEN = \033[32m
RESET = \033[0m 

all:	build up

build:	init-host generate-ssl
	@echo "$(YELLOW)Building Docker images with Debian...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml build --no-cache
	@echo "$(YELLOW)Validating Docker images...$(RESET)"
	@docker images $(NGINX_IMG) | grep $(NGINX_IMG) || \
		bash -c 'echo "NGINX image not found! Build failed."; exit 1; '
	@docker images $(WORDPRESS_IMG) | grep $(WORDPRESS_IMG) || \
		bash -c 'echo "WordPress image not found! Build failed."; exit 1; '
	@docker images $(MARIADB_IMG) | grep $(MARIADB_IMG) || \
		bash -c 'echo "MariaDB image not found! Build failed."; exit 1; '

rebuild: down all

rebuild-n:
	@echo "$(YELLOW)Rebuilding Nginx...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml stop nginx || true
	@docker compose -f ./srcs/docker-compose.yml rm -f nginx || true
	@echo "$(YELLOW)Nginx service is stopped and removed.$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d nginx || true
	@echo "$(YELLOW)Nginx service is up.$(RESET)"
	
rebuild-w:
	@echo "$(YELLOW)Rebuilding WordPress...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml stop wordpress || true
	@docker compose -f ./srcs/docker-compose.yml rm -f wordpress || true
	@echo "$(YELLOW)WordPress service is stopped and removed.$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d wordpress || true
	@echo "$(YELLOW)WordPress service is up.$(RESET)"
	
rebuild-m:
	@echo "$(YELLOW)Rebuilding MariaDB...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml stop mariadb || true
	@docker compose -f ./srcs/docker-compose.yml rm -f mariadb || true
	@echo "$(YELLOW)MariaDB service is stopped and removed.$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d mariadb || true
	@echo "$(YELLOW)MariaDB service is up.$(RESET)"

up:
	@echo "$(YELLOW)Starting the application in the background...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d || true

down:
	@echo "$(YELLOW)Stopping and removing containers...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml down --rmi all || true

clean:	down rm-files
	@echo "$(YELLOW)Remove unused images and volumes...$(RESET)"
	@docker system prune -f >/dev/null 2>&1 || true # images
	
	@docker volume prune -f >/dev/null 2>&1 || true # volumes

	@echo "$(YELLOW)Remove MYSQL data and WordPress files on host...$(RESET)"
	@if docker volume inspect srcs_mysql_data >/dev/null 2>&1; then \
		docker volume rm srcs_mysql_data >/dev/null 2>&1 || true; \
		echo "\t$(GREEN)srcs_mysql_data removed !$(RESET)"; \
	fi
	@if docker volume inspect srcs_wp_files >/dev/null 2>&1; then \
		docker volume rm srcs_wp_files >/dev/null 2>&1 || true; \
		echo "\t$(GREEN)srcs_wp_files removed !$(RESET)"; \
	fi

	@echo "$(YELLOW)Remove network...$(RESET)"
	@if docker network inspect ${APP_NETWORK} >/dev/null 2>&1; then \
		echo "Network ${APP_NETWORK} found"; \
		docker network rm ${APP_NETWORK} && \
		echo -e "\t$(GREEN)${APP_NETWORK} removed !$(RESET)"; \
	fi
	
update:
	@echo "$(YELLOW)Updating images...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml pull || true
	@$(MAKE) build

init-host:
	@./inithost.sh

rm-files:
	@ROOT_PWD=$(ROOT_PWD) ./rmfiles.sh

generate-ssl:
	@./generate_ssl.sh

# ******************** DIAGNOSTIC COMMANDS ********************** #
bash-w:
	@echo "$(YELLOW)bash into wordpress container...$(RESET)"
	@docker exec -it $(WP_CONTAINER) bash || true

bash-n:
	@echo "$(YELLOW)bash into nginx container...$(RESET)"
	@docker exec -it $(NGINX_CONTAINER) bash || true

bash-m:
	@echo "$(YELLOW)bash into mariadb container...$(RESET)"
	@docker exec -it $(MDB_CONTAINER) bash || true

network:
	@echo "$(YELLOW)Display all networks...$(RESET)"
	@docker network ls || true
	@echo "$(YELLOW)Containers connected to <$(APP_NETWORK)>...$(RESET)"
	@docker network inspect --format \
		'{{range .Containers}}{{printf "%-15s" .Name}}{{.IPv4Address}}{{"\n"}}{{end}}' ${APP_NETWORK} \
		2>/dev/null || true
ping:
	@echo "$(YELLOW)ping test...$(RESET)"
	@docker exec $(NGINX_CONTAINER) ping -c 1 $(WP_CONTAINER) || true
	@echo "\n"
	@docker exec $(NGINX_CONTAINER) ping -c 1 $(MDB_CONTAINER) || true
	@echo "\n"
	@docker exec $(WP_CONTAINER) ping -c 1 $(NGINX_CONTAINER) || true

ports:
	@echo "$(YELLOW)Display Containers and Exposed Ports...$(RESET)"
	@docker ps --format "{{printf \"%-15s\" .Names}}{{.Ports}}" || true

volume:
	@echo "$(YELLOW)Display all volumes...$(RESET)"
	@echo "Volume\t\t\tDevice"
	@echo "------\t\t\t------"
	@docker volume inspect --format '{{.Name}}{{"\t\t"}}{{.Options.device}}' \
		srcs_mysql_data 2>/dev/null || true
	@docker volume inspect --format '{{.Name}}{{"\t\t"}}{{.Options.device}}' \
		srcs_wp_files 2>/dev/null || true

logs:
	@docker compose -f ./srcs/docker-compose.yml logs || true

list:
	@echo "$(YELLOW)1. Listing images :$(RESET)"
	@echo "$(YELLOW)-------------------$(RESET)"
	@docker images || true
	@echo "$(YELLOW)2. Listing running containers :$(RESET)"
	@echo "$(YELLOW)-------------------------------$(RESET)"
	@docker ps || true
	@echo "$(YELLOW)3. Listing all containers :$(RESET)"
	@echo "$(YELLOW)---------------------------$(RESET)"
	@docker ps -a || true
	@echo "$(YELLOW)4. Listing docker compose services :$(RESET)"
	@echo "$(YELLOW)------------------------------------$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml config --services || true

version:
	@echo "$(YELLOW)1. NGINX tools :$(RESET)"
	@echo "$(YELLOW)-----------------$(RESET)"
	@docker exec -it $(NGINX_CONTAINER) bash -c "\
	cat /etc/os-release | grep PRETTY_NAME | awk -F'\"' '{print \$$2}'; \
	nginx -v; \
	openssl version; \
	curl -V | head -n 1 | awk -F'libcurl' '{print \$$1}'; \
	ping -V; \
	ip -V; echo " || true 
	
	@echo "$(YELLOW)2. WORDPRESS tools :$(RESET)"
	@echo "$(YELLOW)-------------------$(RESET)"
	@docker exec -it $(WP_CONTAINER) bash -c "\
	cat /etc/os-release | grep PRETTY_NAME | awk -F'\"' '{print \$$2}'; \
	php -v | head -n 1 | awk -F'\(built' '{print \$$1}'; \
	echo -n \"PHP-MySQL \"; php -i | grep 'Client API version'; \
	mysql --version | awk -F', for' '{print \$$1}'; \
	echo -n 'WordPress Version: '; wp core version --path=/var/www/html --allow-root 2>/dev/null\
	|| echo 'Not installed'; \
	wp --version --allow-root 2>/dev/null || echo 'Not installed'; \
	ping -V; \
	ip -V; echo " || true
	
	@echo "$(YELLOW)3. MARIADB tools :$(RESET)"
	@echo "$(YELLOW)-------------------$(RESET)"
	@docker exec -it $(MDB_CONTAINER) bash -c "\
	cat /etc/os-release | grep PRETTY_NAME | awk -F'\"' '{print \$$2}'; \
	mariadb --version | awk -F', for' '{print \$$1}'; \
	mysql --version | awk -F', for' '{print \$$1}'; echo " || true

error:
	@echo "$(YELLOW)1. NGINX error log :$(RESET)"
	@echo "$(YELLOW)--------------------$(RESET)"
	@docker exec -it $(NGINX_CONTAINER) bash -c "\
	cat /var/log/nginx/error.log || true " || true
	
	@echo "$(YELLOW)2. PHP-FPM error log: :$(RESET)"
	@echo "$(YELLOW)------------------------$(RESET)"
	@docker exec -it $(WP_CONTAINER) bash -c "\
	cat /var/log/php7.4-fpm.log || true " || true
	
	@echo "$(YELLOW)3. MARIADB error log: :$(RESET)"
	@echo "$(YELLOW)------------------------$(RESET)"
	@docker exec -it $(MDB_CONTAINER) bash -c "\
	cat /var/log/mysql/error.log || true " || true
	
	@echo "$(YELLOW)4. MARIADB General log: :$(RESET)"
	@echo "$(YELLOW)------------------------$(RESET)"
	@docker exec -it $(MDB_CONTAINER) bash -c "\
	cat /var/log/mysql/mysql.log || true " || true
	
access:
	@echo "$(YELLOW)NGINX access log :$(RESET)"
	@echo "$(YELLOW)-------------------$(RESET)"
	@docker exec -it $(NGINX_CONTAINER) bash -c "\
	cat /var/log/nginx/access.log || true" || true
	
wp-config:
	@docker exec -it $(WP_CONTAINER) bash -c "\
	sed -n '23, 39p' /var/www/html/wp-config.php || true; \
	echo -e '\n\n' ; \
	tail -n 11 /var/www/html/wp-config.php | head -n 2 || true " || true

passwords:
	@if [ -f ./secrets/wp_password.txt ]; then \
	     i=1; \
	     while IFS= read -r line; do \
	        case $$i in \
	          1) echo "DB USER = $$line" ;; \
	          2) echo "SUPER USER = $$line" ;; \
	    	  3) echo "REGULAR USER = $$line" ;; \
	        esac; \
	        i=$$((i+1)); \
	     done < ./secrets/wp_password.txt; \
	else \
	     echo "Password file not found."; \
	fi
	
commands:
	@echo "Diagnostic commands available: "
	@echo "-------------------------------"
	@echo "access"
	@echo "bash-m"
	@echo "bash-n"
	@echo "bash-w"
	@echo "commands"
	@echo "error"
	@echo "list"
	@echo "logs"
	@echo "network"
	@echo "passwords"
	@echo "ping"
	@echo "ports"
	@echo "version"
	@echo "volume"
	@echo "wp-config"
	
#validate TLS settings in NGINX

.PHONY:	build up down clean logs update version

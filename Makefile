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

up:
	@echo "$(YELLOW)Starting the application in the background...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml up -d

down:
	@echo "$(YELLOW)Stopping and removing containers...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml down --rmi all

clean:	down rm-files
	@echo "$(YELLOW)Removing unused images and volumes...$(RESET)"
	@docker system prune -f >/dev/null 2>&1 # images
	
	@docker volume prune -f >/dev/null 2>&1 # volumes

	@echo "$(YELLOW)Removing MYSQL data and WordPress files on host...$(RESET)"
	@if docker volume inspect srcs_mysql_data >/dev/null 2>&1; then \
		docker volume rm srcs_mysql_data >/dev/null 2>&1; \
		echo "\t$(GREEN)srcs_mysql_data removed !$(RESET)"; \
	fi
	@if docker volume inspect srcs_wp_files >/dev/null 2>&1; then \
		docker volume rm srcs_wp_files >/dev/null 2>&1; \
		echo "\t$(GREEN)srcs_wp_files removed !$(RESET)"; \
	fi

	@echo "$(YELLOW)Removing network...$(RESET)"
	@if docker network inspect ${APP_NETWORK} >/dev/null 2>&1; then \
		echo "Network ${APP_NETWORK} found"; \
		docker network rm ${APP_NETWORK} && \
		echo -e "\t$(GREEN)${APP_NETWORK} removed !$(RESET)"; \
	fi
	
update:
	@echo "$(YELLOW)Updating images...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml pull
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
	@docker exec -it $(WP_CONTAINER) bash

bash-n:
	@echo "$(YELLOW)bash into nginx container...$(RESET)"
	@docker exec -it $(NGINX_CONTAINER) bash

bash-m:
	@echo "$(YELLOW)bash into mariadb container...$(RESET)"
	@docker exec -it $(MDB_CONTAINER) bash

network:
	@echo "$(YELLOW)Display all networks...$(RESET)"
	@docker network ls
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
	@docker ps --format "{{printf \"%-15s\" .Names}}{{.Ports}}"

volume:
	@echo "$(YELLOW)Display all volumes...$(RESET)"
	@echo "Volume\t\t\tDevice"
	@echo "------\t\t\t------"
	@docker volume inspect --format '{{.Name}}{{"\t\t"}}{{.Options.device}}' \
		srcs_mysql_data 2>/dev/null || true
	@docker volume inspect --format '{{.Name}}{{"\t\t"}}{{.Options.device}}' \
		srcs_wp_files 2>/dev/null || true

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

list:
	@echo "$(YELLOW)Listing images ...$(RESET)"
	@docker images
	@echo "$(YELLOW)Listing running containers ...$(RESET)"
	@docker ps
	@echo "$(YELLOW)Listing all containers ...$(RESET)"
	@docker ps -a
	
#validate TLS settings in NGINX

.PHONY:	build up down clean logs update

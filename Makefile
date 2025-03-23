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
RESET = \033[0m 

all:	build up

build:	add-host generate-ssl
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
	@docker system prune -f # images
	
	@docker volume prune -f # volumes
	@docker volume rm srcs_mysql_data srcs_wp_files
	
	#@docker network rm ${NETWORK_NAME} || true
	#rm -rf $(CERT_PATH)
	
add-host:
	@./addhost.sh

rm-files:
	@ROOT_PWD=$(ROOT_PWD) ./rmfiles.sh

generate-ssl:
	@./generate_ssl.sh

logs:
	@docker compose -f ./srcs/docker-compose.yml logs

update:
	@echo "$(YELLOW)Updating images...$(RESET)"
	@docker compose -f ./srcs/docker-compose.yml pull
	@$(MAKE) build

# ******************** DEBUGGING COMMANDS ********************** #
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
	@echo "$(YELLOW)Inspect $(FRONTEND)...$(RESET)"
	@docker network inspect $(FRONTEND)
	@echo "$(YELLOW)Inspect $(BACKEND)...$(RESET)"
	@docker network inspect $(BACKEND)

#check_volumes:

#check_networks:

#validate_container_cofigurations:

#validate TLS settings in NGINX

.PHONY:	build up down clean logs update


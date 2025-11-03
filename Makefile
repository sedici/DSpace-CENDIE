include docker/.env

.PHONY: bash down install logs reset-db up update stop

default: up

bash:
	docker compose -f docker/docker-compose.yml exec dspace /bin/bash

down:
	@echo "Removing containers for $(COMPOSE_PROJECT_NAME)..."
	@docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml down

install:
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml run --rm dspace install

logs:
	docker-compose exec dspace  sh -c "tail -f docker/-n 200 /dspace/install/log/* /usr/local/tomcat/logs/*"

reset-db:
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml run --rm dspace reset-db

up:
	@echo "Starting up containers for $(COMPOSE_PROJECT_NAME)..."
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml up -d

update:
	@echo "Stopping containers for $(COMPOSE_PROJECT_NAME)..."
	@docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml stop
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml run --rm dspace update
	sudo chown -R $(id -u):$(id -g) install/*
	@echo "Starting up containers for $(COMPOSE_PROJECT_NAME)..."
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml up -d

stop:
	@echo "Stopping containers for $(COMPOSE_PROJECT_NAME)..."
	@docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml stop

build:
	@echo "Starting up containers for $(COMPOSE_PROJECT_NAME)..."
	docker compose -f docker/docker-compose.yml -f docker/others/docker-compose-debug.yml build --no-cache

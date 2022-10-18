DOCKER_COMPOSE_CMD=docker-compose -f docker-compose.yml

help:               ## Show this help.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_\-\.]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup:              ## Setup and run the project.
	@cp .env.example .env
	make build
	make start

build: 		          ## Build all images.
	$(DOCKER_COMPOSE_CMD) build

build-prod:         ## Build production images.
	bin/build

start:              ## Start all containers.
	$(DOCKER_COMPOSE_CMD) up -d --remove-orphans

stop:               ## Stop all containers.
	$(DOCKER_COMPOSE_CMD) down

console:            ## Open a console in the app container.
	$(DOCKER_COMPOSE_CMD) exec app bash

test:               ## Run tests.
	$(DOCKER_COMPOSE_CMD) exec app yarn test

.PHONY: help build start stop console test

TAG=$(shell git describe --abbrev=0 --tags)
MAKEFILE_DIR=$(PWD)

.PHONY: help
help:
	@echo "+------------------+"
	@echo "| Makefile Targets |"
	@echo "+------------------+"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-12s\033[0m %s\n", $$1, $$2}'

.PHONY: build
build: ## Build project
	@echo "+---------------------+"
	@echo "| Building Containers |"
	@echo "+---------------------+"

	docker-compose build

.PHONY: up
up: ## Start development environment.
	@echo "+-----------------------------+"
	@echo "| Starting docker environment |";
	@echo "+-----------------------------+"

	docker-compose up

.PHONY: down
down: ## Bring down development environment.
	@echo "+-----------------------------+"
	@echo "| Stopping docker environment |";
	@echo "+-----------------------------+"

	docker-compose down

.PHONY: shell
shell: ## Start shell into web container.
	@echo "Starting shell in web container";
	docker-compose up -d

	docker exec -i -t polls_django /bin/bash

.PHONY: shell-db
shell-db: ## Start shell into db container.
	@echo "Starting shell in db container";
	docker-compose up -d

	docker exec -i -t polls_db /bin/bash

.PHONY: psql
psql: ## Start psql into db container.
	@echo "Starting psql session in db container";
	docker-compose up -d

	docker exec -i -t polls_db psql -U siteuser

.PHONY: log
log: ## Start logging on all containers.
	@echo "Starting logs for the web container.";

	docker-compose logs -f

.PHONY: local-dump
local-dump: ## Shell into local db and perform pg_dumpall
	# This can be used to replace dockerfile initdb.sh but probably shouldn't
	@echo "Dumping database..."

	docker exec -i -t polls_db pg_dumpall -U dumbo > ./db-backup.sql

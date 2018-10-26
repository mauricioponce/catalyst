help:
	@echo '--------------------------------------------------------------------------'
	@echo '|                            Catalysts help commands                      |'
	@echo '--------------------------------------------------------------------------'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

#-----------------------------------------------
# Variables
#-----------------------------------------------
TAG=latest

IMAGE_NAME=catalystdev:$(TAG)
CONTAINER_NAME=catalystdev

#-----------------------------------------------
# Phony targets
#-----------------------------------------------
.SILENT :
.PHONY: up stop ps c logs clean relaunch build-base-image build-dev-image build-images

#-----------------------------------------------
# Containers
#-----------------------------------------------
up: ## Container up!
	@docker-compose -f docker-compose.yml up -d

stop: ## Container down!
	@docker-compose stop

ps: ## Container status
	@docker-compose ps

logs: ## logs
	@docker-compose logs -f

clean: ## remove container
	@docker rm $(CONTAINER_NAME)

c: ## execute a shell into container
	@docker exec -ti $(CONTAINER_NAME) /bin/bash

relaunch: ## stop, clean, build-images up ps
	$(MAKE) stop clean build-images up ps

#-----------------------------------------------
# Image
#-----------------------------------------------
build-images: ## Build both base and dev images
	$(MAKE) build-base-image build-dev-image

build-base-image: ## Build base image
	@docker build -t enigmampc/catalyst -f Dockerfile .

build-dev-image: ## Build dev image using base image
	@docker build -t enigmampc/catalystdev -f Dockerfile-dev .


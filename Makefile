# This file contains all the necessary build instructions for Dragon Bot Z
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

# Function definitions
# Allow commands name to be the same as directories name
.PHONY: character-service portal-service

# Simply prints "DONE" to the terminal
define print_done
	@echo "DONE"
endef

# Builds a service builder
#
# # Arguments
# * (1) dir - path to the service
# * (2) out - the output name of the newly built service builder
define build_service_builder
	@echo "Building $(2)..."
	@docker build . \
		-f generic-builder.Dockerfile \
		-t $(2) \
		--build-arg SERVICE_DIR=$(1)
endef

# Builds a service
#
# # Arguments
# * (1) file - the Dockerfile name
# * (2) out - the name of the newly built service
# * (3) builder - the name of the service builder to use
define build_service
	@echo "Building $(2)...\c"
	@docker run \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e DOCKERFILE=$(1) \
		-e OUTPUT=$(2) \
		$(3)		
endef

# Removes a Docker image
#
# # Arguments
# * (1) image - the name of the image to remove
define remove_image
	@echo "Removing $(1) image...\c"
	@docker image rm -f $(1)
	$(call print_done)
endef

# Creates a Docker volume
#
# # Arguments
# * (1) name - the name of the volume to create
define create_volume
	@echo "Creating $(1)...\c"
	@docker volume create $(1)
	$(call print_done)
endef

# Runs docker compose
define compose_up
	@echo "Runnin docker compose..."
	@docker compose up -d
endef

# Stops docker compose
define compose_down
	@echo "Stopping docker compose..."
	@docker compose down
endef

# Initializes a service's database
#
# Note: The init script name must be "init_database.sql"
#
# # Arguments
# * (1) script - init script path
# * (2) container - service's database container
define init_service_database
	$(call compose_up)
	@echo "Initializing database of $(2)..."
	@docker cp $(1) $(2):/var/lib/postgresql/data
	@docker exec -u postgres $(2) psql -f /var/lib/postgresql/data/init_database.sql
	$(call compose_down)
endef

# COMMANDS

# Build
all: services init clear

# Clear
clear: clear-images-builder

# Clear builder images
clear-images-builder:
	$(call remove_image,dbz-character-service-builder)
	$(call remove_image,dbz-portal-service-builder)

# Services
## Init all services
init: init-volumes init-databases

## Build all services
services: 	character-service \
			portal-service \

## Character service
### Builds the character service
character-service: character-service-builder
	$(call build_service,service.Dockerfile,dbz-character-service,dbz-character-service-builder)

### Builds the character service builder
character-service-builder:
	$(call build_service_builder,character-service,dbz-character-service-builder)

## Portal service
### Builds the portal service
portal-service: portal-service-builder
	$(call build_service,service.Dockerfile,dbz-portal-service,dbz-portal-service-builder)
	
### Builds the portal service builder
portal-service-builder:
	$(call build_service_builder,portal-service,dbz-portal-service-builder)

## Initializes the required external volumes
init-volumes:
	$(call create_volume,dbz-character-database-volume)
	$(call create_volume,dbz-portal-database-volume)

## Initializes databases
init-databases:
	$(call init_service_database,character-service/res/init_database.sql,dbz-character-database)

# This file contains all the necessary build instructions for Dragon Bot Z
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

# Building all services
all: 	pull-services \
		service-character-builder print-done \
		service-character print-done \
		clear-images-builder print-done 

pull-services: pull-character-service print-done

print-done:
	@echo "DONE"

pull-character-service:
	@echo "[CHARACTER SERVICE] Pulling Character service...\c"
	@cd character-service; \
		git pull --recurse-submodules --quiet

# Builds the character service builder
service-character-builder:
	@echo "[SERVICE CHARACTER BUILDER] Building service character builder...\c"
	@docker build . \
		-f generic-builder.Dockerfile \
		-t dbz-character-service-builder \
		--build-arg SERVICE_DIR=character-service \
		--quiet

# Builds the character service
service-character:
	@echo "[SERVICE CHARACTER] Building Character service image...\c"
	@docker run \
		-v /var/run/docker.sock:/var/run/docker.sock \
		-e DOCKERFILE=Dockerfile \
		-e OUTPUT=dbz-character-service \
		dbz-character-service-builder

# Clear builder images
clear-images-builder:
	@echo "[CLEAR IMAGES] Clearing images..."
	@docker image rm -f dbz-character-service-builder

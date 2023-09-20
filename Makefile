# This file contains all the necessary build instructions for Dragon Bot Z
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

# Building all services
all: 	pull-services \
		service-character print-done

pull-services: 	pull-character-service print-done

print-done:
	@echo "DONE"

pull-character-service:
	@echo "[CHARACTER SERVICE] Pulling Character service...\c"
	@cd character-service; \
		git pull --recurse-submodules --quiet

# Builds the character service
service-character:
	@echo "[SERVICE CHARACTER] Building Character service image...\c"
	@docker build . \
		-f character-service/Dockerfile \
		-t dbz-character-service \
		--no-cache \
		--quiet \
		&>/dev/null

clear-images:
	@echo "[CLEAR IMAGES] Clearing images..."
	@docker image rm -f dbz-character-service &>/dev/null 
	@echo "[CLEAR IMAGES] Character service image removed successfuly"
	@docker image rm -f $$(docker image ls | grep '<none>' | awk '{print $$3}') &>/dev/null
	@echo "[CLEAR IMAGES] Untagged images removed successfuly"
	@echo "[CLEAR IMAGES] Images cleared"

# This file contains all the necessary build instructions for Dragon Bot Z
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

# Building all services
all: service-character

# Builds the character service
service-character:
	@echo "Building Character service image...\c"
	@docker build . \
		-f character-service/Dockerfile \
		-t dbz-character-service
	@echo "DONE"

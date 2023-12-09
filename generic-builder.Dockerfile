# This file contains the instructions to build Dragon Bot Z images in a 
# generic manner
#
# # Usage
# To build a service, run the following command:
# ```bash
# $ docker build . \
# 		-f generic-builder.Dockerfile \
#		-t dbz-service-builder \
#		--build-arg SERVICE_DIR=PATH_TO_SERVICE \
#
# $ docker run \
#		-v /var/run/docker.sock:/var/run/docker.sock \
#		-e DOCKERFILE=DOCKERFILE_NAME \
#		-e OUTPUT=OUTPUT_NAME \
#		dbz-service-builder	
# ```
#
# # Arguments
# * SERVICE_DIR - the path to the service to build. The path should not be an absolute path
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

FROM debian:12.1-slim

# the service's path
ARG SERVICE_DIR

RUN apt-get update && apt-get install -y \
	curl \
	gcc \
	libssl-dev \
	pkg-config

# installing rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR sources
COPY ${SERVICE_DIR}/ .

RUN $HOME/.cargo/bin/cargo build --release --jobs=-1

# installing docker
RUN curl https://get.docker.com | sh -

CMD ["sh", "-c", "docker build . -f ${DOCKERFILE} -t ${OUTPUT} --no-cache"]

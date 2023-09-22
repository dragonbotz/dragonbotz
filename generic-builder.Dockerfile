# This file contains the instructions to build Dragon Bot Z images in a 
# generic manner
#
# # Usage
# To build a service, run the following command:
# ```bash
# $ docker build . \
#		-v /var/run/docker.sock:/var/run/docker.sock
# 		-f generic-builder.Dockerfile \
#		--build-arg PATH=PATH_TO_SERVICE \
#		--build-arg FILE=DOCKERFILE_NAME
# ```
#
# ## Arguments
# * PATH - the path to the service to build. The path should not be an absolute path
# * FILE - the name of the service's Dockerfile, by default it is set to "Dockerfile"
# * OUT - the output (Docker image) name
#
# Authors: Lahcène Belhadi <lahcene.belhadi@gmail.com>

FROM debian:12.1-slim

# the service's path
ARG SERVICE_DIR
ARG FILE=Dockerfile
ARG OUT=dbz-${SERVICE_DIR}

ENV DOCKERFILE ${FILE}
ENV OUTPUT ${OUT}

RUN apt-get update && apt-get install -y \
	curl \
	docker \
	git \
	gcc \
	libssl-dev \
	pkg-config

# installing rust tools
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

WORKDIR sources
COPY ${SERVICE_DIR}/ .

RUN $HOME/.cargo/bin/cargo build

# installing docker
RUN curl https://get.docker.com | sh -

CMD ["sh", "-c", "docker build . -f ${DOCKERFILE} -t ${OUTPUT} --no-cache"]

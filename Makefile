# Taken from Tim Pouyer's Build Harness

# Docker client
DOCKER := $(shell which docker)

# Jot is for OSX, and shuf is for Linux
RANDOM_PORT ?= $(shell jot -r 1  2000 65000 || shuf -i 2000-65000 -n 1)

DOCKER_REGISTRY ?= 
DOCKER_NAMESPACE ?= 

DOCKER_CLIENT_VERSION = $(shell $(DOCKER) version --format={{.Client.Version}} 2>/dev/null)
DOCKER_SERVER_VERSION = $(shell $(DOCKER) version --format={{.Server.Version}} 2>/dev/null)

# These vars are are used by the `login` target.
DOCKER_USER ?=
DOCKER_PASS ?=

# The image we're building - defaults to the current directory name
DOCKER_IMAGE ?=
DOCKER_IMAGE_ARCH = $(DOCKER_IMAGE)-$(BUILD_HARNESS_ARCH)

# Tag used when building image
DOCKER_BUILD_TAG ?= latest

# Tag used when tagging image built with DOCKER_BUILD_TAG and tag pushed to repo
DOCKER_TAG ?= $(DOCKER_BUILD_TAG)

# Complete URI to docker image
DOCKER_URI ?= $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):$(DOCKER_TAG)
DOCKER_URI_LATEST ?= $(DOCKER_REGISTRY)/$(DOCKER_IMAGE):latest
DOCKER_ARCH_URI ?= $(DOCKER_REGISTRY)-$(DOCKER_IMAGE_ARCH):$(DOCKER_TAG)

# Path to build (where the Dockerfile is located)
DOCKER_BUILD_PATH ?= .

# The default dockerfile name used
DOCKER_FILE ?= Dockerfile

# If attempting to start the container, this name will be used
DOCKER_CONTAINER_NAME ?= test_$(DOCKER_IMAGE)

DOCKER_BIND_PORT ?= $(RANDOM_PORT):5000
DOCKER_SHELL ?= /bin/bash

# Arguments passed to "docker build"
DOCKER_BUILD_OPTS ?=

DOCKER_FROM_USER ?= $(DOCKER_USER)
DOCKER_FROM_PASS ?= $(DOCKER_PASS)
DOCKER_FROM_REGISTRY ?= $(DOCKER_REGISTRY)
DOCKER_FROM_NAMESPACE ?= $(DOCKER_NAMESPACE)
DOCKER_FROM_IMAGE ?= $(DOCKER_IMAGE)
DOCKER_FROM_TAG ?= $(DOCKER_TAG)
DOCKER_TO_USER ?= $(DOCKER_USER)
DOCKER_TO_PASS ?= $(DOCKER_PASS)
DOCKER_TO_REGISTRY ?= $(DOCKER_FROM_REGISTRY)
DOCKER_TO_NAMESPACE ?= $(DOCKER_FROM_NAMESPACE)
DOCKER_TO_IMAGE ?= $(DOCKER_FROM_IMAGE)
DOCKER_TO_TAG ?= $(DOCKER_FROM_TAG)
DOCKER_ADDTL_TAG ?=

.PHONY : docker\:info docker\:build docker\:push docker\:pull docker\:clean docker\:run docker\:shell docker\:attach docker\:update docker\:start docker\:stop docker\:rm docker\:logs docker\:manifest-tool docker\:enable-experimental-cli docker\:multi-arch docker\:copy


## Display info about the docker environment
docker\:info:
	@echo "DOCKER=$(DOCKER)"
	@echo "DOCKER_IMAGE=$(DOCKER_IMAGE)"
	@echo "DOCKER_IMAGE_ARCH=$(DOCKER_IMAGE_ARCH)"
	@echo "DOCKER_BUILD_TAG=$(DOCKER_BUILD_TAG)"
	@echo "DOCKER_TAG=$(DOCKER_TAG)"
	@echo "DOCKER_CONTAINER_NAME=$(DOCKER_CONTAINER_NAME)"
	@echo "DOCKER_BUILD_OPTS=$(DOCKER_BUILD_OPTS)"
	@echo "DOCKER_FILE=$(DOCKER_FILE)"
	@echo "DOCKER_REGISTRY=$(DOCKER_REGISTRY)"
	@echo "DOCKER_NAMESPACE=$(DOCKER_NAMESPACE)"
	@echo "DOCKER_URI=$(DOCKER_URI)"
	@echo "DOCKER_ARCH_URI=$(DOCKER_ARCH_URI)"
	@echo "DOCKER_CLIENT_VERSION=$(DOCKER_CLIENT_VERSION)"
	@echo "DOCKER_SERVER_VERSION=$(DOCKER_SERVER_VERSION)"

## Build a docker image
docker\:build:
	@echo "INFO: Building $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) using $(DOCKER_BUILD_PATH)/$(DOCKER_FILE) on docker $(DOCKER_SERVER_VERSION) $(DOCKER_BUILD_OPTS)"
	@cd $(DOCKER_BUILD_PATH) && $(DOCKER) build $(DOCKER_BUILD_OPTS) -t "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" -f $(DOCKER_FILE) .

## Push image to Docker Hub
docker\:push:
	@echo "INFO: Pushing $(DOCKER_URI)"
	@until $(DOCKER) push "$(DOCKER_URI)"; do sleep 1; done

## Push image to Docker Hub
docker\:push-and-latest:
	@echo "INFO: Pushing $(DOCKER_URI)"
	@echo "INFO: Pushing $(DOCKER_URI_LATEST)"
	@until $(DOCKER) push "$(DOCKER_URI)"; do sleep 1; done
	@until $(DOCKER) push "$(DOCKER_URI_LATEST)"; do sleep 1; done


## Push the architecture-specific image to a Docker registry
docker\:push-arch:
	@echo "INFO: Pushing $(DOCKER_ARCH_URI)"
	@until $(DOCKER) push "$(DOCKER_ARCH_URI)"; do sleep 1; done

## Pull docker image from Docker Hub
docker\:pull:
	@echo "INFO: Pulling $(DOCKER_URI)"
	@$(DOCKER) pull "$(DOCKER_URI)"

## Test docker image
docker\:test:
	@$(DOCKER) version 2>&1 >/dev/null | grep 'Error response from daemon'; [ $$? -ne 0 ]
	@echo "OK"

## Tag the last built image with an architecture-specific`DOCKER_TAG`
docker\:tag:
	@echo INFO: Tagging $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) as $(DOCKER_URI)
ifeq ($(findstring 1.9.1,$(DOCKER_SERVER_VERSION)),1.9.1)
	@$(DOCKER) tag -f "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI)"
else
	@$(DOCKER) tag "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI)"
endif

## Tag the last built image with an architecture-specific`DOCKER_TAG`
docker\:tag-and-latest:
	@echo INFO: Tagging $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) as $(DOCKER_URI)
	@echo INFO: Tagging $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) as $(DOCKER_URI_LATEST)
ifeq ($(findstring 1.9.1,$(DOCKER_SERVER_VERSION)),1.9.1)
	@$(DOCKER) tag -f "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI)"
	@$(DOCKER) tag -f "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI_LATEST)"
else
	@$(DOCKER) tag "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI)"
	@$(DOCKER) tag "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" "$(DOCKER_URI_LATEST)"
endif

## Remove existing docker images
docker\:clean:
	@echo INFO: Clean $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG), $(DOCKER_URI)
	@$(DOCKER) rmi -f "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)"
	@$(DOCKER) rmi -f "$(DOCKER_URI)"
	$(eval DOCKER_BUILD_OPTS += --no-cache=true)

## Test drive the image
docker\:run:
	@echo "INFO: Running $(DOCKER_IMAGE):$(DOCKER_BUILD_TAG) as $(DOCKER_CONTAINER_NAME) with ports $(DOCKER_BIND_PORT)"
	@$(DOCKER) run --name "$(DOCKER_CONTAINER_NAME)" --rm -p "$(DOCKER_BIND_PORT)" -t -i "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)"

## Run the container and start a shell
docker\:shell:
	@echo INFO: Starting shell in $(DOCKER_IMAGE) as $(DOCKER_CONTAINER_NAME) with $(DOCKER_BIND_PORT)
	@$(DOCKER) run --name "$(DOCKER_CONTAINER_NAME)" --rm -p "$(DOCKER_BIND_PORT)" -t -i --volume "$(shell pwd):/opt" --entrypoint="$(DOCKER_SHELL)"  "$(DOCKER_IMAGE):$(DOCKER_BUILD_TAG)" -c $(DOCKER_SHELL)

## Attach to the running container
docker\:attach:
	@echo INFO: Attaching to $(DOCKER_CONTAINER_NAME)
	@$(DOCKER) exec -i -t  "$(DOCKER_CONTAINER_NAME)" $(DOCKER_SHELL)

## Login to docker registry
docker\:login:
	@$(call assert_set,DOCKER_USER)
	@$(call assert_set,DOCKER_PASS)
	@echo "INFO: Logging in as $(DOCKER_USER)"
	@$(DOCKER) login $(DOCKER_REGISTRY) -u $(DOCKER_USER) -p $(DOCKER_PASS) || $(DOCKER) login -u $(DOCKER_USER) -p $(DOCKER_PASS)

MKFILE_DIR := $(abspath $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST))))))
IMAGE_NAME ?= Richard-Barrett/spectacles-workflow
IMAGE_TAG ?= latest_$(RELEASE)
BRANCH ?= $(git rev-parse --symbolic --abbrev-ref HEAD)
PROJECT ?= dataops-looker
RELEASE ?= $(git tag --sort=committerdate | tail -1)
MOD_PATH := github.com/Richard-Barrett/spectacles-workflow
DOCKER_FLAGS := -v $(MKFILE_DIR)

# Make Container Build
.PHONY: build
build:
	docker build ${MKFILE_DIR}/spectacles/ -t ${IMAGE_NAME}:${IMAGE_TAG}

# Make Container with tty terminal into /bin/bash
.PHONY: container
container:
	docker run --rm -it --entrypoint /bin/bash ${IMAGE_NAME} 

# Read secret value from an environment variable
.PHONY: get-gh-secret
get-gh-secret:
	gh secret list

# Make Docker Push on Tagged Image
.PHONY: push
push:
	docker image push ${IMAGE_NAME}:${BRANCH}_${RELEASE}

# Make Container Tag
.PHONY: tag
tag:
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):$(BRANCH)_$(RELEASE)

.PHONY: validate-lookml
validate-lookml:
	docker run --rm -it -e LOOKER_BASE_URL=${LOOKER_BASE_URL} \
	 	-e LOOKER_CLIENTID=${LOOKER_CLIENTID} \
		-e LOOKER_CLIENT_SECRET=${LOOKER_CLIENTSECRET} ${IMAGE_NAME} \
		lookml \
		--base-url ${LOOKER_BASE_URL} \
		--client-id ${LOOKER_CLIENTID} \
		--client-secret ${LOOKER_CLIENTSECRET} \
		--project ${PROJECT} \
		--branch ${BRANCH}

# Spectacles Documentation: https://docs.spectacles.dev/cli/reference/global-flags/
.PHONY: validate-sql
validate-sql:
	docker run --rm -it -e LOOKER_BASE_URL=${LOOKER_BASE_URL} \
	 	-e LOOKER_CLIENTID=${LOOKER_CLIENTID} \
		-e LOOKER_CLIENT_SECRET=${LOOKER_CLIENTSECRET} ${IMAGE_NAME} \
		sql \
  		--base-url ${LOOKER_BASE_URL} \
		--client-id ${LOOKER_CLIENTID} \
		--client-secret ${LOOKER_CLIENTSECRET} \
		--project ${PROJECT} \
		--branch ${BRANCH} \
		--explores * \
		--concurrency 40 \
		--profile

.PHONY: validate-content
validate-content:
	docker run --rm -it -e LOOKER_BASE_URL=${LOOKER_BASE_URL} \
	 	-e LOOKER_CLIENTID=${LOOKER_CLIENTID} \
		-e LOOKER_CLIENT_SECRET=${LOOKER_CLIENTSECRET} ${IMAGE_NAME} \
		content \
		--base-url ${LOOKER_BASE_URL} \
		--client-id ${LOOKER_CLIENTID} \
		--client-secret ${LOOKER_CLIENTSECRET} \
		--project ${PROJECT} \
		--branch ${BRANCH}
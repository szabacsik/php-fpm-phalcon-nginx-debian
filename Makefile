# Docker Hub username and base image configuration
DOCKER_HUB_USER := szabacsik
BASE_IMAGE_NAME := php-fpm-phalcon-nginx-bookworm
IMAGE_NAME := $(DOCKER_HUB_USER)/$(BASE_IMAGE_NAME)
IMAGE_TAG := latest
CONTAINER_NAME := $(DOCKER_HUB_USER)-$(BASE_IMAGE_NAME)-container

# Default target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  build        - Build the Docker image"
	@echo "  start        - Start a container from the image"
	@echo "  stop         - Stop and remove the container"
	@echo "  logs         - View logs of the container"
	@echo "  shell        - Open a bash shell in a new container (container is removed after exit)"
	@echo "  versions     - Query and display versions of PHP, Phalcon, Nginx, and Debian as JSON"
	@echo "  version-tag  - Output combined version tag in the format: phpW-phcX-ngY-debZ"
	@echo "  tag-latest   - Generate version tag and apply it to the built image"
	@echo "  docker-login - Log into Docker Hub"
	@echo "  push-latest  - Push the latest tag to Docker Hub"
	@echo "  push-version - Tag and push versioned image to Docker Hub"
	@echo "  push-all     - Push both latest and versioned tags to Docker Hub"
	@echo "  help         - Show this help message"

# Build the Docker image
.PHONY: build
build:
	@echo "Removing previous image if exists..."
	-docker rmi --force $(IMAGE_NAME):$(IMAGE_TAG) || true
	@echo "Building Docker image $(IMAGE_NAME):$(IMAGE_TAG)..."
	@DOCKER_BUILDKIT=1 docker build --progress=plain --no-cache -t $(IMAGE_NAME):$(IMAGE_TAG) . > docker-build.log 2>&1
	@echo "Build complete! Full log saved to docker-build.log"

# Start a container from the image
.PHONY: start
start:
	@echo "Starting container $(CONTAINER_NAME) from image $(IMAGE_NAME):$(IMAGE_TAG)..."
	docker run --rm -d -p 8080:8080 --name $(CONTAINER_NAME) $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Container started! Access the application at http://localhost:8080"

# Stop and remove the container
.PHONY: stop
stop:
	@echo "Stopping container $(CONTAINER_NAME)..."
	docker stop $(CONTAINER_NAME) || true
	@echo "Container stopped and removed!"

# View logs of the container
.PHONY: logs
logs:
	@echo "Viewing logs of container $(CONTAINER_NAME)..."
	docker logs $(CONTAINER_NAME)

# Open a bash shell in a new container
.PHONY: shell
shell:
	@echo "Opening bash shell in a new container (will be removed after exit)..."
	docker run --rm -it --entrypoint bash --name $(DOCKER_HUB_USER)-$(BASE_IMAGE_NAME)-shell $(IMAGE_NAME):$(IMAGE_TAG)
	@echo "Container has been removed."

# Query and display versions as JSON
.PHONY: versions
versions:
	@echo "Querying service versions..."
	@docker run --rm --entrypoint /bin/bash -v $$PWD/scripts/detect-versions.sh:/detect-versions.sh $(IMAGE_NAME):$(IMAGE_TAG) /detect-versions.sh --json

# Output combined version tag in format: phpW-phcX-ngY-debZ
.PHONY: version-tag
version-tag:
	@docker run --rm --entrypoint /bin/bash -v $$PWD/scripts/detect-versions.sh:/detect-versions.sh $(IMAGE_NAME):$(IMAGE_TAG) /detect-versions.sh --tag

# Tag the image with generated version tag
.PHONY: tag-latest
tag-latest:
	@echo "Generating version tag and applying to image..."
	@TAG=$$(docker run --rm --entrypoint /bin/bash -v $$PWD/scripts/detect-versions.sh:/detect-versions.sh $(IMAGE_NAME):$(IMAGE_TAG) /detect-versions.sh --tag); \
	docker tag $(IMAGE_NAME):$(IMAGE_TAG) $(IMAGE_NAME):$$TAG; \
	echo "Tagged as: $(IMAGE_NAME):$$TAG"

# Docker Hub login
.PHONY: docker-login
docker-login:
	@echo "Logging into Docker Hub..."
	docker login

# Push 'latest' tag to Docker Hub
.PHONY: push-latest
push-latest:
	@echo "Pushing latest image to Docker Hub..."
	docker push $(IMAGE_NAME):latest

# Push versioned tag to Docker Hub
.PHONY: push-version
push-version:
	@echo "Tagging and pushing versioned image to Docker Hub..."
	@TAG=$$(docker run --rm \
		-v $$PWD/scripts/detect-versions.sh:/usr/local/bin/detect-versions.sh:ro \
		--entrypoint bash $(IMAGE_NAME):latest -c '/usr/local/bin/detect-versions.sh --tag') && \
	docker tag $(IMAGE_NAME):latest $(IMAGE_NAME):$$TAG && \
	docker push $(IMAGE_NAME):$$TAG && \
	echo "Pushed as: $(IMAGE_NAME):$$TAG"

# Push both tags
.PHONY: push-all
push-all: push-latest push-version

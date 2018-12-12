

MAJOR_VERSION=0
MINOR_VERSION_FILE=docker-build-minor-version.txt

BUILD_VERSION=$(MAJOR_VERSION).$(cat $(MINOR_VERSION_FILE))
BUILD_VERSION_FILE=docker-build-version.txt

DOCKER_IMAGE="khultman/cci-terraform"

all: docker-build docker-push

docker-build: $(MINOR_VERSION_FILE)
	docker build --no-cache=true \
	             --build-arg BUILD_DATE=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
	             -t $(DOCKER_IMAGE):$(BUILD_VERSION) \
	             -t $(DOCKER_IMAGE):latest \
	             .
	echo ${BUILD_VERSION} > $(BUILD_VERSION_FILE)

docker-push:
	docker push $(DOCKER_IMAGE):$(BUILD_VERSION)
	docker push $(DOCKER_IMAGE):latest

docker-run:
	docker run

docker-run-interactive:
	docker run -it --rm khultman/cci-terraform:latest /bin/ash

$(MINOR_VERSION_FILE): $(BUILD_VERSION_FILE)
	@if ! test -f $(MINOR_VERSION_FILE); then echo 0 > $(MINOR_VERSION_FILE); fi
	@echo $$(($$(cat $(MINOR_VERSION_FILE)) + 1)) > $(MINOR_VERSION_FILE)

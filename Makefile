# make build CPU=amd64

CPU := amd64
REPO ?= walkero/browservice
TAG ?= latest-$(CPU)
VOLUMES ?= -v "${PWD}/../code":/opt/code
WORKSPACE ?= -w /release/bin/
NAME ?= browservice-$(CPU)
PORTS ?= -p 8088:8080

.PHONY: build buildnc shell push logs clean test release

default: build

build:
	docker build -t $(REPO):$(TAG) \
		--build-arg CPU=$(CPU) .

buildnc:
	docker build --no-cache -t $(REPO):$(TAG) \
		--build-arg CPU=$(CPU) .

shell:
	docker run -it --rm --name $(NAME) $(WORKSPACE) $(PORTS) $(REPO):$(TAG) /bin/bash

push:
	docker push $(REPO):$(TAG)

logs:
	docker logs $(NAME)

clean:
	-docker rm -f $(NAME)

test:
	snyk test --docker $(REPO):$(TAG) --file=Dockerfile

release: buildnc push

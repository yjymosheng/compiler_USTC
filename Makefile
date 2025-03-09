LAB   ?= lab2
DIR := /home/mosheng/code/compiler_USTC
DOCKER_NAME=compiler

docker:
	@docker run --rm -v $(DIR)/$(LAB):/workspace -it $(DOCKER_NAME)

build_docker:
	@docker build -t $(DOCKER_NAME) .

clean_docker:
	@docker rmi $(DOCKER_NAME)

help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... docker LAB=lab{x}   LAB?=lab1"
	@echo "... build_docker"
	@echo "... clean_docker"

.PHONY: docker build_docker clean_docker help
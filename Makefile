LAB   ?= lab2
DIR := /home/mosheng/code/compiler_USTC
DOCKER_NAME=compiler

docker:
	@docker run --rm -v $(DIR)/$(LAB):/workspace -it $(DOCKER_NAME)

build_docker:
	@docker build -t $(DOCKER_NAME) .

clean_docker:
	@docker rmi $(DOCKER_NAME)

getown:
	@sudo chown mosheng:mosheng -R .

git:
	@git add ./*/src/*
	@git commit -m "update"
	@git push origin main

help:
	@echo "The following are some of the valid targets for this Makefile:"
	@echo "... docker LAB=lab{x}   LAB?=lab1"
	@echo "... build_docker"
	@echo "... clean_docker"
	@echo "... getown"
	@echo "... git"

.PHONY: docker build_docker clean_docker help git
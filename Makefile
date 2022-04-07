PROJECT_NAME=pfc-hello
PROJECT_ROOT=$(shell realpath .)

-include $(PROJECT_ROOT)/config.mk

OUT_DIR = $(PROJECT_ROOT)/build

USERID ?= $(shell id -u)
USERID := $(USERID)

SOURCE_DIR=$(PROJECT_ROOT)/src
SOURCE_FILES=$(wildcard src/*)

BUILDER=$(PROJECT_NAME)-builder
IMAGE=$(PROJECT_NAME)

.PHONY: all
all: image

.PHONY: builder
builder: $(OUT_DIR)/$(BUILDER).id

$(OUT_DIR)/root.tgz: $(OUT_DIR)/$(BUILDER).id $(SOURCE_FILES) | $(OUT_DIR)
	docker run --rm -it --user "$(USERID)" -v "$(SOURCE_DIR):/home/user/ptxproj/local_src/hello" -v "$(OUT_DIR):/backup" $(BUILDER) build

$(OUT_DIR)/$(BUILDER).id: docker/builder.dockerfile  Makefile | $(OUT_DIR)
	docker buildx build --build-arg 'USERID=$(USERID)' --no-cache --iidfile $@ --file $< --tag $(BUILDER) .

.PHONY: run
run: builder
	docker run --rm -it --user "$(USERID)" -v "$(SOURCE_DIR):/home/user/ptxproj/local_src/hello" -v "$(OUT_DIR):/backup" $(BUILDER) bash

.PHONY: image
image: $(OUT_DIR)/$(IMAGE).id

$(OUT_DIR)/$(IMAGE).id: docker/image.dockerfile  Makefile $(OUT_DIR)/root.tgz
	docker buildx build --no-cache --platform linux/arm/v7 --iidfile $@ --file $< --tag $(IMAGE) .
	docker save -o $(OUT_DIR)/$(IMAGE).dockerimage $(IMAGE)

.PHONY: clean
clean:
	rm -rf $(OUT_DIR)

.PHONY: distclean
distclean: clean
	-docker rmi $(IMAGE)
	-docker rmi $(BUILDER)

$(OUT_DIR):
	mkdir -p $@
	chmod a+w $@

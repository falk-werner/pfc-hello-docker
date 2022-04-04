OUT_DIR = build
GEN_DIRS += $(OUT_DIR)

USERID ?= $(shell id -u)
USERID := $(USERID)
DOCKER_BUILDFLAGS += --build-arg 'USERID=$(USERID)'


.PHONY: all
all: image

.PHONY: builder
builder: $(OUT_DIR)/pfc-hello-builder

$(OUT_DIR)/root.tgz: builder | $(OUT_DIR)
	docker run --rm -it --user "$(USERID)" -v "`realpath $(OUT_DIR)`:/backup" pfc-hello-builder cp /home/user/ptxproj/platform-wago-pfcXXX/images/root.tgz /backup

$(OUT_DIR)/pfc-hello-builder: docker/builder.dockerfile  Makefile | $(OUT_DIR)
	docker buildx build $(DOCKER_BUILDFLAGS) --iidfile $@ --file $< --tag pfc-hello-builder .

.PHONY: run
run: builder | $(IMAGE_DIR)
	docker run --rm -it --user "$(USERID)" -v "`realpath $(OUT_DIR)`:/backup" pfc-hello-builder bash

.PHONY: image
image: $(OUT_DIR)/pfc-hello

$(OUT_DIR)/pfc-hello: docker/image.dockerfile  Makefile $(OUT_DIR)/root.tgz | $(OUT_DIR)
	docker buildx build $(DOCKER_BUILDFLAGS) --platform linux/arm/v7 --iidfile $@ --file $< --tag pfc-hello .
	docker save -o $(OUT_DIR)/pfc-hello.dockerimage pfc-hello

.PHONY: clean
clean:
	rm -rf $(GEN_DIRS)

$(GEN_DIRS):
	mkdir -p $@

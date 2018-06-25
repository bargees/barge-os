KERNEL_VERSION  := 4.14.47
BUSYBOX_VERSION := 1.28.4

OUTPUTS := output/rootfs.tar.xz output/bzImage output/barge.iso output/barge.img

BUILD_IMAGE     := barge-builder
BUILD_CONTAINER := barge-built

IS_BUILT := `docker ps -aq -f name=$(BUILD_CONTAINER) -f exited=0`
IMAGE_ID := `docker inspect -f '{{.ID}}' $(BUILD_IMAGE) 2>/dev/null`

DL_DIR     := /mnt/data/dl
CCACHE_DIR := /mnt/data/ccache

all: $(OUTPUTS)

$(OUTPUTS): build | output
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/images/$(@F) output/

build:
	$(eval OLD_IMAGE_ID=$(IMAGE_ID))
	docker build -t $(BUILD_IMAGE) .
	@echo "$(OLD_IMAGE_ID)"
	@echo "$(IMAGE_ID)"
	@if [ "$(OLD_IMAGE_ID)" != "$(IMAGE_ID)" ]; then \
		(docker rm -f $(BUILD_CONTAINER) || true); \
	fi
	@echo "$(IS_BUILT)"
	@if [ "$(IS_BUILT)" = "" ]; then \
		set -e; \
		(docker rm -f $(BUILD_CONTAINER) || true); \
		docker run --privileged -v $(DL_DIR):/build/buildroot/dl \
			-v $(CCACHE_DIR):/build/buildroot/ccache --name $(BUILD_CONTAINER) $(BUILD_IMAGE); \
	fi

output:
	@mkdir -p $@

clean:
	-docker rm -f $(BUILD_CONTAINER)

distclean: clean
	-docker rmi $(BUILD_IMAGE)
	$(RM) -r output

.PHONY: all build clean distclean

config: | output
	docker cp $(BUILD_CONTAINER):/build/buildroot/.config output/buildroot.config
	-diff configs/buildroot.config output/buildroot.config
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/build/busybox-$(BUSYBOX_VERSION)/.config output/busybox.config
	-diff configs/busybox.config output/busybox.config
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/build/linux-$(KERNEL_VERSION)/.config output/kernel.config
	-diff configs/kernel.config output/kernel.config

.PHONY: config

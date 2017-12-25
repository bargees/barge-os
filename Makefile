KERNEL_VERSION  := 4.9.72
BUSYBOX_VERSION := 1.27.2

OUTPUTS := output/rootfs.tar.xz output/bzImage output/barge.iso output/barge.img
SOURCES := Dockerfile .dockerignore \
	$(shell find configs -type f) \
	$(shell find overlay -type f) \
	$(shell find patches -type f) \
	$(shell find scripts -type f)

BUILD_IMAGE     := barge-builder
BUILD_CONTAINER := barge-built

BUILT := `docker ps -aq -f name=$(BUILD_CONTAINER) -f exited=0`
STR_CREATED := $$(docker inspect -f '{{.Created}}' $(BUILD_IMAGE) 2>/dev/null)
IMG_CREATED := `date -j -u -f "%FT%T" "$(STR_CREATED)" +"%s" 2>/dev/null || echo 0`

DL_DIR     := /mnt/data/dl
CCACHE_DIR := /mnt/data/ccache

all: $(OUTPUTS)

$(OUTPUTS): build | output
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/images/$(@F) output/

build: $(SOURCES)
	$(eval SRC_UPDATED=$$(shell stat -f "%m" $^ | sort -gr | head -n1))
	@if [ "$(SRC_UPDATED)" -gt "$(IMG_CREATED)" ]; then \
		set -e; \
		find . -type f -name '.DS_Store' | xargs rm -f; \
		docker build -t $(BUILD_IMAGE) .; \
		if [ "$(IMG_CREATED)" -gt "$(SRC_UPDATED)" ]; then \
			(docker rm -f $(BUILD_CONTAINER) || true); \
		fi; \
	fi
	@if [ "$(BUILT)" = "" ]; then \
		set -e; \
		(docker rm -f $(BUILD_CONTAINER) || true); \
		docker run --privileged -v $(DL_DIR):/build/buildroot/dl \
			-v $(CCACHE_DIR):/build/buildroot/ccache --name $(BUILD_CONTAINER) $(BUILD_IMAGE); \
	fi

output:
	@mkdir -p $@

clean:
	$(RM) -r output
	-docker rm -f $(BUILD_CONTAINER)

distclean: clean
	-docker rmi $(BUILD_IMAGE)
	vagrant destroy -f
	$(RM) -r .vagrant

.PHONY: all build clean distclean

vagrant:
	vagrant up barge
	vagrant ssh barge -c 'sudo mkdir -p $(DL_DIR) $(CCACHE_DIR)'

dev:
	vagrant up barge-$@
	vagrant ssh barge-$@ -c 'sudo mkdir -p $(DL_DIR) $(CCACHE_DIR)'

config: | output
	docker cp $(BUILD_CONTAINER):/build/buildroot/.config output/buildroot.config
	-diff configs/buildroot.config output/buildroot.config
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/build/busybox-$(BUSYBOX_VERSION)/.config output/busybox.config
	-diff configs/busybox.config output/busybox.config
	docker cp $(BUILD_CONTAINER):/build/buildroot/output/build/linux-$(KERNEL_VERSION)/.config output/kernel.config
	-diff configs/kernel.config output/kernel.config

install:
	cp output/bzImage ../barge-packer/virtualbox/iso/
	cp output/rootfs.tar.xz ../barge-packer/virtualbox/iso/
	cp configs/kernel.config ../barge-packer/virtualbox/iso/
	cp configs/isolinux.cfg ../barge-packer/virtualbox/iso/
	cp output/barge.iso ../barge-packer/qemu/
	cp output/barge.img ../barge-packer/qemu/

.PHONY: vagrant dev config install

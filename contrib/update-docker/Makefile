BARGE_VERSION  := 2.8.2
DOCKER_CHANNEL := stable
DOCKER_VERSION := 18.03.1-ce

ISO_NAME := barge-x.iso

EXTERNAL_DEPENDENCIES := bzImage rootfs.tar.xz isolinux.cfg docker.tgz docker.bash-completion

iso: $(ISO_NAME)

$(ISO_NAME): Dockerfile docker $(EXTERNAL_DEPENDENCIES)
	docker build -t barge-x .
	docker run --rm barge-x > $@

bzImage rootfs.tar.xz:
	curl -L https://github.com/bargees/barge-os/releases/download/$(BARGE_VERSION)/$(@F) -o $@

isolinux.cfg:
	curl -L https://raw.githubusercontent.com/bargees/barge-os/$(BARGE_VERSION)/configs/$(@F) -o $@

docker.tgz:
	curl -L https://download.docker.com/linux/static/$(DOCKER_CHANNEL)/x86_64/docker-$(DOCKER_VERSION).tgz -o $@

docker.bash-completion:
	curl -L https://raw.githubusercontent.com/docker/docker-ce/v$(DOCKER_VERSION)/components/cli/contrib/completion/bash/docker -o $@

clean:
	$(RM) $(EXTERNAL_DEPENDENCIES)

distclean: clean
	$(RM) $(ISO_NAME)

.PHONY: clean distclean

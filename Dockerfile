FROM ailispaw/ubuntu-essential:14.04-nodoc

ENV TERM xterm

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends ca-certificates \
      bc build-essential cpio file git python unzip rsync wget \
      syslinux xorriso dosfstools mtools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup environment
ENV SRC_DIR=/build \
    OVERLAY=/overlay \
    BR_ROOT=/build/buildroot
RUN mkdir -p ${SRC_DIR} ${OVERLAY}

ENV BR_VERSION 2019.02-rc1
RUN wget -qO- https://buildroot.org/downloads/buildroot-${BR_VERSION}.tar.bz2 | tar xj && \
    mv buildroot-${BR_VERSION} ${BR_ROOT}

# Apply patches
COPY patches ${SRC_DIR}/patches
RUN for patch in ${SRC_DIR}/patches/*.patch; do \
      patch -p1 -d ${BR_ROOT} < ${patch}; \
    done

# Setup overlay
COPY overlay ${OVERLAY}
WORKDIR ${OVERLAY}

# Add ca-certificates
RUN mkdir -p etc/ssl/certs && \
    cp /etc/ssl/certs/ca-certificates.crt etc/ssl/certs/

# Add bash-completion
RUN mkdir -p usr/share/bash-completion/completions && \
    wget -qO usr/share/bash-completion/bash_completion https://raw.githubusercontent.com/scop/bash-completion/master/bash_completion && \
    chmod +x usr/share/bash-completion/bash_completion

# Add Docker bash-completion
ENV DOCKER_VERSION 1.10.3
RUN wget -qO usr/share/bash-completion/completions/docker https://raw.githubusercontent.com/moby/moby/v${DOCKER_VERSION}/contrib/completion/bash/docker

# Add dumb-init
ENV DINIT_VERSION 1.2.2
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DINIT_VERSION}/dumb-init_${DINIT_VERSION}_amd64 && \
    chmod +x usr/bin/dumb-init

ENV VERSION 2.12.0-rc1
RUN mkdir -p etc && \
    echo "Welcome to Barge ${VERSION}, Docker version ${DOCKER_VERSION}" > etc/motd && \
    echo "NAME=\"Barge\"" > etc/os-release && \
    echo "VERSION=${VERSION}" >> etc/os-release && \
    echo "ID=barge" >> etc/os-release && \
    echo "ID_LIKE=busybox" >> etc/os-release && \
    echo "VERSION_ID=${VERSION}" >> etc/os-release && \
    echo "PRETTY_NAME=\"Barge ${VERSION}\"" >> etc/os-release && \
    echo "HOME_URL=\"https://github.com/bargees/barge-os\"" >> etc/os-release && \
    echo "BUG_REPORT_URL=\"https://github.com/bargees/barge-os/issues\"" >> etc/os-release

# Add Package Installer
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/pkg https://raw.githubusercontent.com/bargees/barge-pkg/master/pkg && \
    chmod +x usr/bin/pkg

# Copy config files
COPY configs ${SRC_DIR}/configs
RUN cp ${SRC_DIR}/configs/buildroot.config ${BR_ROOT}/.config && \
    cp ${SRC_DIR}/configs/busybox.config ${BR_ROOT}/package/busybox/busybox.config

COPY scripts ${SRC_DIR}/scripts

VOLUME ${BR_ROOT}/dl ${BR_ROOT}/ccache

WORKDIR ${BR_ROOT}
CMD ["../scripts/build.sh"]

FROM ailispaw/ubuntu-essential:14.04

ENV TERM xterm

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends ca-certificates \
      bc build-essential cpio file python unzip rsync wget \
      syslinux xorriso dosfstools mtools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup environment
ENV SRC_DIR=/build \
    OVERLAY=/overlay \
    BR_ROOT=/build/buildroot
RUN mkdir -p ${SRC_DIR} ${OVERLAY}

ENV BR_VERSION 2016.02
RUN wget -qO- https://buildroot.org/downloads/buildroot-${BR_VERSION}.tar.bz2 | tar xj && \
    mv buildroot-${BR_VERSION} ${BR_ROOT}

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

# Add Docker
ENV DOCKER_VERSION 1.9.1
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/docker https://github.com/ailispaw/docker/releases/download/v${DOCKER_VERSION}-stripped/docker-${DOCKER_VERSION} && \
    chmod +x usr/bin/docker && \
    wget -qO usr/share/bash-completion/completions/docker https://raw.githubusercontent.com/docker/docker/v${DOCKER_VERSION}/contrib/completion/bash/docker

# Add dumb-init
ENV DINIT_VERSION 1.0.1
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/dumb-init https://github.com/Yelp/dumb-init/releases/download/v${DINIT_VERSION}/dumb-init_${DINIT_VERSION}_amd64 && \
    chmod +x usr/bin/dumb-init

ENV VERSION 1.3.10
RUN mkdir -p etc && \
    echo "Welcome to DockerRoot version ${VERSION}, $(usr/bin/docker -v)" > etc/motd && \
    echo "NAME=\"DockerRoot\"" > etc/os-release && \
    echo "VERSION=${VERSION}" >> etc/os-release && \
    echo "ID=docker-root" >> etc/os-release && \
    echo "ID_LIKE=busybox" >> etc/os-release && \
    echo "VERSION_ID=${VERSION}" >> etc/os-release && \
    echo "PRETTY_NAME=\"DockerRoot v${VERSION}\"" >> etc/os-release && \
    echo "HOME_URL=\"https://github.com/ailispaw/docker-root\"" >> etc/os-release && \
    echo "BUG_REPORT_URL=\"https://github.com/ailispaw/docker-root/issues\"" >> etc/os-release

# Add Package Installer
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/pkg https://raw.githubusercontent.com/ailispaw/docker-root-pkg/master/pkg && \
    chmod +x usr/bin/pkg

# Copy config files
COPY configs ${SRC_DIR}/configs
RUN cp ${SRC_DIR}/configs/buildroot.config ${BR_ROOT}/.config && \
    cp ${SRC_DIR}/configs/busybox.config ${BR_ROOT}/package/busybox/busybox.config

COPY scripts ${SRC_DIR}/scripts

VOLUME ${BR_ROOT}/ccache ${BR_ROOT}/dl

WORKDIR ${BR_ROOT}
CMD ["../scripts/build.sh"]

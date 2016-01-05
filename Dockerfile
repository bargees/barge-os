FROM ubuntu-debootstrap:14.04.3

ENV TERM xterm

RUN apt-get -q update && \
    apt-get -q -y install ca-certificates \
      bc build-essential python unzip rsync wget \
      syslinux xorriso dosfstools && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup environment
ENV SRC_DIR=/build \
    OVERLAY=/overlay \
    BR_ROOT=/build/buildroot
RUN mkdir -p ${SRC_DIR} ${OVERLAY}

ENV BR_VERSION 2015.11.1
RUN wget -qO- http://buildroot.uclibc.org/downloads/buildroot-${BR_VERSION}.tar.bz2 | tar xj && \
    mv buildroot-${BR_VERSION} ${BR_ROOT}

# Setup overlay
COPY overlay ${OVERLAY}
WORKDIR ${OVERLAY}

# Add ca-certificates
RUN mkdir -p etc/ssl/certs && \
    cp /etc/ssl/certs/ca-certificates.crt etc/ssl/certs/

# Add Docker
ENV DOCKER_VERSION 1.9.1
RUN mkdir -p usr/bin && \
    wget -qO usr/bin/docker https://get.docker.io/builds/Linux/x86_64/docker-${DOCKER_VERSION} && \
    chmod +x usr/bin/docker

ENV VERSION 1.2.6
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

# Copy config files
COPY configs ${SRC_DIR}/configs
RUN cp ${SRC_DIR}/configs/buildroot.config ${BR_ROOT}/.config && \
    cp ${SRC_DIR}/configs/busybox.config ${BR_ROOT}/package/busybox/busybox.config

COPY scripts ${SRC_DIR}/scripts

VOLUME ${BR_ROOT}/ccache ${BR_ROOT}/dl

WORKDIR ${BR_ROOT}
CMD ["../scripts/build.sh"]

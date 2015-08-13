FROM ubuntu:14.04.2

ENV TERM xterm

RUN apt-get update && \
    apt-get install -y ca-certificates curl git && \
    apt-get install -y unzip bc wget python xz-utils build-essential libncurses5-dev && \
    apt-get install -y syslinux xorriso && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Setup Buildroot
ENV SRCDIR /build
RUN mkdir -p ${SRCDIR}

ENV BUILDROOT_VERSION 2015.05
ENV BUILDROOT ${SRCDIR}/buildroot
RUN cd ${SRCDIR} && \
    curl -OL http://buildroot.uclibc.org/downloads/buildroot-${BUILDROOT_VERSION}.tar.bz2 && \
    tar xf buildroot-${BUILDROOT_VERSION}.tar.bz2 && \
    mv buildroot-${BUILDROOT_VERSION} buildroot && \
    rm -f buildroot-${BUILDROOT_VERSION}.tar.bz2

# Setup overlay
ENV OVERLAY /overlay
RUN mkdir -p ${OVERLAY}
WORKDIR ${OVERLAY}

COPY overlay ${OVERLAY}

ENV VERSION 0.9.8
RUN mkdir -p etc && \
    echo ${VERSION} > etc/version && \
    echo "NAME=\"DockerRoot\"" > etc/os-release && \
    echo "VERSION=${VERSION}" >> etc/os-release && \
    echo "ID=docker-root" >> etc/os-release && \
    echo "ID_LIKE=busybox" >> etc/os-release && \
    echo "VERSION_ID=${VERSION}" >> etc/os-release && \
    echo "PRETTY_NAME=\"DockerRoot v${VERSION}\"" >> etc/os-release

# Add ca-certificates
RUN mkdir -p etc/ssl/certs && \
    cp /etc/ssl/certs/ca-certificates.crt etc/ssl/certs/

# Add Docker
ENV DOCKER_VERSION 1.8.1
RUN mkdir -p bin && \
    curl -L https://get.docker.io/builds/Linux/x86_64/docker-${DOCKER_VERSION} \
       -o bin/docker && \
    chmod +x bin/docker

# Copy config files
COPY configs ${SRCDIR}/configs
RUN cd ${SRCDIR} && \
    cp configs/buildroot.config ${BUILDROOT}/.config && \
    cp configs/busybox.config ${BUILDROOT}/package/busybox/busybox.config

COPY scripts ${SRCDIR}/scripts

VOLUME ${BUILDROOT}/ccache
VOLUME ${BUILDROOT}/dl

WORKDIR ${BUILDROOT}
CMD ["/build/scripts/build.sh"]

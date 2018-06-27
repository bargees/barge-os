FROM ailispaw/ubuntu-essential:14.04-nodoc

RUN apt-get -q update && \
    apt-get -q -y install --no-install-recommends cpio xz-utils syslinux xorriso && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ENV SRCDIR /usr/src
WORKDIR ${SRCDIR}

RUN mkdir -p root
ADD rootfs.tar.xz ${SRCDIR}/root/

COPY docker ${SRCDIR}/root/etc/init.d/docker
COPY docker.tgz /tmp
RUN cd /tmp && \
    tar -zxf docker.tgz -C ${SRCDIR}/root/usr/bin --strip-components=1

COPY docker.bash-completion ${SRCDIR}/root/usr/share/bash-completion/completions/docker

ENV ISO /iso

RUN mkdir -p ${ISO}/boot && \
    cd root && find | cpio -H newc -o | xz -9 -C crc32 -c > ${ISO}/boot/initrd

COPY bzImage ${ISO}/boot/

RUN mkdir -p ${ISO}/boot/isolinux && \
    cp /usr/lib/syslinux/isolinux.bin ${ISO}/boot/isolinux/ && \
    cp /usr/lib/syslinux/linux.c32 ${ISO}/boot/isolinux/ldlinux.c32

COPY isolinux.cfg ${ISO}/boot/isolinux/

# Copied from boot2docker, thanks.
RUN cd ${ISO} && \
    xorriso \
      -publisher "A.I. <ailis@paw.zone>" \
      -as mkisofs \
      -l -J -R -V "BARGE" \
      -no-emul-boot -boot-load-size 4 -boot-info-table \
      -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
      -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin \
      -no-pad -o /barge-x.iso $(pwd)

CMD ["cat", "/barge-x.iso"]

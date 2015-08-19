#!/bin/bash
set -e

IMAGES=$1

ISO=${IMAGES}/iso

mkdir -p ${ISO}/boot
cp ${IMAGES}/bzImage ${ISO}/boot/bzImage

ROOTFS=/tmp/root
mkdir -p ${ROOTFS}
tar xJf ${IMAGES}/rootfs.tar.xz -C ${ROOTFS}
cd ${ROOTFS}
find | cpio -H newc -o | xz -9 -C crc32 -c > ${ISO}/boot/initrd

mkdir -p ${ISO}/boot/isolinux
cp /usr/lib/syslinux/isolinux.bin ${ISO}/boot/isolinux/
cp /usr/lib/syslinux/linux.c32 ${ISO}/boot/isolinux/ldlinux.c32

cp /build/configs/isolinux.cfg ${ISO}/boot/isolinux/

cd ${ISO}
xorriso \
  -publisher "A.I. <ailis@paw.zone>" \
  -as mkisofs \
  -l -J -R -V "DOCKER_ROOT" \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
  -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin \
  -no-pad -o ${IMAGES}/docker-root.iso $(pwd)

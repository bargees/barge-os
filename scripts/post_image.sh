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

# Make an ISO
cd ${ISO}
xorriso \
  -publisher "A.I. <ailis@paw.zone>" \
  -as mkisofs \
  -l -J -R -V "DOCKER_ROOT" \
  -no-emul-boot -boot-load-size 4 -boot-info-table \
  -b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat \
  -isohybrid-mbr /usr/lib/syslinux/isohdpfx.bin \
  -no-pad -o ${IMAGES}/docker-root.iso $(pwd)

# Make a bootable disk image
IMAGE=${IMAGES}/docker-root.img
DISK=${IMAGES}/disk
ISO=${IMAGES}/ISO

mkdir -p ${ISO}
losetup /dev/loop0 ${IMAGES}/docker-root.iso
mount /dev/loop0 ${ISO}

SIZE=$(du -s ${ISO} | awk '{print $1}')

dd if=/dev/zero of=${IMAGE} bs=1024 count=$((${SIZE}+110+${SIZE}%2))
losetup /dev/loop1 ${IMAGE}
(echo c; echo n; echo p; echo 1; echo; echo; echo t; echo 4; echo a; echo 1; echo w;) | fdisk /dev/loop1 || true

losetup -o 32256 /dev/loop2 ${IMAGE}
mkfs -t vfat -F 16 /dev/loop2

mkdir -p ${DISK}
mount -t vfat /dev/loop2 ${DISK}

cp -a ${ISO}/* ${DISK}/
mv ${DISK}/boot/isolinux ${DISK}/boot/syslinux
mv ${DISK}/boot/syslinux/isolinux.cfg ${DISK}/boot/syslinux/syslinux.cfg
umount ${ISO}
umount ${DISK}

syslinux -i -d boot/syslinux /dev/loop2
losetup -d /dev/loop2
dd if=/usr/lib/syslinux/mbr.bin of=/dev/loop1 bs=440 count=1
losetup -d /dev/loop1
losetup -d /dev/loop0

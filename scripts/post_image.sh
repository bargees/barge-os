#!/bin/sh
set -e

BUILD_DIR=${BR_ROOT}/output/build
HOST_DIR=${BR_ROOT}/output/host
BINARIES_DIR=${BR_ROOT}/output/images
TARGET_DIR=${BR_ROOT}/output/target

ROOTFS=/tmp/root
mkdir -p ${ROOTFS}
tar xJf ${BINARIES_DIR}/rootfs.tar.xz -C ${ROOTFS}
cd ${ROOTFS}
find | cpio -H newc -o | gzip -9 -c > ${BINARIES_DIR}/initrd

GENIMAGE_CFG="${SRC_DIR}/configs/genimage-rpi3.cfg"
GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

# Mark the kernel as DT-enabled
mkdir -p "${BINARIES_DIR}/kernel-marked"
${HOST_DIR}/usr/bin/mkknlimg "${BINARIES_DIR}/zImage" \
  "${BINARIES_DIR}/kernel-marked/zImage"

rm -rf "${GENIMAGE_TMP}"

${HOST_DIR}/usr/bin/genimage                         \
  --rootpath "${TARGET_DIR}"     \
  --tmppath "${GENIMAGE_TMP}"    \
  --inputpath "${BINARIES_DIR}"  \
  --outputpath "${BINARIES_DIR}" \
  --config "${GENIMAGE_CFG}"

# Set a label
losetup -o 512 /dev/loop0 ${BINARIES_DIR}/barge-rpi.img
mlabel -i /dev/loop0 ::BARGE-RPI
losetup -d /dev/loop0

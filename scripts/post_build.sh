#!/bin/bash
set -e

ROOTFS=$1

# Remove unnecessary files
cd ${ROOTFS}
rm -rf linuxrc

# Initialize directories without linking to /tmp
rm -rf run
rm -rf var/cache
rm -rf var/lock
rm -rf var/log
rm -rf var/run
rm -rf var/spool
rm -rf var/lib/misc
mkdir -p run
mkdir -p var/cache
mkdir -p var/lock
mkdir -p var/log
mkdir -p var/run
mkdir -p var/spool
mkdir -p var/lib/misc

# Change shell for root
sed -i '/^root/s!/bin/sh!/bin/bash!' ${ROOTFS}/etc/passwd

# Copy /etc/skel manually, because buildroot won't copy it with BR2_ROOTFS_USERS_TABLES.
cp -R ${ROOTFS}/etc/skel/. ${ROOTFS}/root
mkdir -p ${ROOTFS}/home/bargee
cp -R ${ROOTFS}/etc/skel/. ${ROOTFS}/home/bargee
# chowd -R bargee:bargees ${ROOTFS}/home/bargee will be performed with BR2_ROOTFS_DEVICE_TABLE.

# Link shutdown scripts
cd ${ROOTFS}/sbin/
for i in halt reboot poweroff; do
  rm -f $i
  ln -s shutdown $i
done

# Link the docker script for SysV init
cd ${ROOTFS}/etc/init.d/
ln -s docker S60docker

# Disable SSH Use DNS
if ! grep -q "^UseDNS no" ${ROOTFS}/etc/ssh/sshd_config; then
  echo "UseDNS no" >> ${ROOTFS}/etc/ssh/sshd_config
fi

# Disable ARP probing at local network for speed up
if ! grep -q "^noarp" ${ROOTFS}/etc/dhcpcd.conf; then
  echo "noarp" >> ${ROOTFS}/etc/dhcpcd.conf
fi
if ! grep -q "^noipv6rs" ${ROOTFS}/etc/dhcpcd.conf; then
  echo "noipv6rs" >> ${ROOTFS}/etc/dhcpcd.conf
fi

# Set CA certificate to global wgetrc
if ! grep -q "^ca_certificate =" ${ROOTFS}/etc/wgetrc; then
  echo "ca_certificate = /etc/ssl/certs/ca-certificates.crt" >> ${ROOTFS}/etc/wgetrc
fi

STAGING_DIR=${ROOTFS}/../staging
BINARIES_DIR=${ROOTFS}/../images

# Install locale command
install -m 0755 -D ${STAGING_DIR}/usr/bin/locale ${ROOTFS}/usr/bin/locale

# Install C.UTF-8 locale
mkdir -p ${ROOTFS}/usr/lib/locale
I18NPATH=${STAGING_DIR}/usr/share/i18n:/usr/share/i18n \
  /usr/bin/localedef --force --quiet --no-archive --little-endian --prefix=${ROOTFS} \
    -i POSIX -f UTF-8 C.UTF-8
mv ${ROOTFS}/usr/lib/locale/C.utf8 ${ROOTFS}/usr/lib/locale/C.UTF-8

# Replace cmdline.txt
install -D -m 0644 ${SRC_DIR}/configs/cmdline.txt ${BINARIES_DIR}/rpi-firmware/cmdline.txt

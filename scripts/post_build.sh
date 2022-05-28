#!/bin/bash
set -e

ROOTFS=$1

# Needs the traditional SYSV skeleton
rm -rf ${ROOTFS}/var/run
rsync -a --ignore-times \
  --exclude .svn --exclude .git --exclude .hg --exclude .bzr \
  --exclude CVS \
  --chmod=u=rwX,go=rX --exclude .empty --exclude '*~' \
  package/skeleton-init-sysv/skeleton/ ${ROOTFS}/

# Remove useless kernel modules, based on unclejack/debian2docker
cd ${ROOTFS}/lib/modules
rm -rf ./*/kernel/build
rm -rf ./*/kernel/source
rm -rf ./*/kernel/sound/*
rm -rf ./*/kernel/drivers/gpu/*
rm -rf ./*/kernel/drivers/infiniband/*
rm -rf ./*/kernel/drivers/isdn/*
rm -rf ./*/kernel/drivers/media/*
rm -rf ./*/kernel/drivers/staging/lustre/*
rm -rf ./*/kernel/drivers/staging/comedi/*
rm -rf ./*/kernel/fs/ocfs2/*
rm -rf ./*/kernel/fs/reiserfs/*
rm -rf ./*/kernel/net/bluetooth/*
rm -rf ./*/kernel/net/mac80211/*
rm -rf ./*/kernel/net/wireless/*

# Strip kernel modules
GNU_TARGET_NAME=x86_64-buildroot-linux-gnu
OBJCOPY=${GNU_TARGET_NAME}-objcopy
find . -type f -name '*.ko' | xargs -n 1 ${OBJCOPY} --strip-unneeded

# Remove unnecessary files
cd ${ROOTFS}
rm -rf linuxrc
rm -rf lib/bash
rm -rf lib/pkgconfig
rm -f  etc/sudoers.dist

# Remove unnecessary libraries
rm -f usr/lib/libevent.so
rm -f usr/lib/libevent-*
rm -f usr/lib/libevent_extra.so
rm -f usr/lib/libevent_extra-*
rm -f usr/lib/libevent_openssl.so
rm -f usr/lib/libevent_openssl-*
rm -f usr/lib/libform.so*
rm -f usr/lib/libmenu.so*
rm -f usr/lib/libpanel.so*
rm -f usr/lib/libss.so*

# Remove unnecessary files from e2fsprogs
rm -f bin/chattr
rm -f bin/compile_et
rm -f bin/lsattr
rm -f bin/mk_cmds
rm -f sbin/badblocks
rm -f sbin/dumpe2fs
rm -f sbin/e2freefrag
rm -f sbin/e2label
rm -f sbin/e2mmpstatus
rm -f sbin/e2scrub
rm -f sbin/e2scrub_all
rm -f sbin/e2undo
rm -f sbin/e4crypt
rm -f sbin/filefrag
rm -f sbin/logsave
rm -f sbin/mklost+found
rm -f sbin/tune2fs
rm -rf usr/share/et
rm -rf usr/share/ss

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

STAGING_DIR=${ROOTFS}/../host/${GNU_TARGET_NAME}/sysroot

# Install locale command
install -m 0755 -D ${STAGING_DIR}/usr/bin/locale ${ROOTFS}/usr/bin/locale
STRIP=${GNU_TARGET_NAME}-strip
${STRIP} --remove-section=.comment --remove-section=.note ${ROOTFS}/usr/bin/locale

# Install C.UTF-8 locale
mkdir -p ${ROOTFS}/usr/lib/locale
I18NPATH=${STAGING_DIR}/usr/share/i18n:/usr/share/i18n \
  /usr/bin/localedef --force --quiet --no-archive --little-endian --prefix=${ROOTFS} \
    -i POSIX -f UTF-8 C.UTF-8
mv ${ROOTFS}/usr/lib/locale/C.utf8 ${ROOTFS}/usr/lib/locale/C.UTF-8

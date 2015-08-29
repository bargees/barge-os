#!/bin/bash
set -e

ROOTFS=$1

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

# Remove unnecessary directories and files
cd ${ROOTFS}
rm -rf linuxrc
rm -rf var/lib/misc

# Initialize directories and files
rm -rf run
rm -rf var/cache
rm -rf var/lock
rm -rf var/log
rm -rf var/run
rm -rf var/spool
mkdir -p run
mkdir -p var/cache
mkdir -p var/lock
mkdir -p var/log
mkdir -p var/run
mkdir -p var/spool

# Link shutdown scripts
cd ${ROOTFS}/sbin/
for i in halt reboot poweroff; do
  rm -f $i
  ln -s shutdown $i
done

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

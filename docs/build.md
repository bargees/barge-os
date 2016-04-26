# How to build Barge

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ make vagrant
$ make
```

It will create the following images at `./output/` directory.

- barge.iso: LiveCD image
- barge.img: Bootable disk image
- bzImage: Raw Linux kernel image
- rootfs.tar.xz: Raw Root filesystem including Linux kernel modules and drivers

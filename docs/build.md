# How to build DockerRoot

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

```
$ git clone https://github.com/ailispaw/docker-root
$ cd docker-root
$ make vagrant
$ make
```

It will create the following images at `./output/` directory.

- docker-root.iso: LiveCD image
- docker-root.img: Bootable disk image
- bzImage: Raw Linux kernel image
- rootfs.tar.xz: Raw Root filesystem including Linux kernel modules and drivers

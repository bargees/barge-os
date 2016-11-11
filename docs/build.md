# How to build Barge

## Requirements

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

Primarily this build method assumes that you have Docker client on Mac OS X.

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

Or you can use Docker client on the VM manually after `make vagrant`.

```
$ make vagrant
$ vagrant ssh
[bargee@barge ~]$ cd /vagrant/
[bargee@barge vagrant]$ mkdir -p output dl
[bargee@barge vagrant]$ docker build -t barge-builder .
[bargee@barge vagrant]$ docker run --privileged -v /mnt/data/ccache:/build/buildroot/ccache \
  -v /vagrant/dl:/build/buildroot/dl --name barge-built barge-builder
[bargee@barge vagrant]$ docker cp barge-built:/build/buildroot/output/images/barge.iso output/
[bargee@barge vagrant]$ exit
```

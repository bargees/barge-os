# How to build Barge

## Requirements

- [Docker](https://www.docker.com/)

Or we provide `Vagrantfile` to create a Docker environment in your local machine.

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

Primarily this build method assumes that you have Docker client on Mac OS X.

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ vagrant up # if you don't have Docker.
$ make
```

It will create the following images at `./output/` directory.

- barge.iso: LiveCD image
- barge.img: Bootable disk image
- bzImage: Raw Linux kernel image
- rootfs.tar.xz: Raw Root filesystem including Linux kernel modules and drivers

Or you can use a Docker client manually without `make`.

```
$ docker build -t barge-builder .
$ docker run --privileged --name barge-built barge-builder
$ mkdir -p output
$ docker cp barge-built:/build/buildroot/output/images/barge.iso output/
```

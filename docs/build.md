# How to build Barge

## Requirements

- [Docker](https://www.docker.com/)

Or we provide `Vagrantfile` to create a Docker environment in your local machine.

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

Primarily this build method assumes that you have Docker client.

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ make
```

Or if you don't have Docker but Vagrant,

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ vagrant up
$ vagrant ssh
[bargee@barge ~]$ cd /vagrant/
[bargee@barge vagrant]$ make
```

It will create the following images at `./output/` directory.

- barge.iso: LiveCD image
- barge.img: Bootable disk image
- bzImage: Raw Linux kernel image
- rootfs.tar.xz: Raw Root filesystem including Linux kernel modules and drivers

Or you can use Docker client manually without `make`.

```
$ docker build -t barge-builder .
$ docker run --privileged --name barge-built barge-builder
$ mkdir -p output
$ docker cp barge-built:/build/buildroot/output/images/barge.iso output/
```

# How to build Barge

## Requirements

- [Docker](https://www.docker.com/)

Or we provide `Vagrantfile` to create a Docker environment in your local machine.

- [VirtualBox](https://www.virtualbox.org/)
- [Vagrant](https://www.vagrantup.com/)

## Building

### 1. Build with your local Docker environment

This build method assumes that you have a Docker environment, `docker` client and `make` locally.

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ make
```

### 2. Build with Vagrant to create a Docker environment VM.

If you don't have a Docker daemon to access from your local machine, you can create it with Vagrant.

```
$ git clone https://github.com/bargees/barge
$ cd barge
$ vagrant up
```

And then if you have `make` and `docker` client in your local machine, just `make`.

```
$ make
```

Otherwise, you need to log into the VM.

```
$ vagrant ssh
[bargee@barge ~]$ sudo pkg install make
[bargee@barge ~]$ cd /vagrant/
[bargee@barge vagrant]$ make
```

2 methods above will create the following images at `./output/` directory.

- barge.iso: LiveCD image
- barge.img: Bootable disk image
- bzImage: Raw Linux kernel image
- rootfs.tar.xz: Raw Root filesystem including Linux kernel modules and drivers

### 3. Build with Docker manually

In the above cases, you can use Docker client manually without `make` as well.

```
$ docker build -t barge-builder .
$ docker run --privileged --name barge-built barge-builder
$ mkdir -p output
$ docker cp barge-built:/build/buildroot/output/images/barge.iso output/
```

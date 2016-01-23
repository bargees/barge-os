# DockerRoot

DockerRoot (formerly [RancherOS Lite](https://github.com/ailispaw/rancheros-lite)) is a lightweight Linux distribution made with [Buildroot](http://buildroot.uclibc.org/) ~~especially to run a [Docker](https://www.docker.com/) daemon as PID 1~~.

It's designed for a local development with Docker in a virtual machine.

It's inspired by the following projects.

- [Only Docker](https://github.com/ibuildthecloud/only-docker)
- [RancherOS](https://github.com/rancherio/os)
- [RancherOS Base System](https://github.com/rancher/os-base)
- [Boot2Docker](https://github.com/boot2docker/boot2docker)
- [DhyveOS](https://github.com/nlf/dhyve-os)

## Features

- Based on Buildroot 2015.11.1 with Linux kernel v4.3.4 and GLIBC.
- ~~Runs a Docker daemon as PID 1~~
- Strip down the Linux kernel modules and drivers
- Busybox + the following utilities from Buildroot
	- sudo, bash, wget, xz, sntp, logrotate
	- ssh, scp, sftp, rsync
	- acpid, sshd, dhcpcd, xtables-multi
	- e2fsck, mke2fs, resize2fs, tune2fs
- Default username: docker
- Default password: docker
- Install [dumb-init](https://github.com/Yelp/dumb-init) into /usr/bin

## Documentation

- [How to build DockerRoot](https://github.com/ailispaw/docker-root/blob/master/docs/build.md)
- [Customization of DockerRoot](https://github.com/ailispaw/docker-root/blob/master/docs/customization.md)

## License

Copyright (c) 2015-2016 A.I. &lt;ailis@paw.zone&gt;

Licensed under the GNU General Public License, version 2 (GPL-2.0)  
http://opensource.org/licenses/GPL-2.0

## Related Projects

- [DockerRoot Packer for VirtualBox and QEMU](https://github.com/ailispaw/docker-root-packer)
- [DockerRoot running on xhyve hypervisor](https://github.com/ailispaw/docker-root-xhyve)
- [Package Installer for DockerRoot](https://github.com/ailispaw/docker-root-pkg)
- [DockerRoot docker image](https://github.com/ailispaw/docker-root-docker-image)

# DockerRoot

DockerRoot (formerly [RancherOS Lite](https://github.com/ailispaw/rancheros-lite)) is a lightweight Linux distribution made with [Buildroot](http://buildroot.uclibc.org/) especially to run a [Docker](https://www.docker.com/) daemon as PID 1.

This is inspired by the following projects.

- [Only Docker](https://github.com/ibuildthecloud/only-docker)
- [RancherOS](https://github.com/rancherio/os)
- [RancherOS Base System](https://github.com/rancher/os-base)
- [Boot2Docker](https://github.com/boot2docker/boot2docker)
- [DhyveOS](https://github.com/nlf/dhyve-os)

## Features

- Based on Buildroot 2015.05 with Linux kernel v4.0.9 and GLIBC.
- Runs a Docker daemon as PID 1
- Default username: docker
- Default password: docker

## License

Copyright (c) 2015 A.I. &lt;ailis@paw.zone&gt;

Licensed under the GNU General Public License, version 2 (GPL-2.0)  
http://opensource.org/licenses/GPL-2.0

## Related Projects

- [DockerRoot Packer for VirtualBox and QEMU](https://github.com/ailispaw/docker-root-packer)
- [DockerRoot running on xhyve hypervisor](https://github.com/ailispaw/docker-root-xhyve)

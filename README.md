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

- Based on Buildroot 2016.02 with Linux kernel v4.4.6 and GLIBC.
- ~~Runs a Docker daemon as PID 1~~
- Strip down the Linux kernel modules and drivers
- Busybox + the following utilities from Buildroot
	- sudo, bash, wget, xz, sntp, logrotate
	- ssh, scp, sftp, rsync
	- acpid, sshd, dhcpcd, xtables-multi
	- e2fsck, mke2fs, resize2fs, tune2fs
- Default username: docker
- Default password: docker
- [dumb-init](https://github.com/Yelp/dumb-init) binary is built-in /usr/bin.

	e.g., `docker run -d -v /usr/bin/dumb-init:/dumb-init:ro --entrypoint=/dumb-init <image> <command>`

- [pkg](https://github.com/ailispaw/docker-root-pkg) command is built-in. You can install individual packages from Buildroot + &alpha;.

	```bash
	[docker@docker-root ~]$ pkg
	Usage: pkg {build|install} [-f] <package-name> [build options]
	       pkg show <package-name>
	       pkg list
	```

	e.g., `sudo pkg install vim`

- Enable to switch between Docker versions.

	```bash
	[docker@docker-root ~]$ sudo /etc/init.d/docker
	Usage /etc/init.d/docker {start|stop|restart|status} [<version>|latest|default]
	```

	e.g., `sudo /etc/init.d/docker restart latest`

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

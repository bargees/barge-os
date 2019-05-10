![barge-logo-800x300](https://cloud.githubusercontent.com/assets/10327896/18331486/2ffa9ec0-7514-11e6-9e2a-be3d69a092bc.png)

# Barge 2.0

Barge is a lightweight Linux distribution built with [Buildroot](http://buildroot.uclibc.org/) specifically to run [Docker](https://www.docker.com/) containers.

It's designed for a local development in a virtual machine.

It's inspired by the following projects.

- [Only Docker](https://github.com/ibuildthecloud/only-docker)
- [RancherOS](https://github.com/rancherio/os)
- [RancherOS Base System](https://github.com/rancher/os-base)
- [Boot2Docker](https://github.com/boot2docker/boot2docker)
- [DhyveOS](https://github.com/nlf/dhyve-os)

## Features
- Built with Buildroot 2019.02.2 with Linux kernel v4.14.118 and glibc.
- Strip down the Linux kernel modules and drivers
- Busybox + the following utilities from Buildroot
	- sudo, bash, wget, xz, sntp, logrotate
	- ssh, scp, sftp, rsync
	- acpid, sshd, dhcpcd, xtables-multi
	- e2fsck, mke2fs, resize2fs, tune2fs
- Default username: bargee
- Default password: bargee
- [dumb-init](https://github.com/Yelp/dumb-init) binary is built-in /usr/bin.

	e.g., `docker run -d -v /usr/bin/dumb-init:/dumb-init:ro --entrypoint=/dumb-init <image> <command>`

- [pkg](https://github.com/bargees/barge-pkg) command is built-in. You can install individual packages from Buildroot + &alpha;.

	```bash
	[bargee@barge ~]$ pkg
	Usage: pkg {build|install} [-f] <package-name> [build options]
	       pkg show <package-name>
	       pkg list
	```

	e.g., `sudo pkg install vim`

- Enable to switch between Docker versions.

	```bash
	[bargee@barge ~]$ sudo /etc/init.d/docker
	Usage /etc/init.d/docker {start|stop|restart|status} [<version>|latest|default]
	```

	e.g., `sudo /etc/init.d/docker restart latest`

## Documentation

- [How to build Barge](./docs/build.md)
- [Customization of Barge](./docs/customization.md)

## License

Copyright (c) 2015-2019 A.I. &lt;ailis@paw.zone&gt;

Licensed under the GNU General Public License, version 2 (GPL-2.0)  
http://opensource.org/licenses/GPL-2.0

## Related Projects

- [Barge Packer for VirtualBox and QEMU](https://github.com/bargees/barge-packer)
- [Barge running on xhyve hypervisor](https://github.com/bargees/barge-xhyve)
- [Package Installer for Barge](https://github.com/bargees/barge-pkg)
- [Barge docker image](https://github.com/bargees/barge-docker-image)

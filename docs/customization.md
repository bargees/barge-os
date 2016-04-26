# Customization of Barge

You can customize Barge by modifing files in `./configs/` and `./scripts/`.
And also you can customize the pre-built Barge image on the fly as below.

## Making a persistent disk for Barge

Because Barge runs from RAM, you need to create an additional disk to make your customization persistent.

The disk must be formated with **ext4** and have the label **BARGE-DATA** to be mounted automatically.

Ex.) `$ sudo mkfs.ext4 -b 4096 -i 4096 -F -L BARGE-DATA /dev/xxx`

Note) You can use any numbers for `-b 4096 -i 4096`, but pay attention to excessive inode usage because Barge uses overlay for Docker storage.

Cf.)  
- https://github.com/bargees/barge-packer/blob/master/box/template.json
- https://github.com/bargees/barge-xhyve/blob/master/contrib/makehdd/makehdd.sh

And also you can create a swap disk with the label **BARGE-SWAP** to be activated automatically.

Ex.) `$ sudo mkswap -L BARGE-SWAP /dev/xxx`

## Customizing the behavior of the Docker daemon

You can customize the behavior of the Docker daemon through `/etc/default/docker`.

### Defaults

- DOCKER_STORAGE="overlay"
- DOCKER_DIR="/var/lib/docker"
- DOCKER_HOST="-H unix://"
- DOCKER_EXTRA_ARGS="--userland-proxy=false"
- DOCKER_ULIMITS=1048576
- DOCKER_LOGFILE="/var/log/docker/docker.log"
- DOCKER_TIMEOUT=5

You can override these defaults by puting the above variables into profile.
Then Barge uses them to execute Docker daemon in `/etc/init.d/docker` as below.

```
ulimit -n ${DOCKER_ULIMITS}
ulimit -u ${DOCKER_ULIMITS}

/opt/bin/docker daemon -D -s ${DOCKER_STORAGE} -g "${DOCKER_DIR}" ${DOCKER_HOST} ${DOCKER_EXTRA_ARGS} >> "${DOCKER_LOGFILE}" 2>&1
```

Ex.) To expose the Docker post 2375,

```
$ cat /etc/default/docker
DOCKER_HOST="-H unix:// -H tcp://0.0.0.0:2375"
```

Cf.)  
- https://github.com/bargees/barge/blob/master/overlay/init
- https://github.com/bargees/barge-packer/blob/master/box/assets/profile
- https://github.com/bargees/barge-xhyve/blob/master/contrib/makehdd/makehdd.sh

## Customizing init scripts on booting up

You can customize init scripts in three ways as below.

- Putting any scripts in the `/etc/init.d/S*` in the SysV manner.
- Barge's init executes `/etc/init.d/init.sh` right after mounting the disk and before `/etc/init.d` scripts including networking.
- Barge's init executes `/etc/init.d/start.sh` asynchronously right after executing `/etc/init.d` scripts.

Cf.)  
- https://github.com/bargees/barge/blob/master/overlay/init
- https://github.com/bargees/barge-packer/blob/master/box/assets/init.sh
- https://github.com/bargees/barge-xhyve/blob/master/contrib/makehdd/makehdd.sh

And also you can edit any files in `/etc`, because `/etc` is mounted at the persistent disk with overlay if the disk exists.

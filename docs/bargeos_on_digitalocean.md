0. Download latest release barge.img file (13MB) from: https://github.com/bargees/barge-os/releases
0. Login and goto https://cloud.digitalocean.com/images/custom_images
0. Click "Upload Image" and select barge.img to upload
0. Create Droplets/Custom images/barge.img
0. ssh bargee@<vps ip> (password is also bargee)
0. sudo fdisk -l, found the "EndLBA" is <26635>
0. sudo fdisk /dev/vda, Command (m for help): n, Partition type: p, Partition number (1-4): 2, First sector: 26636 ... created new partition
0. sudo mkfs.ext4 -b 4096 -i 4096 -L BARGE-DATA /dev/vda2
0. sudo reboot
0. ssh bargee@<vps ip> (password is still bargee)
0. passwd (password only can be saved after we made BARGE-DATA partition)
0. sudo reboot
0. ssh bargee@<vps ip> (new password)
0. sudo pkg install nano
0. docker run -it ubuntu /bin/sh

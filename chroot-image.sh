#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "No image file!"
    exit 1
fi

IMAGE=$1
LOOP_DEV=$(sudo losetup --show --partscan --find ${IMAGE})
PARTITION="${LOOP_DEV}p2"
MOUNT=/mnt

sudo mount $PARTITION $MOUNT

# sudo ln -s $MOUNT/lib/systemd/system/ssh.service $MOUNT/etc/systemd/system/sshd.service
# sudo ln -s $MOUNT/lib/systemd/system/ssh.service $MOUNT/etc/systemd/system/multi-user.target.wants/ssh.service

sudo cp $(which qemu-arm-static) $MOUNT/usr/bin

sudo chroot $MOUNT qemu-arm-static /bin/bash -c "sudo systemctl enable ssh"
# sudo chroot $MOUNT /bin/bash -c "sudo apt update"
# sudo chroot $MOUNT /bin/bash -c "sudo apt upgrade"
sudo chroot $MOUNT qemu-arm-static /bin/bash -c "sudo apt install gdbserver"

sudo rm $MOUNT/usr/bin/qemu-arm-static

sudo umount $PARTITION
sudo losetup --detach $LOOP_DEV

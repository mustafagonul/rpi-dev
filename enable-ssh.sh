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

sudo ln -s $MOUNT/lib/systemd/system/ssh.service $MOUNT/etc/systemd/system/sshd.service
sudo ln -s $MOUNT/lib/systemd/system/ssh.service $MOUNT/etc/systemd/system/multi-user.target.wants/ssh.service

sudo umount $PARTITION
sudo losetup --detach $LOOP_DEV

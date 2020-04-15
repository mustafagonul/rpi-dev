#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "No image file!"
    exit 1
fi

function execute() {
    sudo chroot $MOUNT qemu-arm-static /bin/bash -c "$1"
}

IMAGE=$1
LOOP_DEV=$(sudo losetup --show --partscan --find ${IMAGE})
PARTITION="${LOOP_DEV}p2"
MOUNT=/mnt

sudo mount $PARTITION $MOUNT

sudo cp $(which qemu-arm-static) $MOUNT/usr/bin

execute "sudo apt-get -y install gdbserver"
execute "sudo apt-get -y install gpiod"
execute "sudo systemctl enable ssh"

sudo rm $MOUNT/usr/bin/qemu-arm-static

sudo umount $PARTITION
sudo losetup --detach $LOOP_DEV
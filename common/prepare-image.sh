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

execute "sudo sed -i 's/# en_US.UTF-8 UTF-8/en_US.UTF-8 UTF-8/g' /etc/locale.gen"
execute "sudo sed -i 's/en_GB.UTF-8 UTF-8/# en_GB.UTF-8 UTF-8/g' /etc/locale.gen"
execute "sudo locale-gen en_US.UTF-8"
execute "sudo update-locale en_US.UTF-8"

execute "sudo apt-get -y install gdbserver"
execute "sudo apt-get -y install gpiod"
execute "sudo systemctl enable ssh"

execute "sudo mv /etc/security/limits.conf /etc/security/limits.conf.old"
execute "echo '* soft core unlimited' > /etc/security/limits.conf"

sudo rm $MOUNT/usr/bin/qemu-arm-static

sudo umount $PARTITION
sudo losetup --detach $LOOP_DEV

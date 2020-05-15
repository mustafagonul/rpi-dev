#!/bin/bash

if [ "$#" -ne 2 ]; then
    echo "No image file!"
    echo "No sysroot directory!"
    exit 1
fi

IMAGE=$1
SYSROOT=$2
LOOP_DEV=$(sudo losetup --show --partscan --find ${IMAGE})
PARTITION=${LOOP_DEV}p2
MOUNT=/mnt

sudo mount ${PARTITION} ${MOUNT}

rm -Rf ${SYSROOT}
mkdir -p ${SYSROOT}
cp -r ${MOUNT}/* ${SYSROOT}

sudo umount ${PARTITION}
sudo losetup --detach ${LOOP_DEV}

#!/bin/bash

DIRECTORY=$(cd `dirname $0` && pwd)
IMAGE=${DIRECTORY}/images/2020-02-05-raspbian-buster-lite.img
DTB=${DIRECTORY}/versatile-pb.dtb
KERNEL=${DIRECTORY}/kernel-qemu-4.19.50-buster
NIC=enp0s3


qemu-system-arm \
  -M versatilepb \
  -cpu arm1176 \
  -m 256 \
  -drive file=${IMAGE},format=raw,index=0,media=disk \
  -net nic \
  -net user,hostfwd=tcp::5022-:22 \
  -dtb ${DTB} \
  -kernel ${KERNEL} \
  -append 'root=/dev/sda2 panic=1' \
  -no-reboot \
  -nographic

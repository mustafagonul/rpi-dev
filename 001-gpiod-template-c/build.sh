#!/bin/bash

. ../common/build.sh main.c -I../rootfs/usr/include/ -L../rootfs/usr/lib/ -lgpiod

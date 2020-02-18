#!/bin/bash

set -x

arm-linux-gnueabi-gcc -g -o hello_world main.c

sshpass -p "raspberry" scp -P 5022 hello_world pi@127.0.0.1:/home/pi
sshpass -p "raspberry" ssh -p 5022 pi@127.0.0.1 "./hello_world"

#!/bin/bash

. ../common/build.sh main.c -fsanitize=address -static-libasan #-fno-omit-frame-pointer

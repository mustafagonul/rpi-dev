#!/bin/bash

. ../common/build.sh main.c -fsanitize=leak -static-liblsan

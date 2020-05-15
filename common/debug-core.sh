#!/bin/bash

# Configuration
. ../config.sh

# Variables
# Do not edit if you dont know what you are doing!
NAME=$(basename $(pwd))
DIR="/home/$USER/$NAME"
CORE="$DIR/core"

# Removing old core file
rm ./core

# Copying core file
sshpass -p "${PASSWORD}" scp -P $PORT $SSH_PARAMS "$ENDPOINT":"$CORE" .

# Running gdb
gdb-multiarch ./build/$NAME -c ./core -n -x ../common/gdbinit

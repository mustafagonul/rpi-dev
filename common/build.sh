#!/bin/bash

# Configuration
. ../config.sh

# Variables
# Do not edit if you dont know what you are doing!
NAME=$(basename $(pwd))
DIR="/home/$USER/$NAME"
BUILD="build"
EXE="$BUILD/$NAME"


# Preparation for the build
[ ! -d "$BUILD" ] && mkdir "$BUILD"
[ -f "$EXE" ] && rm "$EXE"

# Build params
FILE="$1"
COMPILE_PARAMS="${@:2}"
LINK_PARAMS=""
COMPILER="arm-linux-gnueabi-gcc"

if [ -z "$FILE" ]
  then
    echo "No file supplied"
    exit 1
fi

if [ "${FILE#*.}" == "cpp" ]; then
  COMPILER="arm-linux-gnueabi-g++"
fi

# Building
echo ""
echo "======================================================================================================"
echo "Building $NAME ..."
echo "======================================================================================================"

$COMPILER $COMPILE_PARAMS -g -o $EXE $FILE $LINK_PARAMS


echo ""
echo "======================================================================================================"
echo "Preparing $NAME on the target ..."
echo "======================================================================================================"

# Preparation for copying
sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "[ -d $DIR ] && rm -Rf $DIR"
sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "mkdir -p $DIR"

# Copying
sshpass -p "${PASSWORD}" scp -P $PORT $SSH_PARAMS "$EXE"             "$ENDPOINT":"$DIR"
sshpass -p "${PASSWORD}" scp -P $PORT $SSH_PARAMS ../common/run.sh   "$ENDPOINT":"$DIR"/run.sh



# Running
echo ""
echo "======================================================================================================"
echo "Running $NAME ..."
echo "======================================================================================================"
echo ""

sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "cd $DIR && ./run.sh"

echo ""

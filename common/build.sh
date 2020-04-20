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
COMPILER="arm-linux-gnueabi-gcc"
COMPILE_PARAMS="${@:2}"

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

$COMPILER $FILE $COMPILE_PARAMS -g -o $EXE
if [ $? -eq 0 ]; then
  echo
  echo "Building success!"
  echo
else
  echo
  echo "Building failed!"
  echo

  exit
fi


echo ""
echo "======================================================================================================"
echo "Preparing $NAME on the target ..."
echo "======================================================================================================"

# Preparation for copying
sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "[ -d $DIR ] && rm -Rf $DIR"
sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "mkdir -p $DIR"

# Copying
sshpass -p "${PASSWORD}" scp -P $PORT $SSH_PARAMS "$EXE"      "$ENDPOINT":"$DIR"

if [ $? -eq 0 ]; then
  echo
  echo "Preparing success!"
  echo
else
  echo
  echo "Preparing failed!"
  echo

  exit
fi

# Running
echo ""
echo "======================================================================================================"
echo "Running $NAME ..."
echo "======================================================================================================"
echo ""

sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" "cd $DIR && ./$NAME"

echo ""

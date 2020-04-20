#!/bin/bash

. ./config.sh

sshpass -p "${PASSWORD}" ssh -p $PORT $SSH_PARAMS "$ENDPOINT" $@

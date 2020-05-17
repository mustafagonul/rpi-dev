#!/bin/bash

USER="pi"
PASSWORD="raspberry"
IP="127.0.0.1"
PORT="5022"
SSH_PARAMS="-q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null"

ENDPOINT="${USER}@${IP}"

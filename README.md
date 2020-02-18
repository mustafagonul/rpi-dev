# Raspberry Pi QEMU Developement

## Downloads

- Image: https://www.raspberrypi.org/downloads/raspbian/
- Tools: https://github.com/dhruvvyas90/qemu-rpi-kernel
- Ubuntu: https://ubuntu.com/download/desktop/thank-you?version=18.04.4&architecture=amd64

## Scripts

- [raspbian-buster-lite.sh](./raspbian-buster-lite.sh)
  Script is used to run raspbian on QEMU.
- [build.sh](./build.sh) 
  Script is used to build the code and run on the emulator.

## Ubuntu 18.04.4 LTS 

### Packages

- build-essentials
- sudo
- qemu-system
- gcc-arm-linux-gnueabi
- ssh
- sshpass
- git
- code: https://code.visualstudio.com/docs/setup/linux

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

## Raspberry Pi 

### Packages

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

### Info

- Default User/Password: pi/raspberry

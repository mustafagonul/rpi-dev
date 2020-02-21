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
- g++-arm-linux-gnueabi
- ssh
- sshpass
- wget
- git
- code: https://code.visualstudio.com/docs/setup/linux

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

## Raspberry Pi 

### SSH

To enable ssh on the Raspberry Pi, you 

```bash
sudo systemctl start ssh
sudo systemctl enable ssh
```

### Poweroff

```bash
sudo poweroff
```

### Packages

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

### Info

- Default User/Password: pi/raspberry

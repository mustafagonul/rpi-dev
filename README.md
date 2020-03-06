# Raspberry Pi QEMU Developement

## General Info

This project is developed for educational purposes. It serves ready to use environment for the development on the target (Raspberry Pi on Qemu) without any IDE. Currently it supports [Ubuntu 18.04.4 LTS](https://ubuntu.com/download/desktop/thank-you?version=18.04.4&architecture=amd64). The capabilities are:

- Installs the necessary packages.
- Downloads and prepares the Raspberry Pi image.
- Builds, copies and runs the examples on the target.

User can create examples with copying the templates. For C project, user should copy **000-template-c**. For C++ project, user should copy **000-template-cpp** project. The new project name should start with **three digits and a minus**. Examples are:

- 001-hello-world
- 123-my-awesome-app
- 456-nothing-can-stop-me

This work is based on the following project:

- https://github.com/dhruvvyas90/qemu-rpi-kernel

## Usage

The project is based on Makefile. User should run the features with make command. The available targets are:

- `make packages`
  
  Installs the necessary packages to the system.

- `make download`

  Downloads and prepares the tools and the images.

- `make clean-image`

  Removes only the prepared image.

- `make clean-download `

  Removes all downloads and the prepared image. It is same with the `make clean` command.

- `make clean`

  Removes all downloads and the prepared image. It is same with the `make clean-download` command.

- `make run-rpi`

  Runs the prepared Raspberry Pi image on Qemu. It does **not** have graphical interface.

- `make run-rpi-graphic`

  Runs the prepared Raspberry Pi image on Qemu. It does have graphical interface. Currently it is **not working**.

- `make poweroff-rpi`

  Turns off the Rasberry Pi running on Qemu.

- `make run-ssh`

  Creates a SSH connection to the Raspberry Pi running on Qemu.

- `make <example-name>`

  Builds, copies and runs the example on the Raspberry Pi running on Qemu.

- `make build`

  Builds, copies and runs the example on the Raspberry Pi running on Qemu.

- `make all`

  Downloads and prepares the tools and the image then builds, copies and runs the example on the Raspberry Pi running on Qemu.


## Downloads

The following items are downloaded within the project.

- Image: https://www.raspberrypi.org/downloads/raspbian/
- Tools: https://github.com/dhruvvyas90/qemu-rpi-kernel

## Ubuntu

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

## Raspberry Pi 

### Edits

- sudoers: https://askubuntu.com/questions/334318/sudoers-file-enable-nopasswd-for-user-all-commands

```bash
%sudo  ALL=(ALL) NOPASSWD: ALL
```

### Info

- Default User/Password: pi/raspberry

## TODOs

- Support for examples having **makefile**
- Support for **remote debugging**
- Support for **kernel modules**
- Fix for **graphical interface**
- Fix / Support for **VNC**
- Refactor scripts.

## References

- https://github.com/dhruvvyas90/qemu-rpi-kernel

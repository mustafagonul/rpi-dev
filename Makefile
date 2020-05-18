DOWNLOAD_DIR = downloads
ROOTFS_DIR = rootfs/usr
SYSROOT_DIR = sysroot


RPI_IMAGE_TYPE = lite
# RPI_IMAGE_TYPE = full
RPI_IMAGE_LINK = https://downloads.raspberrypi.org/raspbian_$(RPI_IMAGE_TYPE)/images/raspbian_$(RPI_IMAGE_TYPE)-2020-02-14/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).zip
RPI_IMAGE_ZIP = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).zip
RPI_IMAGE_IMG = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).img

QEMU_RPI_KERNEL_LINK = https://github.com/dhruvvyas90/qemu-rpi-kernel.git
QEMU_RPI_KERNEL_NAME = qemu-rpi-kernel
QEMU_RPI_KERNEL_REPO = $(DOWNLOAD_DIR)/$(QEMU_RPI_KERNEL_NAME)

GPIOD_NAME = libgpiod-1.2
GPIOD_TAR = $(GPIOD_NAME).tar.gz
GPIOD_TAR_LINK = https://git.kernel.org/pub/scm/libs/libgpiod/libgpiod.git/snapshot/$(GPIOD_TAR)
GPIOD_TAR_PATH = $(DOWNLOAD_DIR)/$(GPIOD_TAR)
GPIOD_DIR = $(DOWNLOAD_DIR)/$(GPIOD_NAME)


DTB=$(QEMU_RPI_KERNEL_REPO)/versatile-pb.dtb
KERNEL=$(QEMU_RPI_KERNEL_REPO)/kernel-qemu-4.19.50-buster

EXAMPLES = $(shell ls -d -- [0-9][0-9][0-9]-*)


default: prepare

packages:
	sudo apt install $(cat packages.txt)

$(DOWNLOAD_DIR): $(RPI_IMAGE_IMG) $(QEMU_RPI_KERNEL_REPO)

$(RPI_IMAGE_IMG): $(RPI_IMAGE_ZIP)
	unzip -n $(RPI_IMAGE_ZIP) -d $(DOWNLOAD_DIR)
	./common/prepare-image.sh $(RPI_IMAGE_IMG)

$(RPI_IMAGE_ZIP):
	mkdir -p $(DOWNLOAD_DIR)
	wget -nc -P $(DOWNLOAD_DIR) $(RPI_IMAGE_LINK)

$(QEMU_RPI_KERNEL_REPO):
	mkdir -p $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && git clone $(QEMU_RPI_KERNEL_LINK)	&& cd ..

$(DTB) $(KERNEL): $(QEMU_RPI_KERNEL_REPO)

image: $(RPI_IMAGE_IMG)

download: $(DOWNLOAD_DIR)

$(GPIOD_TAR_PATH):
	mkdir -p $(DOWNLOAD_DIR)
	wget -nc -P $(DOWNLOAD_DIR) $(GPIOD_TAR_LINK)

$(GPIOD_DIR): $(GPIOD_TAR_PATH)
	mkdir -p $(DOWNLOAD_DIR)
	tar -C $(DOWNLOAD_DIR) -xzf $(GPIOD_TAR_PATH)

$(ROOTFS_DIR): $(GPIOD_DIR)
	cd $(GPIOD_DIR) && \
	./autogen.sh --enable-tools=no --enable-bindings-cxx --host=arm-linux-gnueabi --prefix=${CURDIR}/$(ROOTFS_DIR) ac_cv_func_malloc_0_nonnull=yes && \
	make && make install && \
	cd -

rootfs: $(ROOTFS_DIR)

common/gdbinit:
	m4 -D DIR=.. -D SYSROOT=$(SYSROOT_DIR) common/gdbinit.in > common/gdbinit

$(HOME)/.gdbinit:
	m4 -D DIR=$(CURDIR) -D SYSROOT=$(SYSROOT_DIR) common/gdbinit.in > $(HOME)/.gdbinit

$(SYSROOT_DIR): $(RPI_IMAGE_IMG) common/gdbinit $(HOME)/.gdbinit
	./common/prepare-sysroot.sh $(RPI_IMAGE_IMG) $(SYSROOT_DIR)

# sysroot: $(SYSROOT_DIR)

# prepare: packages download rootfs
prepare: download rootfs sysroot

clean-image:
	rm -f $(DOWNLOAD_DIR)/*.img

clean-download:
	rm -Rf $(DOWNLOAD_DIR)

clean-rootfs:
	rm -Rf $(ROOTFS_DIR)

clean-sysroot:
	rm -Rf $(SYSROOT_DIR)
	rm -f common/gdbinit
	rm -f $(HOME)/.gdbinit

run-rpi: $(RPI_IMAGE_IMG) $(DTB) $(KERNEL)
	qemu-system-arm \
		-M versatilepb \
		-cpu arm1176 \
		-m 256 \
		-drive file=$(RPI_IMAGE_IMG),format=raw,index=0,media=disk \
		-net nic \
		-net user,hostfwd=tcp::5022-:22,hostfwd=tcp::2345-:2345 \
		-dtb $(DTB) \
		-kernel $(KERNEL) \
		-append 'root=/dev/sda2 panic=1' \
		-no-reboot \
		-nographic

run-rpi-graphic: $(RPI_IMAGE_IMG) $(DTB) $(KERNEL)
	qemu-system-arm \
		-M versatilepb \
		-cpu arm1176 \
		-m 256 \
		-drive file=$(RPI_IMAGE_IMG),format=raw,index=0,media=disk \
		-net nic \
		-net user,hostfwd=tcp::5022-:22,hostfwd=tcp::2345-:2345 \
		-dtb $(DTB) \
		-kernel $(KERNEL) \
		-append 'root=/dev/sda2 panic=1' \
		-no-reboot \
		-serial stdio

poweroff-rpi: # prepare
	./common/ssh.sh sudo poweroff

run-ssh:
	./common/ssh.sh


build: $(EXAMPLES)
	
clean-build:
	
*-*:
	make -C $@
	make -C $@ clean

all: download rootfs sysroot build

clean: clean-download clean-rootfs clean-sysroot

.PHONY: prepare packages image download rootfs sysroot gpiod clean-download clean-rootfs clean-sysroot clean-image run-rpi run-rpi-graphic poweroff-rpi run-ssh build clean-build all clean $(EXAMPLES)

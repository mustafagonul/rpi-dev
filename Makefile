DOWNLOAD_DIR = downloads


RPI_IMAGE_TYPE = lite
# RPI_IMAGE_TYPE = full
RPI_IMAGE_LINK = https://downloads.raspberrypi.org/raspbian_$(RPI_IMAGE_TYPE)/images/raspbian_$(RPI_IMAGE_TYPE)-2020-02-14/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).zip
RPI_IMAGE_ZIP = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).zip
RPI_IMAGE_IMG = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-$(RPI_IMAGE_TYPE).img

QEMU_RPI_KERNEL_LINK = https://github.com/dhruvvyas90/qemu-rpi-kernel.git
QEMU_RPI_KERNEL_NAME = qemu-rpi-kernel
QEMU_RPI_KERNEL_REPO = $(DOWNLOAD_DIR)/$(QEMU_RPI_KERNEL_NAME)

DTB=$(QEMU_RPI_KERNEL_REPO)/versatile-pb.dtb
KERNEL=$(QEMU_RPI_KERNEL_REPO)/kernel-qemu-4.19.50-buster

EXAMPLES = $(shell ls -d -- [0-9][0-9][0-9]-*)

# prepare: packages download

packages:
	sudo apt install $(cat packages.txt)

$(DOWNLOAD_DIR):
	mkdir -p $(DOWNLOAD_DIR)

$(RPI_IMAGE_IMG): $(RPI_IMAGE_ZIP)
	unzip -n $(RPI_IMAGE_ZIP) -d $(DOWNLOAD_DIR)
	./chroot-image.sh $(RPI_IMAGE_IMG)

$(RPI_IMAGE_ZIP): $(DOWNLOAD_DIR)
	wget -nc -P $(DOWNLOAD_DIR) $(RPI_IMAGE_LINK)

$(QEMU_RPI_KERNEL_REPO): $(DOWNLOAD_DIR)
	cd $(DOWNLOAD_DIR) && git clone $(QEMU_RPI_KERNEL_LINK)	&& cd ..

download: $(RPI_IMAGE_IMG) $(QEMU_RPI_KERNEL_REPO)

clean-image:
	rm -f $(DOWNLOAD_DIR)/*.img

clean-download:
	rm -Rf $(DOWNLOAD_DIR)

run-rpi: # prepare
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

run-rpi-graphic:
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
	./ssh.sh sudo poweroff

run-ssh:
	./ssh.sh


build: $(EXAMPLES)
	
clean-build:
	
*-*:
	@cd $@ && ([ -f main.cpp ] || [ -f main.c ]) && ./build.sh && cd ..

all: download build

clean: clean-download

.PHONY: prepare packages download clean-download clean-image run-rpi run-rpi-graphic poweroff-rpi run-ssh build clean-build all clean $(EXAMPLES)

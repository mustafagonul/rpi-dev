DOWNLOAD_DIR = downloads
RPI_IMAGE_LINK = https://downloads.raspberrypi.org/raspbian_lite/images/raspbian_lite-2020-02-14/2020-02-13-raspbian-buster-lite.zip
RPI_IMAGE_ZIP = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-lite.zip
RPI_IMAGE_IMG = $(DOWNLOAD_DIR)/2020-02-13-raspbian-buster-lite.img
QEMU_RPI_KERNEL_LINK = https://github.com/dhruvvyas90/qemu-rpi-kernel.git
QEMU_RPI_KERNEL_NAME = qemu-rpi-kernel
QEMU_RPI_KERNEL_REPO = $(DOWNLOAD_DIR)/$(QEMU_RPI_KERNEL_NAME)

DTB=$(QEMU_RPI_KERNEL_REPO)/versatile-pb.dtb
KERNEL=$(QEMU_RPI_KERNEL_REPO)/kernel-qemu-4.19.50-buster

EXAMPLES = $(shell ls -d -- [0-9][0-9][0-9]-*)

prepare: packages download

packages:
	sudo apt install $(cat packages.txt)

$(DOWNLOAD_DIR):
	mkdir -p $(DOWNLOAD_DIR)

$(RPI_IMAGE_IMG): $(RPI_IMAGE_ZIP)
	unzip -n $(RPI_IMAGE_ZIP) -d $(DOWNLOAD_DIR)

$(RPI_IMAGE_ZIP): $(DOWNLOAD_DIR)
	wget -nc -P $(DOWNLOAD_DIR) $(RPI_IMAGE_LINK)

$(QEMU_RPI_KERNEL_REPO): $(DOWNLOAD_DIR)
	echo $@
	cd $(DOWNLOAD_DIR) && git clone $(QEMU_RPI_KERNEL_LINK)	&& cd ..

download: $(RPI_IMAGE_IMG) $(QEMU_RPI_KERNEL_REPO)

clean-download:
	rm -Rf $(DOWNLOAD_DIR)

run-rpi: # prepare
	qemu-system-arm \
		-M versatilepb \
		-cpu arm1176 \
		-m 256 \
		-drive file=$(RPI_IMAGE_IMG),format=raw,index=0,media=disk \
		-net nic \
		-net user,hostfwd=tcp::5022-:22 \
		-dtb $(DTB) \
		-kernel $(KERNEL) \
		-append 'root=/dev/sda2 panic=1' \
		-no-reboot \
		-nographic

poweroff-rpi: # prepare
	sshpass -p "raspberry" ssh -p 5022 -q -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null pi@127.0.0.1 sudo poweroff

build: $(EXAMPLES)
	
clean-build:
	
*-*:
	@cd $@ && ([ -f main.cpp ] || [ -f main.c ]) && ./build.sh && cd ..

all: download build

clean: clean-download

.PHONY: prepare packages download clean-download run-rpi poweroff-rpi build clean-build all clean $(EXAMPLES)

GCC_CROSS_COMPILER = arm-linux-

all: uboot linux deploy

uboot:
	cd Smartwatch-u-boot && \
	export PATH=$$PATH:$(shell pwd)/tools/build/4.9.3/bin && \
	make nanopi_neo_air_defconfig ARCH=arm CROSS_COMPILE=${GCC_CROSS_COMPILER} && \
	make ARCH=arm CROSS_COMPILE=${GCC_CROSS_COMPILER}

linux:
	cd Smartwatch-Linux && \
	export PATH=$$PATH:$(shell pwd)/tools/build/4.9.3/bin && \
	touch .scmversion && \
	make sunxi_defconfig ARCH=arm CROSS_COMPILE=${GCC_CROSS_COMPILER} && \
	make zImage dtbs ARCH=arm CROSS_COMPILE=${GCC_CROSS_COMPILER}

setup:
	sudo mkdir -p tools/build
	sudo tar xf tools/arm-cortexa9-linux-gnueabihf-4.9.3-20160512.tar.xz -C tools/build

deploy:
	sudo dd if=Smartwatch-u-boot/u-boot-sunxi-with-spl.bin of=/dev/mmcblk0 bs=1024 seek=8

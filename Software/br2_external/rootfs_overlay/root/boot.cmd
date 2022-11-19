## Parameters  
kernel_addr=0x46000000
dtb_addr=0x48000000
ramdisk_addr=0x47000000
debug_port=ttyS0,115200
devicetree=sun8i-h3-nanopi-neo

## Boot
# Check input 67 (PC2) if it is held down
if gpio input 67; 
then

# Boot from the internal eMMC
echo "Booting from internal eMMC"

setenv load_addr 0x44000000
setenv fix_addr 0x44500000
fatload mmc 0 ${load_addr} uEnv.txt
env import -t ${load_addr} ${filesize}

fatload mmc 0 ${kernel_addr} ${kernel}
fatload mmc 0 ${ramdisk_addr} ${ramdisk}
setenv ramdisk_size ${filesize}

fatload mmc 0 ${dtb_addr} sun8i-${cpu}-${board}.dtb
fdt addr ${dtb_addr}

fdt resize 65536

fatload mmc 0 ${fix_addr} overlays/sun8i-h3-fixup.scr
source ${fix_addr}

fdt set mmc${boot_mmc} boot_device <1>

setenv overlayfs data=/dev/mmcblk0p3
setenv pmdown snd-soc-core.pmdown_time=3600000

setenv bootargs "console=${debug_port} earlyprintk root=/dev/mmcblk0p2 rootfstype=ext4 rw rootwait fsck.repair=${fsck.repair} panic=10 fbcon=${fbcon} ${hdmi_res} ${overlayfs} ${pmdown}"

bootz ${kernel_addr} ${ramdisk_addr}:${ramdisk_size} ${dtb_addr}

else

# Boot from SD card
echo "Booting from SD card"

# Load kernel image from rootfs
ext4load mmc 1:1 ${kernel_addr} boot/zImage

# Load device tree from rootfs
ext4load mmc 1:1 ${dtb_addr} boot/${devicetree}.dtb

# Set default bootargs. The boot device will be called mmcblk0 instead of mmcblk1, as the system has selected
# different numbers for the mmc devices when the bootargs are running
setenv bootargs "root=/dev/mmcblk0p1 rw rootwait console=${debug_port} rootfs=ext4 noinitrd selinux=0"

# Boot from kernel and device tree address in memory
bootz ${kernel_addr} - ${dtb_addr}

fi

#!/bin/bash

rm zImage
rm zImage.tar

# Set Default Path
TOP_DIR=$PWD
KERNEL_PATH=/home/simone/dawn-kernel

# TODO: Set toolchain and root filesystem path
TAR_NAME=zImage.tar

TOOLCHAIN="/home/simone/android/system/prebuilt/linux-x86/toolchain/arm-eabi-4.4.3/bin/arm-eabi-"
ROOTFS_PATH="/home/simone/dawn-kernel/initramfs"

export KBUILD_BUILD_VERSION="Dawn-Kernel-T1"

echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper

# cp -f $KERNEL_PATH/arch/arm/configs/c1_rev02_defconfig $KERNEL_PATH/.config
make dawn_defconfig

make -j`grep 'processor' /proc/cpuinfo | wc -l` ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE="$ROOTFS_PATH" || exit -1

find -name '*.ko' -exec cp -av {} $ROOTFS_PATH/lib/modules/ \;

make -j`grep 'processor' /proc/cpuinfo | wc -l` ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE="$ROOTFS_PATH" || exit -1

# Copy Kernel Image
cp -f $KERNEL_PATH/arch/arm/boot/zImage .

cd arch/arm/boot
tar cf $KERNEL_PATH/arch/arm/boot/$TAR_NAME ../../../zImage && ls -lh $TAR_NAME

cp $KERNEL_PATH/arch/arm/boot/zImage.tar $KERNEL_PATH/zImage.tar
rm $KERNEL_PATH/arch/arm/boot/zImage.tar

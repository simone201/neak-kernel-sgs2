#!/bin/sh

export ARCH=arm
export SUBARCH=arm
export CROSS_COMPILE="arm-eabi-"

export INITRAMFS="$HOME/android/neak/kernel/initramfs"

export KBUILD_BUILD_VERSION="N.E.A.K-1.3.2x"

# Clean
make mrproper

# Defconfig
make neak_defconfig

# Kernel
make -j4

# Copy modules
find -name '*.ko' -exec cp -av {} $INITRAMFS/lib/modules/ \;

# Strip modules
arm-eabi-strip initramfs/lib/modules/*

# Kernel with correct initramfs
make -j4 CONFIG_INITRAMFS_SOURCE="$INITRAMFS"

# Zip & tar file
tar cvf releasetools/tar/"$KBUILD_BUILD_VERSION".tar arch/arm/boot/zImage


#!/bin/bash

if [ -e zImage ]; then
	rm zImage
fi

rm compile.log
rm compile2.log

# Set Default Path
TOP_DIR=$PWD
KERNEL_PATH=/home/simone/neak-kernel

# Set toolchain and root filesystem path
TOOLCHAIN="/home/simone/arm-2011.03/bin/arm-none-eabi-"
ROOTFS_PATH="/home/simone/neak-kernel/initramfs"

export KBUILD_BUILD_VERSION="N.E.A.K-1.0.1b"

ZIP_NAME="N.E.A.K-1.0.1b.zip"

echo "Cleaning latest build"
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN -j`grep 'processor' /proc/cpuinfo | wc -l` mrproper

# Making our .config
make neak_defconfig

make -j`grep 'processor' /proc/cpuinfo | wc -l` ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE="$ROOTFS_PATH" >> compile.log 2>&1 || exit -1

find -name '*.ko' -exec cp -av {} $ROOTFS_PATH/lib/modules/ \;

make -j`grep 'processor' /proc/cpuinfo | wc -l` ARCH=arm CROSS_COMPILE=$TOOLCHAIN CONFIG_INITRAMFS_SOURCE="$ROOTFS_PATH" >> compile2.log 2>&1 || exit -1

# Copy Kernel Image
rm -f $KERNEL_PATH/releasetools/zip/$ZIP_NAME
cp -f $KERNEL_PATH/arch/arm/boot/zImage .
cp -f $KERNEL_PATH/arch/arm/boot/zImage $KERNEL_PATH/releasetools/zip

cd arch/arm/boot
tar cf $KERNEL_PATH/arch/arm/boot/$KBUILD_BUILD_VERSION.tar ../../../zImage && ls -lh $KBUILD_BUILD_VERSION.tar

cd ../../..
cd releasetools/zip
zip -r $ZIP_NAME *

cp $KERNEL_PATH/arch/arm/boot/$KBUILD_BUILD_VERSION.tar $KERNEL_PATH/releasetools/tar/$KBUILD_BUILD_VERSION.tar
rm $KERNEL_PATH/arch/arm/boot/$KBUILD_BUILD_VERSION.tar
rm $KERNEL_PATH/releasetools/zip/zImage

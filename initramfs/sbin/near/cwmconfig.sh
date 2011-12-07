#!/sbin/busybox sh

/sbin/busybox mount -o rw /dev/block/mmcblk0p11 /mnt/sdcard

if ! [ -d /sdcard/clockworkmod ]; then
	mkdir  /sdcard/clockworkmod
else
	echo "clockworkmod folder already exists"
fi;

if ! [ -f /sdcard/clockworkmod/.salted_hash ]; then
	touch  /sdcard/clockworkmod/.salted_hash
else
	echo ".salted_hash already exists"
fi;

if ! [ -f /sdcard/clockworkmod/.one_confirm ]; then
	touch  /sdcard/clockworkmod/.one_confirm
else
	echo ".one_confirm already exists"
fi;

/sbin/busybox umount /mnt/sdcard

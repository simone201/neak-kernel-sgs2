#!/sbin/busybox sh

/sbin/busybox mount -o rw /dev/block/mmcblk0p11 /mnt/sdcard

if ! [ -d /sdcard/near ]; then
	mkdir  /sdcard/near
else
	echo "near folder already exists"
fi;

if [ ! -f /sdcard/near/efsbackup.tar.gz ];
then
  /sbin/busybox tar zcvf /sdcard/near/efsbackup.tar.gz /efs
  /sbin/busybox cat /dev/block/mmcblk0p1 > /sdcard/near/efsdev-mmcblk0p1.img
  /sbin/busybox gzip /sdcard/near/efsdev-mmcblk0p1.img
else
	echo "efs backup already exists"
fi;

/sbin/busybox umount /mnt/sdcard

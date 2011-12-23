#!/sbin/busybox sh
#### install boot logo ####
# import/install custom boot logo if one exists
# thx to Hellcat

# sdcard isn't mounted at this point, mount it for now
/sbin/busybox mount -o rw /dev/block/mmcblk0p11 /mnt/sdcard

# import/install custom boot logo if one exists
if [ -f /mnt/sdcard/logo/logo.jpg ]; then
  /sbin/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox mount -o rw,remount /
  /sbin/busybox touch /.bootlock

  if [ ! -f /system/lib/param.img ]; then
    /sbin/busybox dd if=/dev/block/mmcblk0p4 of=/system/lib/param.img bs=4096
    /sbin/busybox sed 's/.jpg/.org/g' /system/lib/param.img > /system/lib/param.tmp
  fi;
  /sbin/busybox mkdir /mnt/sdcard/logo/tmp
  /sbin/busybox cp /mnt/.lfs/*.jpg /mnt/sdcard/logo/tmp/
  /sbin/busybox umount /mnt/.lfs
  /sbin/busybox dd if=/system/lib/param.tmp of=/dev/block/mmcblk0p4 bs=4096
  /sbin/busybox mount /dev/block/mmcblk0p4 /mnt/.lfs
  /sbin/busybox cp /mnt/sdcard/logo/logo.jpg /mnt/sdcard/logo/tmp/logo.jpg
  /sbin/busybox cp /mnt/sdcard/logo/logo.jpg /mnt/sdcard/logo/tmp/logo_att.jpg
  /sbin/busybox cp /mnt/sdcard/logo/logo.jpg /mnt/sdcard/logo/tmp/logo_kor.jpg
  /sbin/busybox cp /mnt/sdcard/logo/logo.jpg /mnt/sdcard/logo/tmp/logo_ntt.jpg
  /sbin/busybox cp /mnt/sdcard/logo/logo.jpg /mnt/sdcard/logo/tmp/logo_p6.jpg
  /sbin/busybox cp /mnt/sdcard/logo/tmp/* /mnt/.lfs/
  /sbin/busybox rm /mnt/sdcard/logo/logo.jpg
  /sbin/busybox rm -R /mnt/sdcard/logo/tmp

  /sbin/busybox rm /.bootlock
  /sbin/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox mount -o ro,remount /
  /sbin/busybox umount /mnt/.lfs
  /sbin/busybox umount /mnt/sdcard
  reboot
fi;

# remove sdcard mount again
/sbin/busybox umount /mnt/sdcard

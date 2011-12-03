#!/sbin/busybox sh
#### install boot logo ####
# thanks to Hellcat
# import/install custom boot logo if one exists
# sdcard isn't mounted at this point, mount it for now
/sbin/busybox mount -o rw /dev/block/mmcblk0p11 /mnt/sdcard

# import/install custom boot animation if one exists
if [ -f /mnt/sdcard/import/bootanimation.zip ]; then
  /sbin/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox rm /system/media/sanim.zip
  /sbin/busybox cp /mnt/sdcard/import/bootanimation.zip /system/media/sanim.zip
  /sbin/busybox rm /mnt/sdcard/import/bootanimation.zip
  /sbin/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
fi;

# import/install custom boot sound if one exists
if [ -f /mnt/sdcard/import/PowerOn.wav ]; then
  /sbin/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox rm /system/etc/PowerOn.wav
  /sbin/busybox cp /mnt/sdcard/import/PowerOn.wav /system/etc/PowerOn.wav
  /sbin/busybox rm /mnt/sdcard/import/PowerOn.wav
  /sbin/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
fi;

# import/install custom boot logo if one exists
if [ -f /mnt/sdcard/import/logo.jpg ]; then
  /sbin/busybox mount -o rw,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox mount -o rw,remount /
  /sbin/busybox touch /.bootlock

  if [ ! -f /system/lib/param.img ]; then
    /sbin/busybox dd if=/dev/block/mmcblk0p4 of=/system/lib/param.img bs=4096
    /sbin/busybox sed 's/.jpg/.org/g' /system/lib/param.img > /system/lib/param.tmp
    /sbin/busybox dd if=/system/lib/param.tmp of=/dev/block/mmcblk0p4 bs=4096
  fi;
  /sbin/busybox mkdir /mnt/sdcard/import/old
  /sbin/busybox cp /mnt/.lfs/*.jpg /mnt/sdcard/import/old/
  /sbin/busybox umount /mnt/.lfs
  /sbin/busybox mount /dev/block/mmcblk0p4 /mnt/.lfs
  /sbin/busybox cp /mnt/sdcard/import/logo.jpg /mnt/.lfs/logo.jpg
  /sbin/busybox cp /mnt/sdcard/import/logo.jpg /mnt/.lfs/logo_att.jpg
  /sbin/busybox cp /mnt/sdcard/import/logo.jpg /mnt/.lfs/logo_kor.jpg
  /sbin/busybox cp /mnt/sdcard/import/logo.jpg /mnt/.lfs/logo_ntt.jpg
  /sbin/busybox cp /mnt/sdcard/import/logo.jpg /mnt/.lfs/logo_p6.jpg
  /sbin/busybox rm /mnt/sdcard/import/logo.jpg

  /sbin/busybox rm /.bootlock
  /sbin/busybox mount -o ro,remount /dev/block/mmcblk0p9 /system
  /sbin/busybox mount -o ro,remount /
  /sbin/busybox umount /mnt/.lfs
  /sbin/busybox umount /mnt/sdcard
  reboot
fi;

# remove sdcard mount again
/sbin/busybox umount /mnt/sdcard

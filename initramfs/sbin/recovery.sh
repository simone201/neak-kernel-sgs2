#!/sbin/busybox sh

# Start adbd
setprop persist.service.adb.enable 1

# use default recovery from rom if we have an update to process, so things like CSC updates work
# Use CWM if we simply entered recovery mode by hand, to be able to use it's features
if /sbin/busybox [ -f "/cache/recovery/command" ];
then
  /sbin/busybox ln -s /system/etc /etc
  /sbin/busybox mount /dev/block/mmcblk0p9 /system
  /sbin/rec3e &
else
  /sbin/busybox ln -s /misc /etc
  /sbin/busybox umount /cache
  /sbin/recovery &
fi;

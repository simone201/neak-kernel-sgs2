#!/sbin/busybox sh

if [ -f /system/bin/bootanimation.bin ]; then
  /system/bin/bootanimation.bin
elif [ -f /data/local/bootanimation.zip ] || [ -f /system/media/bootanimation.zip ]; then
  /sbin/bootanimation
else
  /system/bin/samsungani
fi;

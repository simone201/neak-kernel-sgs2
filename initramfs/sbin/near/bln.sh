#!/sbin/busybox sh
# Installing BLN modded liblights
# by Simone201

mount -o remount,rw /system

lightsmd5sum=`/sbin/busybox md5sum /system/lib/hw/lights.GT-I9100.so | /sbin/busybox awk '{print $1}'`
blnlightsmd5sum=`/sbin/busybox md5sum /res/misc/lights.GT-I9100.so | /sbin/busybox awk '{print $1}'`

if [ "${lightsmd5sum}a" != "${blnlightsmd5sum}a" ]; then
    echo "Copying liblights"
    /sbin/busybox mv /system/lib/hw/lights.GT-I9100.so /system/lib/hw/lights.GT-I9100.so.BAK
    /sbin/busybox cp /res/misc/lights.GT-I9100.so /system/lib/hw/lights.GT-I9100.so
    /sbin/busybox chown 0.0 /system/lib/hw/lights.GT-I9100.so
    /sbin/busybox chmod 644 /system/lib/hw/lights.GT-I9100.so
fi;

mount -o remount,ro /system

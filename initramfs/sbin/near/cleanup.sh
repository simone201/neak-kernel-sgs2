#!/sbin/busybox sh
# Doing some cleanup
# by Simone201

mount -o remount,rw /system

if [ -f /system/etc/init.d/S98bolt_siyah ]; then
	rm /system/etc/init.d/S98bolt_siyah
fi;

if [ -f /system/etc/init.d/s78enable_touchscreen_1 ]; then
	rm /system/etc/init.d/s78enable_touchscreen_1
fi;

mount -o remount,ro /system

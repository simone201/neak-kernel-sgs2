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

if [ -f /system/etc/init.d/S02conservative ]; then
	rm /system/etc/init.d/S02conservative
	touch /data/neak/conservative
fi;

if [ -f /system/etc/init.d/S03lazy ]; then
	rm /system/etc/init.d/S03lazy
	touch /data/neak/lazy
fi;

if [ -f /system/etc/init.d/S04voodoo ]; then
	rm /system/etc/init.d/S04voodoo
fi;

if [ -f /system/etc/lionheart]; then
	rm /system/etc/lionheart
	touch /data/neak/lionheart
fi;

if [ -f /system/etc/schedmc]; then
	rm /system/etc/schedmc
	touch /data/neak/schedmc
fi;

mount -o remount,ro /system

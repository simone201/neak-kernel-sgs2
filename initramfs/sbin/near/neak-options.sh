#!/sbin/busybox sh
# All-in-one script for NEAK Options
# Only compatible with NEAK app/cwm
# by Simone201

mount -o remount,rw /data

# Check if our folder is there...
if [ ! -d /data/neak ]; then
	mkdir /data/neak
else
	echo "neak data folder already exists"
fi;

# Conservative Module
if [ -e /data/neak/conservative ]; then
	insmod /lib/modules/cpufreq_conservative.ko
fi;

# Lionheart Tweaks
if [ -e /data/neak/lionheart ]; then
	./sbin/near/lionheart.sh
fi;

# Lazy Governor
if [ -e /data/neak/lazy ]; then
	insmod /lib/modules/cpufreq_lazy.ko
fi;

# SCHED_MC Feature
if [ -e /data/neak/schedmc ]; then
	echo "1" > /sys/devices/system/cpu/sched_mc_power_savings
else
	echo "0" > /sys/devices/system/cpu/sched_mc_power_savings
fi;
	
# Install NEAK OTA Updater app
if [ ! -e /data/app/NEAK-OTA-Updater.apk ]; then
	echo "Installing NEAK OTA App"
	/sbin/busybox xzcat /res/misc/NEAK-OTA-Updater.apk.xz > /data/app/NEAK-OTA-Updater.apk
	/sbin/busybox chown 0.0 /data/app/NEAK-OTA-Updater.apk
	/sbin/busybox chmod 644 /data/app/NEAK-OTA-Updater.apk
else
	echo "NEAK OTA App already installed!"
fi;
	

#!/sbin/busybox sh
# All-in-one script for NEAK Options
# Only compatible with NEAK app/cwm
# by Simone201

mount -o remount,rw /data

# Check if our folder is there...
if [ ! -d /data/neak ]; then
	echo "creating /data/neak folder"
	mkdir /data/neak
else
	echo "neak data folder already exists"
fi;

# Conservative Module
if [ -e /data/neak/conservative ]; then
	echo "conservative module enabled"
	insmod /lib/modules/cpufreq_conservative.ko
fi;

# Lionheart Tweaks
if [ -e /data/neak/lionheart ]; then
	echo "lionheart tweaks enabled"
	./sbin/near/lionheart.sh
fi;

# Lazy Governor
if [ -e /data/neak/lazy ]; then
	echo "lazy module enabled"
	insmod /lib/modules/cpufreq_lazy.ko
fi;

# Lagfree Governor
if [ -e /data/neak/lagfree ]; then
	echo "lagfree module enabled"
	insmod /lib/modules/cpufreq_lagfree.ko
fi;

# SCHED_MC Feature
if [ -e /data/neak/schedmc ]; then
	echo "schedmc enabled"
	echo "1" > /sys/devices/system/cpu/sched_mc_power_savings
else
	echo "schedmc disabled"
	echo "0" > /sys/devices/system/cpu/sched_mc_power_savings
fi;

# AFTR Idle Mode
if [ -e /data/neak/aftridle ]; then
	echo "aftr idle mode enabled"
	echo "3" > /sys/module/cpuidle/parameters/enable_mask
fi;
	
# Install NEAK Configurator app
if [ ! -e /data/app/configurator ]; then
	echo "Installing NEAK Configurator"
	/sbin/busybox cp /res/misc/NEAK_Configurator.apk /data/app/NEAK_Configurator.apk
	/sbin/busybox chown 0.0 /data/app/NEAK_Configurator.apk
	/sbin/busybox chmod 644 /data/app/NEAK_Configurator.apk
	/sbin/busybox touch /data/neak/configurator
else
	echo "NEAK Configurator already installed! (or skipped)"
fi;
	

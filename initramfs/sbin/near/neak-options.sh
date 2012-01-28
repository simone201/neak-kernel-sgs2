#!/sbin/busybox sh
# All-in-one script for NEAK Options
# Only compatible with NEAK app/cwm
# by Simone201
# thx to GM & netarchy for lionheart tweaks

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
	

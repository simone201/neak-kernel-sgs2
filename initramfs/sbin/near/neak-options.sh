#!/sbin/busybox sh
# All-in-one script for NEAK Options
# Only compatible with NEAK app/cwm
# by Simone201

# Check if our folder is there...
if [ ! -d /data/neak]; then
	mkdir /data/neak
fi;

# Conservative Module
if [ -f /data/neak/conservative]; then
	insmod /lib/modules/cpufreq_conservative.ko
fi;

# Lionheart Tweaks
if [ -f /data/neak/lionheart]; then
	/sbin/busybox sh /sbin/near/lionheart.sh
else
	if[ ! -f /data/neak/conservative] && [ -f /data/neak/lionheart]; then
		rm /data/neak/lionheart
	fi;
fi;

# Lazy Governor
if [ -f /data/neak/lazy]; then
	insmod /lib/modules/cpufreq_lazy.ko
fi;

# SCHED_MC Feature
if [ -f /data/neak/schedmc ]; then
	echo "1" > /sys/devices/system/cpu/sched_mc_power_savings
	echo "sched_mc enabled"
else
	echo "0" > /sys/devices/system/cpu/sched_mc_power_savings
	echo "sched_mc disabled"
fi;
	

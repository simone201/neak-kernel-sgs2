#!/sbin/busybox sh
# Lionheart tweaks for conservative gov
# by Simone201

echo "conservative" > /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor
echo "5" > /sys/devices/system/cpu/cpufreq/conservative/freq_step
#just set it to the lowest possible
echo "100000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
echo "80000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
echo "60000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
echo "50000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
echo "20000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate
echo "10000" > /sys/devices/system/cpu/cpufreq/conservative/sampling_rate

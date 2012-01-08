#!/sbin/busybox sh
# Init.d support for N.E.A.K. Kernel
# thx to GM

if [ -d /system/etc/init.d ]; then
  /sbin/busybox run-parts /system/etc/init.d
fi;

if [ -d /data/init.d ]; then
  /sbin/busybox run-parts /data/init.d
fi;

# fix for samsung roms - setting scaling_max_freq - thx to gokhanmoral
freq=`cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq`
if [ "$freq" != "1200" ];then
  (
   sleep 25;
   echo $freq > /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq;
  ) &
fi

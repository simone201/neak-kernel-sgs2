#!/sbin/busybox sh
# thanks to hardcore and nexxx
# some parameters are taken from http://forum.xda-developers.com/showthread.php?t=1292743 (highly recommended to read)
# modded by simone201 for Dawn Kernel

MMC=`ls -d /sys/block/mmc*`;

/sbin/busybox cp /data/user.log /data/user.log.bak
/sbin/busybox rm /data/user.log
exec >>/data/user.log
exec 2>&1

echo $(date) START of post-init.sh

##### Early-init phase #####

# IPv6 privacy tweak
  echo "2" > /proc/sys/net/ipv6/conf/all/use_tempaddr

# Remount all partitions with noatime
  for k in $(/sbin/busybox mount | /sbin/busybox grep relatime | /sbin/busybox cut -d " " -f3)
  do
        sync
        /sbin/busybox mount -o remount,noatime $k
  done

# Remount ext4 partitions with optimizations
  for k in $(/sbin/busybox mount | /sbin/busybox grep ext4 | /sbin/busybox cut -d " " -f3)
  do
        sync
        /sbin/busybox mount -o remount,commit=15 $k
  done
  
# EXT4 Speed Tweaks
/sbin/busybox mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /cache /cache;
/sbin/busybox mount -o noatime,remount,rw,discard,barrier=0,commit=60,noauto_da_alloc,delalloc /data /data;
  
# Miscellaneous tweaks
  echo "1500" > /proc/sys/vm/dirty_writeback_centisecs
  echo "200" > /proc/sys/vm/dirty_expire_centisecs
  echo "0" > /proc/sys/vm/swappiness
  sysctl -w kernel.sched_min_granularity_ns=200000;
  sysctl -w kernel.sched_latency_ns=400000;
  sysctl -w kernel.sched_wakeup_granularity_ns=100000;

# SD cards (mmcblk) read ahead tweaks
  echo "1024" > /sys/devices/virtual/bdi/179:0/read_ahead_kb
  echo "1024" > /sys/devices/virtual/bdi/179:16/read_ahead_kb

# TCP tweaks
echo "0" > /proc/sys/net/ipv4/tcp_timestamps;
echo "1" > /proc/sys/net/ipv4/tcp_tw_reuse;
echo "1" > /proc/sys/net/ipv4/tcp_sack;
echo "1" > /proc/sys/net/ipv4/tcp_tw_recycle;
echo "1" > /proc/sys/net/ipv4/tcp_window_scaling;
echo "5" > /proc/sys/net/ipv4/tcp_keepalive_probes;
echo "30" > /proc/sys/net/ipv4/tcp_keepalive_intvl;
echo "30" > /proc/sys/net/ipv4/tcp_fin_timeout;
echo "404480" > /proc/sys/net/core/wmem_max;
echo "404480" > /proc/sys/net/core/rmem_max;
echo "256960" > /proc/sys/net/core/rmem_default;
echo "256960" > /proc/sys/net/core/wmem_default;
echo "4096,16384,404480" > /proc/sys/net/ipv4/tcp_wmem;
echo "4096,87380,404480" > /proc/sys/net/ipv4/tcp_rmem;

# UI tweaks
setprop debug.performance.tuning 1; 
setprop video.accelerate.hw 1;
setprop debug.sf.hw 1;
setprop windowsmgr.max_events_per_sec 80;

# enable SCHED_MC
# echo "1" > /sys/devices/system/cpu/sched_mc_power_savings
Enable AFTR
echo "3" > /sys/module/cpuidle/parameters/enable_mask

# Hotplug thresholds
echo "35" > /sys/module/pm_hotplug/parameters/loadl
echo "75" > /sys/module/pm_hotplug/parameters/loadh

# Optimize SQlite databases of apps
for i in \
`find /data -iname "*.db"`; 
do \
	sqlite3 $i 'VACUUM;'; 
done;

# Renice kswapd0 - kernel thread responsible for managing the memory
sleep 3
renice 18 `pidof kswapd0`

# New scheduler tweaks + readahead tweaks
for k in $MMC;
do
	if [ -e $i/queue/iostats ];
	then
		echo "0" > $k/queue/iostats;
	fi;
	if [ -e $i/queue/read_ahead_kb ];
	then
		echo "256" >  $i/queue/read_ahead_kb;
	fi;
done;

# Misc Kernel Tweaks
sysctl -w vm.vfs_cache_pressure=70
echo "8" > /proc/sys/vm/page-cluster;
echo "64000" > /proc/sys/kernel/msgmni;
echo "64000" > /proc/sys/kernel/msgmax;
echo "10" > /proc/sys/fs/lease-break-time;
echo "500,512000,64,2048" > /proc/sys/kernel/sem;

# Lionheart tweaks - if enabled
if [ -f /system/etc/lionheart ]; then
	/sbin/busybox sh /sbin/near/lionheart.sh
fi;

##### Install SU #####

if [ -f /system/xbin/su ] || [ -f /system/bin/su ];
then
	echo "su already exists"
else
	echo "Copying su binary"
	/sbin/busybox mount /system -o remount,rw
	/sbin/busybox rm /system/bin/su
	/sbin/busybox rm /system/xbin/su
	/sbin/busybox cp /res/misc/su /system/xbin/su
	/sbin/busybox chown 0.0 /system/xbin/su
	/sbin/busybox chmod 4755 /system/xbin/su
	/sbin/busybox mount /system -o remount,ro
fi

if [ -f /system/app/Superuser.apk ] || [ -f /data/app/Superuser.apk ];
then
	echo "Superuser.apk already exists"
else
	echo "Copying Superuser.apk"
	/sbin/busybox mount /system -o remount,rw
	/sbin/busybox rm /system/app/Superuser.apk
	/sbin/busybox rm /data/app/Superuser.apk
	/sbin/busybox cp /res/misc/Superuser.apk /system/app/Superuser.apk
	/sbin/busybox chown 0.0 /system/app/Superuser.apk
	/sbin/busybox chmod 644 /system/app/Superuser.apk
	/sbin/busybox mount /system -o remount,ro
fi

echo $(date) PRE-INIT DONE of post-init.sh

##### Post-init phase #####

sleep 10

# init.d support
echo $(date) USER EARLY INIT START from /system/etc/init.d
if cd /system/etc/init.d >/dev/null 2>&1 ; then
    for file in E* ; do
        if ! cat "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER EARLY INIT DONE from /system/etc/init.d

echo $(date) USER EARLY INIT START from /data/init.d
if cd /data/init.d >/dev/null 2>&1 ; then
    for file in E* ; do
        if ! cat "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER EARLY INIT DONE from /data/init.d

echo $(date) USER INIT START from /system/etc/init.d
if cd /system/etc/init.d >/dev/null 2>&1 ; then
    for file in S* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /system/etc/init.d

echo $(date) USER INIT START from /data/init.d
if cd /data/init.d >/dev/null 2>&1 ; then
    for file in S* ; do
        if ! ls "$file" >/dev/null 2>&1 ; then continue ; fi
        echo "START '$file'"
        /system/bin/sh "$file"
        echo "EXIT '$file' ($?)"
    done
fi
echo $(date) USER INIT DONE from /data/init.d

echo $(date) END of post-init.sh

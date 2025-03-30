SKIPUNZIP=0
LOCALE=$(getprop ro.product.locale)

local_print() {
	if [ $LOCALE = zh-CN ]; then
		ui_print "$1"
	else
		ui_print "$2"
	fi
}

check_magisk_version() {
	local_print "- 配置文件夹：/data/adb/modules/AppOpt/applist.conf" "- Configuration folder: /data/adb/modules/AppOpt/applist.conf"
}

check_required_files() {
	REQUIRED_FILE_LIST="/sys/devices/system/cpu/present"
	for REQUIRED_FILE in $REQUIRED_FILE_LIST; do
		if [ ! -e $REQUIRED_FILE ]; then
			abort
		fi
	done
}

extract_bin() {
	if [ "$ARCH" != "arm64" ]; then
	    local_print "- 未受支持的平台！" "- Unsupported platform!"
		abort
	fi
}

remove_sys_perf_config() {
	for SYSPERFCONFIG in $(ls /vendor/bin/msm_irqbalance); do
		[[ ! -d $MODPATH${SYSPERFCONFIG%/*} ]] && mkdir -p $MODPATH${SYSPERFCONFIG%/*}
		touch $MODPATH$SYSPERFCONFIG
	done
}

check_magisk_version
check_required_files
extract_bin
remove_sys_perf_config

if [ -f /data/adb/modules/AppOpt/applist.conf ]; then
	mv $MODPATH/applist.conf $MODPATH/applist.conf.bak
	cp -r /data/adb/modules/AppOpt/applist.conf ${MODPATH}
fi

set_perm_recursive "$MODPATH" 0 0 0755 0644
set_perm_recursive "$MODPATH/*.sh" 0 2000 0755 0755 u:object_r:magisk_file:s0
set_perm_recursive "$MODPATH/AppOpt" 0 2000 0755 0755

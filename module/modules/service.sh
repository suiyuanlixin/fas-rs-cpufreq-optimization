wait_sys_boot_completed() {
	local i=9
	until [ "$(getprop sys.boot_completed)" == "1" ] || [ $i -le 0 ]; do
		i=$((i-1))
		sleep 9
	done
}

wait_sys_boot_completed
cd ${0%/*}
nohup ./AppOpt >/dev/null 2>&1 &

for MAX_CPUS in /sys/devices/system/cpu/cpu*/core_ctl/max_cpus; do
	if [ -e "$MAX_CPUS" ] && [ "$(cat $MAX_CPUS)" != "$(cat ${MAX_CPUS%/*}/min_cpus)" ]; then
		chmod a+w "${MAX_CPUS%/*}/min_cpus"
		echo "$(cat $MAX_CPUS)" > "${MAX_CPUS%/*}/min_cpus"
		chmod a-w "${MAX_CPUS%/*}/min_cpus"
	fi
done

if [ -n "$(getprop persist.sys.oiface.enable)" ]; then
	setprop persist.sys.oiface.enable 0
	stop oiface
fi

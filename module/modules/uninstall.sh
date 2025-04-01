if [ -n "$(getprop persist.sys.oiface.enable)" ]; then
	prop_value=$(grep '^persist\.sys\.oiface\.enable=' /system_ext/etc/build.prop | cut -d= -f2)
    if [ -n "$prop_value" ]; then
		 setprop persist.sys.oiface.enable "$prop_value"
	else
		setprop persist.sys.oiface.enable 1
		start oiface
	fi
fi

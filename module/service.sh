#!/system/bin/sh
#
# Copyright 2023 shadow3aaa@gitbub.com
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
MODDIR=${0%/*}
soc_model=$(getprop ro.soc.model)
EXTENSIONS=/dev/fas_rs/extensions
MOD_EXTENSIONS=/data/adb/fas-rs/extensions
MODULE_PATH=/data/adb/modules
DIR=/sdcard/Android/fas-rs
CONF=$DIR/games.toml
MOD_DIR=/data/adb/fas-rs
MOD_CONF=$MOD_DIR/games.toml
VTOOLSDIR=/data/data/com.omarea.vtools/files
mod_value=$(cat "$MODDIR/tem_mod")
gt_installed_value=$(cat "$MODDIR/configs/gameturbo/gameturbo-installed")
conflict_found=false

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    until [ -d $MOD_EXTENSIONS ]; do
    	sleep 1
    done
else
    until [ -d $EXTENSIONS ]; do
    	sleep 1
    done
fi

for dir in $MODULE_PATH/*offset* $MODULE_PATH/fas_ext $MODULE_PATH/fas_gt_DLC; do
    if [ -d "$dir" ]; then
        conflict_found=true
        break
    fi
done

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    for file in $MOD_EXTENSIONS/*offset*.lua $MOD_EXTENSIONS/*extra*.lua $MOD_EXTENSIONS/fas_gt_DLC.lua $MOD_EXTENSIONS/fas_ext.lua; do
        if [ -f "$file" ]; then
            conflict_found=true
            break
        fi
    done
else
    for file in $EXTENSIONS/*offset*.lua $EXTENSIONS/*extra*.lua $EXTENSIONS/fas_gt_DLC.lua $EXTENSIONS/fas_ext.lua; do
        if [ -f "$file" ]; then
            conflict_found=true
            break
        fi
    done
fi

if [ "$conflict_found" = "true" ]; then
    sed -i "/^description=/s/=.*$/=/" "$MODDIR/module.prop"
    sed -i "/description=/s/$/[ Conflicting extension(s) detected. Please reinstall ! ]/" "$MODDIR/module.prop"
    rm -rf $MODDIR/configs
    rm -rf $MODDIR/service.sh
    mv $MODDIR/action $MODDIR/action.sh
    if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
        rm -f $MOD_EXTENSIONS/fas_rs_cpufreq_optimization.lua
    fi
    exit
fi

# if [ -f "/sdcard/Android/fas-rs/fas-rs-pro-installed" ]; then
#     sed -i "s/-- //g" $MODDIR/main.lua
# fi

id=$(awk -F= '/^id/ {print $2}' $MODDIR/module.prop)

if [ "$gt_installed_value" = "false" ]; then
    if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
        cp -f $MODDIR/main.lua $MOD_EXTENSIONS/${id}.lua
    else
        cp -f $MODDIR/main.lua $EXTENSIONS/${id}.lua
    fi
elif [ "$gt_installed_value" = "true" ]; then
    if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
        case "$soc_model" in
            "SM8750")
                cp -f $MODDIR/configs/gameturbo/sun.lua $MOD_EXTENSIONS/${id}.lua
                ;;
            "SM8650")
                cp -f $MODDIR/configs/gameturbo/pineapple.lua $MOD_EXTENSIONS/${id}.lua
                ;;
            "SM7675" | "SM8550" | "SM8635")
                cp -f $MODDIR/configs/gameturbo/kalama.lua $MOD_EXTENSIONS/${id}.lua
                ;;
            *)
                cp -f $MODDIR/configs/gameturbo/taro.lua $MOD_EXTENSIONS/${id}.lua
                ;;
        esac
    else
        case "$soc_model" in
            "SM8750")
                cp -f $MODDIR/configs/gameturbo/sun.lua $EXTENSIONS/${id}.lua
                ;;
            "SM8650")
                cp -f $MODDIR/configs/gameturbo/pineapple.lua $EXTENSIONS/${id}.lua
                ;;
            "SM7675" | "SM8550" | "SM8635")
                cp -f $MODDIR/configs/gameturbo/kalama.lua $EXTENSIONS/${id}.lua
                ;;
            *)
                cp -f $MODDIR/configs/gameturbo/taro.lua $EXTENSIONS/${id}.lua
                ;;
        esac
    fi
else
    if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
        cp -f $MODDIR/main.lua $MOD_EXTENSIONS/${id}.lua
    else
        cp -f $MODDIR/main.lua $EXTENSIONS/${id}.lua
    fi
    > "$MODDIR/configs/gameturbo/gameturbo-installed"
    echo "false" > "$MODDIR/configs/gameturbo/gameturbo-installed"
fi

if [ "$gt_installed_value" = "false" ]; then
    if [ "$mod_value" = "modify" ]; then
        if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
            sed -i '/\[powersave\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 80000/' "$MOD_CONF"
            sed -i '/\[balance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 85000/' "$MOD_CONF"
            sed -i '/\[performance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 90000/' "$MOD_CONF"
            sed -i '/\[fast\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 95000/' "$MOD_CONF"
            sed -i '/\[pedestal\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/' "$MOD_CONF"
        else
            sed -i '/\[powersave\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 75000/' "$CONF"
            sed -i '/\[balance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 85000/' "$CONF"
            sed -i '/\[performance\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = 95000/' "$CONF"
            sed -i '/\[fast\]/,/^\[/ s/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/' "$CONF"
        fi
    elif [ "$mod_value" = "disable" ]; then
        if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
            sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$MOD_CONF"
        else
            sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$CONF"
        fi
    fi
elif [ "$gt_installed_value" = "true" ]; then
    if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
        sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$MOD_CONF"
    else
        sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$CONF"
    fi
else
    > "$MODDIR/configs/gameturbo/gameturbo-installed"
    echo "false" > "$MODDIR/configs/gameturbo/gameturbo-installed"
fi

until [ -d $VTOOLSDIR ]; do
	sleep 2
done

propPath=$MODDIR/module.prop
version=$(cat $propPath | grep "^version=" | cut -d "=" -f2)
author=$(cat $propPath | grep "^author=" | cut -d "=" -f2)
btver=$(cat $propPath | grep "^betaVersion=" | cut -d "=" -f2)

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    sed -i 's/\\n☕️[^\\]*//g' "/data/data/com.omarea.vtools/files/manifest.json"
    sed -i "/\"version\":/ s/\\\\n🛠/\\\\n☕️ - (extension) fas-rs-cpufreq-opt : ${version} ($btver \/ @${author})\\\\n🛠/" "/data/data/com.omarea.vtools/files/manifest.json"
fi

sleep 90

if [ -f "$DIR/fas-rs-u-c-installed" ] || grep -qi "^name=fas-rs-usage-clamping" "$MODULE_PATH/fas-rs/module.prop"; then
    while grep -q "fas-rs[ -]cpufreq-opt" "/data/data/com.omarea.vtools/files/manifest.json"; do
        sed -i "/\"version\":/ s/\\\\n- (@[^)]*) fas-rs[ -]cpufreq-opt[ ]*: [^\\\\]*\\\\n/\\\\n/" "/data/data/com.omarea.vtools/files/manifest.json"
    done
    sed -i "/\"version\":/ s/\\(.*\\)\\\\n/\\1\\\\n- (@${author}) fas-rs-cpufreq-opt : ${version}\\\\n/" "/data/data/com.omarea.vtools/files/manifest.json"
fi

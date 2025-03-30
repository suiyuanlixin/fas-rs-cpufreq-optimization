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
LOCALE=$(getprop ro.product.locale)
soc_model=$(getprop ro.soc.model)
version_code=$(grep '^versionCode=' /data/adb/modules/fas_rs/module.prop | cut -d '=' -f 2)
MODULE_PATH=/data/adb/modules
DIR=/sdcard/Android/fas-rs
CONF=$DIR/games.toml
MOD_DIR=/data/adb/fas-rs
MOD_CONF=$MOD_DIR/games.toml
# qid_blacklist=(
#     3287712599
#     535426846
#     2042863287
# )

key_check() {
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "DOWN" ]]; then
            keycheck="$key_event"
            break
        fi
    done
    while true; do
        key_check=$(/system/bin/getevent -qlc 1)
        key_event=$(echo "$key_check" | awk '{ print $3 }' | grep 'KEY_')
        key_status=$(echo "$key_check" | awk '{ print $4 }')
        if [[ "$key_event" == *"KEY_"* && "$key_status" == "UP" ]]; then
            break
        fi
    done
}

if [ -z $LOCALE ]; then
    ui_print "- 请选择你的语言：
- 音量↑：中文
- 音量↓：英文
- Please select your language:
- Volume key↑: Chinese
- Volume key↓: English"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            LOCALE=zh-CN
            echo "zh-CN" > "$MODPATH/LOCALE"
            ;;
        "KEY_VOLUMEDOWN")
            LOCALE=en-US
            echo "en-US" > "$MODPATH/LOCALE"
            ;;
    esac
fi

local_print() {
	if [ $LOCALE = zh-CN ]; then
		ui_print "$1"
	else
		ui_print "$2"
	fi
}

[ $LOCALE != zh-CN ] && ui_print "- Warning: This script is gpt-translated and may contain inaccuracies or errors."

if [ "$(getprop fas-rs-installed)" = "" ] && [ ! -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
	local_print "- 请先安装fas-rs或fas-rs-mod再安装此插件" "- Please install fas-rs or fas-rs-mod first."
	abort
fi

if [ "$(getprop fas-rs-installed)" = "true" ] && [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    rm -rf /data/adb/fas-rs
	rm -f /data/fas_rs_mod*
	local_print "- 已自动清理fas-rs-mod残留文件" "- The residual files of fas-rs-mod have been automatically cleaned up."
fi

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    if (( version_code < 4300 )); then
        local_print "- 请安装版本号不小于4.3.0的fas-rs-mod" "- Please install fas-rs-mod with a version number not less than 4.3.0."
        abort
    fi
else
    if (( version_code < 430 )); then
        local_print "- 请安装版本号不小于4.3.0的fas-rs" "- Please install fas-rs with a version number not less than 4.3.0."
        abort
    fi
fi

# for qid in "${qid_blacklist[@]}"; do
#     if [ -f "/data/user/0/com.tencent.mobileqq/databases/${qid}.db" ]; then
#         local_print "- 不建议此用户刷入本模块" "- Not recommended for this user to install this module."
#         break
#     fi
# done

for folder in $(find "$MODULE_PATH" -type d -name "*offset*"); do
    name=$(grep '^name=' "$folder/module.prop" | cut -d '=' -f 2)
    local_print "- 是否清理冲突插件$name？
- 音量↑：是
- 音量↓：否" "- Whether to clean up the conflicting extension: $name?
- Volume key↑: Yes
- Volume key↓: No"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            if [ -f "$folder/uninstall.sh" ]; then
                sh $folder/uninstall.sh
            fi
            rm -rf "$folder"
            ;;
        "KEY_VOLUMEDOWN")
            local_print "- 请手动卸载冲突插件后重新安装" "- Please manually uninstall the conflicting extensions and then reinstall."
            abort
            ;;
    esac
done

for folder in $(find "$MODULE_PATH" -type d -name "*extra*"); do
    name=$(grep '^name=' "$folder/module.prop" | cut -d '=' -f 2)
    local_print "- 是否清理可能冲突插件$name？
- 音量↑：是
- 音量↓：否" "- Whether to clean up the potentially conflicting extension: $name?
- Volume key↑: Yes
- Volume key↓: No"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            if [ -f "$folder/uninstall.sh" ]; then
                sh $folder/uninstall.sh
            fi
            rm -rf "$folder"
            ;;
        "KEY_VOLUMEDOWN")
            local_print "- 可能检测错误，若无冲突则无需理会" "- There may be a detection error. If there is no conflict, you can ignore it."
            ;;
    esac
done

for file in $MODULE_PATH/fas_rs/extension/*extra*.lua; do
    if [ -f "$file" ]; then
        conflict_uc_found=true
        break
    fi
done

if [ "$conflict_uc_found" = "true" ]; then
    local_print "- 是否清理fas-rs-usage-clamping中冲突插件？
- 音量↑：是
- 音量↓：否" "- Whether to clean up the conflicting extension: fas-rs-usage-clamping?
- Volume key↑: Yes
- Volume key↓: No"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            for file in $MODULE_PATH/fas_rs/extension/*extra*.lua; do
                if [ -f "$file" ]; then
                    rm -f $file
                fi
            done
            ;;
        "KEY_VOLUMEDOWN")
            local_print "- 请手动卸载冲突插件后重新安装" "- Please manually uninstall the conflicting extensions and then reinstall."
            abort
            ;;
    esac
fi

if [ -d $MODULE_PATH/fas_gt_DLC ]; then
    local_print "- 是否清理冲突插件fas-gt-dlc？
- 音量↑：是
- 音量↓：否" "- Whether to clean up the conflicting extension: fas-gt-dlc?
- Volume key↑: Yes
- Volume key↓: No"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            if [ -f "$MODULE_PATH/fas_gt_DLC/uninstall.sh" ]; then
                sh $MODULE_PATH/fas_gt_DLC/uninstall.sh
            fi
            rm -rf $MODULE_PATH/fas_gt_DLC
            ;;
        "KEY_VOLUMEDOWN")
            local_print "- 请手动卸载冲突插件后重新安装" "- Please manually uninstall the conflicting extensions and then reinstall."
            abort
            ;;
    esac
fi

if [ -d $MODULE_PATH/fas_ext ]; then
    local_print "- 是否清理冲突插件fas_ext？
- 音量↑：是
- 音量↓：否" "- Whether to clean up the conflicting extension: fas_ext?
- Volume key↑: Yes
- Volume key↓: No"
    key_check
    case "$keycheck" in
        "KEY_VOLUMEUP")
            if [ -f "$MODULE_PATH/fas_ext/uninstall.sh" ]; then
                sh $MODULE_PATH/fas_ext/uninstall.sh
            fi
            rm -rf $MODULE_PATH/fas_ext
            ;;
        "KEY_VOLUMEDOWN")
            local_print "- 请手动卸载冲突插件后重新安装" "- Please manually uninstall the conflicting extensions and then reinstall."
            abort
            ;;
    esac
fi

local_print "- 是否关闭fas-rs对小核集群的频率控制？
- 音量↑：是
- 音量↓：否" "- Whether to disable FAS frequency control for the small core cluster?
- Volume key↑: Yes
- Volume key↓: No"
key_check
case "$keycheck" in
    "KEY_VOLUMEDOWN")
        sed -i 's/set_default_ignore(true, pkg)/set_default_ignore(false, pkg)/g' $MODPATH/configs/*.lua
        sed -i 's/set_default_ignore(true, pkg)/set_default_ignore(false, pkg)/g' $MODPATH/configs/gameturbo/*.lua
        ;;
esac

# if [ "$soc_model" = "SM8750" ]; then
#     local_print "- 是否关闭CPU6以减少不必要的功耗？
# - 音量↑：是
# - 音量↓：否" "- Whether to disable CPU6 to reduce unnecessary power consumption?
# - Volume key↑: Yes
# - Volume key↓: No"
#     key_check
#     case "$keycheck" in
#         "KEY_VOLUMEUP")
#             enable_games_opt=true
#             ;;
#         "KEY_VOLUMEDOWN")
#             sed -i 's/set_default_disable_policy(true, pkg)/set_default_disable_policy(false, pkg)/g' $MODPATH/configs/*.lua
#             enable_games_opt=true
#             ;;
#     esac
# fi

# if [ "$enable_games_opt" == "true" ]; then
#     if [ -d "$MODULE_PATH/asoul_affinity_opt" ] || [ -d "/data/adb/naki" ]; then
#         local_print "- 是否卸载Asoulopt并安装Games-opt？
# - 音量↑：是
# - 音量↓：否" "- Whether to uninstall Asoulopt and install Games-opt?
# - Volume key↑: Yes
# - Volume key↓: No"
#         key_check
#         case "$keycheck" in
#             "KEY_VOLUMEUP")
#                 if [ -f "$MODULE_PATH/asoul_affinity_opt/uninstall.sh" ]; then
#                     sh $MODULE_PATH/asoul_affinity_opt/uninstall.sh
#                 fi
#                 rm -rf $MODULE_PATH/asoul_affinity_opt
#                 rm -rf /data/adb/naki
#                 if [ -n "$(which magisk)" ]; then
#                     magisk --install-module $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/ksud" ]; then
#                     /data/adb/ksud module install $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/apd" ]; then
#                     /data/adb/apd module install $MODPATH/modules/Games-opt.zip
#                 fi
#                 ;;
#         esac
#     elif [ -d "$MODULE_PATH/thread_opt" ]; then
#         local_print "- 是否卸载Thread-opt并安装Games-opt？
# - 音量↑：是
# - 音量↓：否" "- Whether to uninstall Thread-opt and install Games-opt?
# - Volume key↑: Yes
# - Volume key↓: No"
#         key_check
#         case "$keycheck" in
#             "KEY_VOLUMEUP")
#                 if [ -f "$MODULE_PATH/thread_opt/uninstall.sh" ]; then
#                     sh $MODULE_PATH/thread_opt/uninstall.sh
#                 fi
#                 rm -rf $MODULE_PATH/thread_opt
#                 if [ -n "$(which magisk)" ]; then
#                     magisk --install-module $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/ksud" ]; then
#                     /data/adb/ksud module install $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/apd" ]; then
#                     /data/adb/apd module install $MODPATH/modules/Games-opt.zip
#                 fi
#                 ;;
#         esac
#     elif [ -d "$MODULE_PATH/AppOpt" ]; then
#         if grep -qi "^name=Games-opt" "$MODULE_PATH/AppOpt/module.prop"; then
#             local_print "- 是否更新Games-opt线程优化？
# - 音量↑：是
# - 音量↓：否" "- Whether to update the Games-opt thread optimization?
# - Volume key↑: Yes
# - Volume key↓: No"
#             key_check
#             case "$keycheck" in
#                 "KEY_VOLUMEUP")
#                     local_print "- 请选择Games-opt更新方式：
# - 音量↑：覆盖安装模块
# - 音量↓：写入更新规则" "- Please select the update method for Games-opt:
# - Volume key↑: Reinstall the module
# - Volume key↓: Write update rules"
#                     key_check
#                     case "$keycheck" in
#                         "KEY_VOLUMEUP")
#                             rm -rf $MODULE_PATH/AppOpt
#                             if [ -n "$(which magisk)" ]; then
#                                 magisk --install-module $MODPATH/modules/Games-opt.zip
#                             elif [ -f "/data/adb/ksud" ]; then
#                                 /data/adb/ksud module install $MODPATH/modules/Games-opt.zip
#                             elif [ -f "/data/adb/apd" ]; then
#                                 /data/adb/apd module install $MODPATH/modules/Games-opt.zip
#                             fi
#                             ;;
#                         "KEY_VOLUMEDOWN")
#                             if [ -f "$MODULE_PATH/AppOpt/applist.conf" ]; then
#                                 sed -i "/#王者荣耀/d" "$MODULE_PATH/AppOpt/applist.conf"
#                                 sed -i "/com.tencent.tmgp.sgame/d" "$MODULE_PATH/AppOpt/applist.conf"
#                                 echo -e "\n#王者荣耀\ncom.tencent.tmgp.sgame=0-2,4-5,7\ncom.tencent.tmgp.sgame{Thread*}=0-2\ncom.tencent.tmgp.sgame{UnityMain}=3-6\ncom.tencent.tmgp.sgame{Job.worker*}=4-5\ncom.tencent.tmgp.sgame{UnityGfxDeviceW}=7" >> "$MODULE_PATH/AppOpt/applist.conf"
#                             else  
#                                 touch "$MODULE_PATH/AppOpt/applist.conf"
#                                 echo -e "\n#王者荣耀\ncom.tencent.tmgp.sgame=0-2,4-5,7\ncom.tencent.tmgp.sgame{Thread*}=0-2\ncom.tencent.tmgp.sgame{UnityMain}=3-6\ncom.tencent.tmgp.sgame{Job.worker*}=4-5\ncom.tencent.tmgp.sgame{UnityGfxDeviceW}=7" >> "$MODULE_PATH/AppOpt/applist.conf"
#                             fi
#                             ;;
#                     esac
#                     ;;
#             esac
#         else
#             local_print "- 是否在AppOpt中加入Games-opt规则？
# - 音量↑：是
# - 音量↓：否" "- Whether to add the Games-opt rule to AppOpt?
# - Volume key↑: Yes
# - Volume key↓: No"
#             key_check
#             case "$keycheck" in
#                 "KEY_VOLUMEUP")
#                     if [ -f "$MODULE_PATH/AppOpt/applist.conf" ]; then
#                         sed -i "/#王者荣耀/d" "$MODULE_PATH/AppOpt/applist.conf"
#                         sed -i "/com.tencent.tmgp.sgame/d" "$MODULE_PATH/AppOpt/applist.conf"
#                         echo -e "\n#王者荣耀\ncom.tencent.tmgp.sgame=0-2,4-5,7\ncom.tencent.tmgp.sgame{Thread*}=0-2\ncom.tencent.tmgp.sgame{UnityMain}=3-5\ncom.tencent.tmgp.sgame{Job.worker*}=4-5\ncom.tencent.tmgp.sgame{UnityGfxDeviceW}=7" >> "$MODULE_PATH/AppOpt/applist.conf"
#                     else  
#                         touch "$MODULE_PATH/AppOpt/applist.conf"
#                         echo -e "\n#王者荣耀\ncom.tencent.tmgp.sgame=0-2,4-5,7\ncom.tencent.tmgp.sgame{Thread*}=0-2\ncom.tencent.tmgp.sgame{UnityMain}=3-5\ncom.tencent.tmgp.sgame{Job.worker*}=4-5\ncom.tencent.tmgp.sgame{UnityGfxDeviceW}=7" >> "$MODULE_PATH/AppOpt/applist.conf"
#                     fi
#                     ;;
#             esac
#         fi
#     else
#         local_print "- 是否安装Games-opt线程优化？
# - 音量↑：是
# - 音量↓：否" "- Whether to install the Games-opt thread optimization?
# - Volume key↑: Yes
# - Volume key↓: No"
#         key_check
#         case "$keycheck" in
#             "KEY_VOLUMEUP")
#                 if [ -n "$(which magisk)" ]; then
#                     magisk --install-module $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/ksud" ]; then
#                     /data/adb/ksud module install $MODPATH/modules/Games-opt.zip
#                 elif [ -f "/data/adb/apd" ]; then
#                     /data/adb/apd module install $MODPATH/modules/Games-opt.zip
#                 fi
#                 ;;
#         esac
#     fi
# fi

# if [ -n "$(getprop ro.product.system.manufacturer | grep oplus)" ]; then
#     if [ "$soc_model" = "SM8650" ]; then
#         local_print "- 是否切换为scx调速器？
# - 音量↑：是
# - 音量↓：否" "- Whether to switch to the scx governor?
# - Volume key↑: Yes
# - Volume key↓: No"
#         key_check
#         case "$keycheck" in
#             "KEY_VOLUMEDOWN")
#                 sed -i 's/set_default_governor(true, pkg)/set_default_governor(false, pkg)/g' $MODPATH/configs/pineapple.lua
#                 ;;
#         esac
#     elif [ "$soc_model" = "SM8750" ]; then
#         local_print "- 是否切换为scx调速器？
# - 音量↑：是
# - 音量↓：否" "- Whether to switch to the scx governor?
# - Volume key↑: Yes
# - Volume key↓: No"
#         key_check
#         case "$keycheck" in
#             "KEY_VOLUMEDOWN")
#                 sed -i 's/set_default_governor(true, pkg)/set_default_governor(false, pkg)/g' $MODPATH/configs/sun.lua
#                 ;;
#         esac
#     fi
# fi

# if [ -f "/sdcard/Android/fas-rs/fas-rs-pro-installed" ]; then
#     local_print "- 是否开启fas-rs-pro的api4实验性功能？
# - 音量↑：是
# - 音量↓：否" "- Whether to enable the experimental features of API v4 in fas-rs-pro?
# - Volume key↑: Yes
# - Volume key↓: No"
#     key_check
#     case "$keycheck" in
#         "KEY_VOLUMEDOWN")
#             sed -i '/sed -i "s/-- //g" $MODDIR\/main.lua/d' "$MODPATH/service.sh"
#             ;;
#     esac
# fi

if [ -f "$MODPATH/tem_mod" ]; then
    > "$MODPATH/tem_mod"
fi

local_print "- 是否关闭或修改fas-rs核心温控？
- 音量↑：是
- 音量↓：否" "- Whether to disable or modify the fas-rs core temperature control?
- Volume key↑: Yes
- Volume key↓: No"
key_check
case "$keycheck" in
    "KEY_VOLUMEUP")
        local_print "- 请选择修改或关闭fas-rs核心温控：
- 音量↑：修改fas-rs核心温控
- 音量↓：关闭fas-rs核心温控" "- Please choose to modify or disable the fas-rs core temperature control
- Volume key↑: Modify the fas-rs temperature control
- Volume key↓: Disable the fas-rs temperature control"
        key_check
        case "$keycheck" in
            "KEY_VOLUMEUP")
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
                echo "modify" > "$MODPATH/tem_mod"
                ;;
            "KEY_VOLUMEDOWN")
                if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
                    sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$MOD_CONF"
                else
                    sed -i 's/core_temp_thresh = [^ ]*/core_temp_thresh = "disabled"/g' "$CONF"
                fi
                echo "disable" > "$MODPATH/tem_mod"
                ;;
        esac
        ;;
esac

case "$soc_model" in
    "SM8750")
        cp "$MODPATH/configs/sun.lua" "$MODPATH/main.lua"
        ;;
    "SM8650")
        cp "$MODPATH/configs/pineapple.lua" "$MODPATH/main.lua"
        ;;
    "SM7675" | "SM8550" | "SM8635")
        cp "$MODPATH/configs/kalama.lua" "$MODPATH/main.lua"
        ;;
    *)
        cp "$MODPATH/configs/taro.lua" "$MODPATH/main.lua"
        ;;
esac

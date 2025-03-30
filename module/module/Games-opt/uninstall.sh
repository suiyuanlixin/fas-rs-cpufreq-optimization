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
MOD_EXTENSIONS=/data/adb/fas-rs/extensions
MODULE_PATH=/data/adb/modules
DIR=/sdcard/Android/fas-rs
id=$(awk -F= '/^id/ {print $2}' $MODDIR/module.prop)

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    rm -rf $MOD_EXTENSIONS/${id}.lua
fi

# if grep -qi "^name=Games-opt" "$MODULE_PATH/AppOpt/module.prop"; then
#     rm -rf $MODULE_PATH/AppOpt
# fi

if [ -f "/data/adb/fas-rs/fas-rs-mod-installed" ]; then
    sed -i 's/\\n☕️[^\\]*//g' "/data/data/com.omarea.vtools/files/manifest.json"
fi

if [ -f "$DIR/fas-rs-u-c-installed" ] || grep -qi "^name=fas-rs-usage-clamping" "$MODULE_PATH/fas-rs/module.prop"; then
    while grep -q "fas-rs[ -]cpufreq-opt" "/data/data/com.omarea.vtools/files/manifest.json"; do
        sed -i "/\"version\":/ s/\\\\n- (@[^)]*) fas-rs[ -]cpufreq-opt[ ]*: [^\\\\]*\\\\n/\\\\n/" "/data/data/com.omarea.vtools/files/manifest.json"
    done
fi

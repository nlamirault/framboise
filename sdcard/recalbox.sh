#!/bin/bash

# Copyright (C) 2016 Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

dir=$(dirname "$(readlink -f "$0")")
. ${dir}/commons.sh

recalbox_version="4.0.0-beta5"

echo -e "${OK_COLOR}== Recalbox ${recalbox_version} for Raspberry Pi ==${NO_COLOR}"
if [ $# -eq 0 ]; then
    display_usage
fi

os=$(get_os)
echo -e "${WARN_COLOR}Operating system: $os${NO_COLOR}"

sdcard=$(get_sdcard $1 ${os})
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the Recalbox image${NO_COLOR}"
if [ ! -f "recalboxOS-${recalbox_version}.zip" ]; then
    curl -LO --progress-bar https://github.com/recalbox/recalbox-os/releases/download/${recalbox_version}/recalboxOS-${recalbox_version}.zip
fi

echo -e "${WARN_COLOR}Extracting the Recalbox image${NO_COLOR}"
if [ ! -d "recalbox_${recalbox_version}" ]; then
    unzip recalboxOS-${recalbox_version}.zip -d recalboxOS-${recalbox_version}
fi

setup_sdcard $sdcard $os

echo -e "${WARN_COLOR}Installing OSMC to SD Card${NO_COLOR}"
if [ ! -d "recalbox_${recalbox_version}" ]; then
    cp -r recalboxOS-${recalbox_version}/* ${sdcard}
fi

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

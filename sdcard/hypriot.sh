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

. commons.sh

hypriot_version="0.8.0"
hypriot_img="v${hypriot_version}"

echo -e "${OK_COLOR}== Hypriot ${hypriot_version} for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -eq 0 ]; then
    display_usage
fi

os=$(get_os)
echo -e "${WARN_COLOR}Operating system: $os${NO_COLOR}"

sdcard=$(get_sdcard $1 ${os})
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the Hypriot image${NO_COLOR}"
if [ ! -f "hypriot-rpi-${hypriot_img}.img.zip" ]; then
    curl -LO  --progress-bar http://downloads.hypriot.com/hypriot-rpi-${hypriot_img}.img.zip
fi

echo -e "${WARN_COLOR}Extracting the Hypriot image${NO_COLOR}"
if [ ! -f "hypriot-rpi-${hypriot_img}.img" ]; then
     unzip hypriot-rpi-${hypriot_img}.img.zip
fi

setup_sdcard ${sdcard} ${os}

echo -e "${WARN_COLOR}Installing Hypriot to SD Card${NO_COLOR}"
flash_sdcard ${sdcard} hypriot-rpi-${hypriot_img}.img ${os}

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

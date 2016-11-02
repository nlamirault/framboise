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

osmc_version="2016.06-2"
osmc_img_version="20160621"

echo -e "${OK_COLOR}== OSMC ${osmc_version} for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -eq 0 ]; then
    display_usage
fi

os=$(get_os)
echo -e "${WARN_COLOR}Operating system: $os${NO_COLOR}"

sdcard=$(get_sdcard $1 ${os})
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the OSMC root filesystem${NO_COLOR}"
if [ ! -f "OSMC_TGT_rbp2_${osmc_img_version}.img.gz" ]; then
    curl -LO --progress-bar http://download.osmc.tv/installers/diskimages/OSMC_TGT_rbp2_${osmc_img_version}.img.gz
fi

echo -e "${WARN_COLOR}Extracting the OSMC image${NO_COLOR}"
if [ ! -f "OSMC_TGT_rpb2_${osmc_img_version}.img" ]; then
     gunzip -d OSMC_TGT_rpb2_${osmc_img_version}.img.gz
fi

setup_sdcard $sdcard $os

echo -e "${WARN_COLOR}Installing OSMC to SD Card${NO_COLOR}"
flash_sdcard ${sdcard} OSMC_TGT_rpb2_${osmc_img_version}.img ${os}

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

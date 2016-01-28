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

NO_COLOR="\033[0m"
OK_COLOR="\033[32;01m"
ERROR_COLOR="\033[31;01m"
WARN_COLOR="\033[33;01m"

openelec_version="6.0.1"

echo -e "${OK_COLOR}== Openelec ${openelec_version} for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -eq 0 ]; then
    echo -e "${ERROR_COLOR}Usage: $0 sdX${NO_COLOR}"
    exit 1
fi

sdcard="/dev/$1"
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the Arch Linux ARM root filesystem${NO_COLOR}"
if [ ! -f "OpenELEC-RPi2.arm-${openelec_version}.img.gz" ]; then
    curl -LO  --progress-bar http://releases.openelec.tv/OpenELEC-RPi2.arm-${openelec_version}.img.gz
fi

# echo -e "${WARN_COLOR}Setup SD Card${NO_COLOR}"
# parted -s ${sdcard} unit s print
# parted ${sdcard} mkpart primary fat32 0 100%

# echo -e "${WARN_COLOR}Unmounting${NO_COLOR}"
# umount ${sdcard}1

# echo -e "${WARN_COLOR}Installing Openelec to SD Card${NO_COLOR}"
# gunzip -d OpenELEC-RPi2.arm-${openelec_version}.img.gz
# dd if=OpenELEC-RPi2.arm-${openelec_version}.img of=${sdcard} bs=4M
# sync

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

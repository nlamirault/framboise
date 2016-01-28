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

echo -e "${OK_COLOR}== Arch Linux ARM for Raspberry Pi 2 ==${NO_COLOR}"
if [ $# -eq 0 ]; then
    echo -e "${ERROR_COLOR}Usage: $0 sdX${NO_COLOR}"
    exit 1
fi

sdcard="/dev/$1"
echo -e "${WARN_COLOR}Use sdcard :${NO_COLOR} ${sdcard}"

echo -e "${WARN_COLOR}Downloading the Arch Linux ARM root filesystem${NO_COLOR}"
curl -LO  --progress-bar http://archlinuxarm.org/os/ArchLinuxARM-rpi-2-latest.tar.gz

echo -e "${WARN_COLOR}Setup SD Card${NO_COLOR}"
parted -s ${sdcard} unit s print

parted -s ${sdcard} mktable msdos
parted -s ${sdcard} mkpart primary fat32 2048s 128MB
parted -s ${sdcard} mkpart primary ext4 128MB 100%
parted -s ${sdcard} set 1 boot on
parted -s ${sdcard} unit s print

mkfs.vfat ${sdcard}1
mkfs.ext4 ${sdcard}2

mkdir boot
mkdir root

mount ${sdcard}1 boot
mount ${sdcard}2 root

echo -e "${WARN_COLOR}Extracting the root filesystem${NO_COLOR}"
bsdtar -xpf ArchLinuxARM-rpi-2-latest.tar.gz -C root
sync

echo -e "${WARN_COLOR}Moving boot files to the first partition${NO_COLOR}"
mv root/boot/* boot

echo -e "${WARN_COLOR}Unmounting the two partitions${NO_COLOR}"
umount boot root

rmdir boot
rmdir root

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

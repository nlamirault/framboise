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

raspbian_dir="2015-11-24"
raspbian_version="2015-11-21"

echo -e "${OK_COLOR}== QEmu Raspbian ${raspbian_version} ==${NO_COLOR}"

echo -e "${WARN_COLOR}Downloading the Raspbian image${NO_COLOR}"
if [ ! -f "${raspbian_version}-raspbian-jessie.zip" ]; then
    curl -LO  --progress-bar http://downloads.raspberrypi.org/raspbian/images/raspbian-${raspbian_dir}/${raspbian_version}-raspbian-jessie.zip
fi

echo -e "${WARN_COLOR}Extracting the Raspbian image${NO_COLOR}"
if [ ! -f "${raspbian_version}-raspbian-jessie.img" ]; then
    unzip ${raspbian_version}-raspbian-jessie.zip
fi

echo -e "${WARN_COLOR}Resizing Raspbian image${NO_COLOR}"
qemu-img resize ${raspbian_version}-raspbian-jessie.img +10G

echo -e "${WARN_COLOR}Downloading Linux Kernel${NO_COLOR}"
#if [ ! -f "kernel-qemu" ]; then
# curl -LO --progress-bar http://xecdesign.com/downloads/linux-qemu/kernel-qemu
if [ ! -f "kernel-qemu-4.1.7-jessie" ]; then
    curl -LO --progress-bar https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/master.zip
    unzip master.zip
    mv qemu-rpi-kernel-master/kernel-qemu-4.1.7-jessie .
    rmdir qemu-rpi-kernel-master
fi

echo -e "${WARN_COLOR}Patching Raspbian${NO_COLOR}"
MOUNT_PATH=/mnt/loop0p2
kpartx -av ${raspbian_version}-raspbian-jessie.img
mkdir -v ${MOUNT_PATH} 2> /dev/null
mount /dev/mapper/loop0p2 ${MOUNT_PATH}

# Disable libcofi_rpi.so
# Comment "/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so"
# in "${MOUNT_PATH}/etc/ld.so.preload"
sed -ri "s/^.*libcofi_rpi.so/#\0/g" ${MOUNT_PATH}/etc/ld.so.preload

# Fix partition names
cat << 'EOF' >> ${MOUNT_PATH}/etc/udev/rules.d/90-qemu.rules
KERNEL=="sda", SYMLINK+="mmcblk0"
KERNEL=="sda?", SYMLINK+="mmcblk0p%n"
KERNEL=="sda2", SYMLINK+="root"
EOF

# Umount the partition
umount ${MOUNT_PATH}
kpartx -d ${raspbian_version}-raspbian-jessie.img

echo -e "${WARN_COLOR}Launch QEmu Raspbian${NO_COLOR}"
# qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda ${raspbian_version}-raspbian-jessie.img

qemu-system-arm -kernel kernel-qemu-4.1.7-jessie -cpu arm1176 -m 256 -M versatilepb -no-reboot -no-shutdown -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw" -hda ${raspbian_version}-raspbian-jessie.img

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

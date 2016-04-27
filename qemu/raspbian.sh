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

PWD=$(dirname $(readlink -f $0))
. ${PWD}/common.sh

raspbian_dir="2015-11-24"
raspbian_version="2015-11-21"

echo -e "${OK_COLOR}== QEmu Raspbian ${raspbian_version} ==${NO_COLOR}"

echo -e "${WARN_COLOR}Downloading the Raspbian image${NO_COLOR}"
download_file ${raspbian_version}-raspbian-jessie.zip http://downloads.raspberrypi.org/raspbian/images/raspbian-${raspbian_dir}/${raspbian_version}-raspbian-jessie.zip

echo -e "${WARN_COLOR}Extracting the Raspbian image${NO_COLOR}"
extract_image ${raspbian_version}-raspbian-jessie.zip ${raspbian_version}-raspbian-jessie.img

echo -e "${WARN_COLOR}Resizing Raspbian image${NO_COLOR}"
qemu-img resize ${raspbian_version}-raspbian-jessie.img +10G

download_linux_kernel

echo -e "${WARN_COLOR}Patching Raspbian${NO_COLOR}"
loop=$(losetup -f)
mount_path=/mnt/${loop}
sudo kpartx -avs ${raspbian_version}-raspbian-jessie.img
sudo mkdir -v ${mount_path} 2> /dev/null
sudo mount /dev/mapper/${loop} ${mount_path}

sudo sed -e '/.*libarmmem.so.*/ s/^#*/#/' -i ${mount_path}/etc/ld.so.preload
sudo sed -e '/.*\/dev\/mmcblk.*/ s/^#*/#/' -i ${mount_path}/etc/fstab

# Umount the partition
sudo umount ${mount_path}
sudo kpartx -d ${raspbian_version}-raspbian-jessie.img

echo -e "${WARN_COLOR}Launch QEmu Raspbian${NO_COLOR}"
qemu-system-arm \
    -kernel kernel-qemu-4.1.7-jessie \
    -cpu arm1176 \
    -m 256 \
    -M versatilepb \
    # -no-reboot \
    # -no-shutdown \
    -serial stdio \
    -append "root=/dev/sda2 rootfstype=ext4 rw" \
    -hda ${raspbian_version}-raspbian-jessie.img

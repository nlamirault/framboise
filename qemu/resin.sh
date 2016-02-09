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

if [ $# -ne 2 ]; then
    echo "$0 <application> <image>"
    exit 1
fi

app=$1
image=$2

echo -e "${OK_COLOR}== QEmu Resin.io [${app}] ==${NO_COLOR}"

download_linux_kernel

# Patch or not ?
#
# echo -e "${WARN_COLOR}Patching Raspbian${NO_COLOR}"
# sudo kpartx -avs ${image}
# dev_loop=$(losetup -a|grep "${image}"|awk -F":" '{print $1}')
# loop=$(basename ${dev_loop})
# mount_path="/mnt/${loop}p2"
# sudo mkdir -v ${mount_path} 2> /dev/null
# sudo mount /dev/mapper/${loop}p2 ${mount_path}

# if [ ! -d "${mount_path}/etc/" ]; then
#     echo -e "${ERROR_COLOR}Mount ${mount_path} failed.${NO_COLOR}"
#     exit 1
# fi
# if [ -f "${mount_path}/etc/fstab" ]; then
#     sudo sed -e '/.*\/dev\/mmcblk.*/ s/^#*/#/' -i ${mount_path}/etc/fstab
# fi

# # Umount the partition
# sudo umount ${mount_path}
# sudo kpartx -d ${image}

echo -e "${WARN_COLOR}Launch QEmu Resin.io ${NO_COLOR}"
qemu-system-arm \
    -M versatilepb \
    -cpu arm1176 \
    -kernel kernel-qemu-4.1.7-jessie \
    -hda ${image} \
    -m 256 \
    -append "root=/dev/sda2 rootfstype=ext4 rw"

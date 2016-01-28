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

echo -e "${WARN_COLOR}Downloading Linux Kernel${NO_COLOR}"
if [ ! -f "kernel-qemu" ]; then
    curl -LO --progress-bar http://xecdesign.com/downloads/linux-qemu/kernel-qemu
fi

echo -e "${WARN_COLOR}Resizing Raspbian image${NO_COLOR}"
qemu-img resize ${raspbian_version}-raspbian-jessie.img +10G

echo -e "${WARN_COLOR}Patching Raspbian${NO_COLOR}"
echo -e "If it is the first boot, into the file /etc/ld.so.preload, comment this line:"
echo -e "#/usr/lib/arm-linux-gnueabihf/libcofi_rpi.so"

echo -e "${WARN_COLOR}Launch QEmu Raspbian${NO_COLOR}"
qemu-system-arm -kernel kernel-qemu -cpu arm1176 -m 256 -M versatilepb -no-reboot -serial stdio -append "root=/dev/sda2 panic=1 rootfstype=ext4 rw" -hda ${raspbian_version}-raspbian-jessie.img

echo -e "${OK_COLOR}== Done ==${NO_COLOR}"

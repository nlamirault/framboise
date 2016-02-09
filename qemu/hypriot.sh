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

hypriot_version="0.6.1"
hypriot_img="20151115-132854"

echo -e "${OK_COLOR}== QEmu Hypriot ${hypriot_version} ==${NO_COLOR}"

echo -e "${WARN_COLOR}Downloading the Hypriot image${NO_COLOR}"
download_file hypriot-rpi-${hypriot_img}.img.zip http://downloads.hypriot.com/hypriot-rpi-${hypriot_img}.img.zip

echo -e "${WARN_COLOR}Extracting the Hypriot image${NO_COLOR}"
extract_image hypriot-rpi-${hypriot_img}.img.zip hypriot-rpi-${hypriot_img}.img

download_linux_kernel

echo -e "${WARN_COLOR}Launch QEmu Hypriot ${hypriot_version}${NO_COLOR}"
qemu-system-arm \
    -M versatilepb \
    -cpu arm1176 \
    -kernel kernel-qemu-4.1.7-jessie \
    -hda hypriot-rpi-${hypriot_img}.img \
    -m 256 \
    -append "root=/dev/sda2 rootfstype=ext4 rw" \
    -net nic -net user,hostfwd=tcp::4444-:22,hostfwd=tcp::22280-:80

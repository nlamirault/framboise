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

echo -e "${WARN_COLOR}Launch QEmu Resin.io ${NO_COLOR}"
qemu-system-arm \
    -M versatilepb \
    -cpu arm1176 \
    -kernel kernel-qemu-4.1.7-jessie \
    -hda ${image} \
    -m 256 \
    -append "root=/dev/sda2 rootfstype=ext4 rw"

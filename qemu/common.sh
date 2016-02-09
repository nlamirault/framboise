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


function download_file {
    file=$1
    uri=$2
    if [ ! -f "${file}" ]; then
        curl -LO  --progress-bar ${uri}
    fi
}

function extract_image {
    file=$1
    image=$2
    if [ ! -f "${image}" ]; then
        unzip ${file}
    fi
}

function download_linux_kernel {
    echo -e "${WARN_COLOR}Downloading Linux Kernel${NO_COLOR}"
    if [ ! -f "kernel-qemu-4.1.7-jessie" ]; then
        curl -LO --progress-bar https://github.com/dhruvvyas90/qemu-rpi-kernel/archive/master.zip
        unzip master.zip
        mv qemu-rpi-kernel-master/kernel-qemu-4.1.7-jessie .
        rmdir qemu-rpi-kernel-master
    fi
}

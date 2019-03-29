#!/usr/bin/env bash
# Copyright 2018 Erik Maciejewski
#
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
# ==============================================================================
# install ubuntu arm port repos for crossbuild dependencies
dpkg --add-architecture armhf
dpkg --add-architecture arm64
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ bionic main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ bionic-updates main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ bionic-security main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ bionic-backports main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
# isolate host repos to host arch
sed -i 's#deb http://archive.ubuntu.com/ubuntu/#deb [arch=amd64] http://archive.ubuntu.com/ubuntu/#g' /etc/apt/sources.list
sed -i 's#deb http://security.ubuntu.com/ubuntu/#deb [arch=amd64] http://security.ubuntu.com/ubuntu/#g' /etc/apt/sources.list
# install arm cross-compile toolchains
apt-get update
apt-get install -y \
  gcc-5-arm-linux-gnueabihf g++-5-arm-linux-gnueabihf \
  gcc-5-aarch64-linux-gnu g++-5-aarch64-linux-gnu
apt-get clean
rm -rf /var/lib/apt/lists/*
# set up symlinks for arm gcc-5
update-alternatives --install /usr/bin/aarch64-linux-gnu-gcc aarch64-linux-gnu-gcc /usr/bin/aarch64-linux-gnu-gcc-5 90 --slave /usr/bin/aarch64-linux-gnu-g++ aarch64-linux-gnu-g++ /usr/bin/aarch64-linux-gnu-g++-5
update-alternatives --install /usr/bin/arm-linux-gnueabihf-gcc arm-linux-gnueabihf-gcc /usr/bin/arm-linux-gnueabihf-gcc-5 90 --slave /usr/bin/arm-linux-gnueabihf-g++ arm-linux-gnueabihf-g++ /usr/bin/arm-linux-gnueabihf-g++-5

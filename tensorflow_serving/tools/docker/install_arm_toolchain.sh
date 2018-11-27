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
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ xenial main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ xenial-updates main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ xenial-security main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
echo 'deb [arch=armhf,arm64] http://ports.ubuntu.com/ xenial-backports main restricted universe multiverse' >> /etc/apt/sources.list.d/arm.list
# isolate host repos to host arch
sed -i 's#deb http://archive.ubuntu.com/ubuntu/#deb [arch=amd64] http://archive.ubuntu.com/ubuntu/#g' /etc/apt/sources.list
sed -i 's#deb http://security.ubuntu.com/ubuntu/#deb [arch=amd64] http://security.ubuntu.com/ubuntu/#g' /etc/apt/sources.list
# install arm toolchains
apt-get update
apt-get install -y gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf libpython-all-dev:armhf
apt-get install -y gcc-aarch64-linux-gnu g++-aarch64-linux-gnu libpython-all-dev:arm64
apt-get clean
rm -rf /var/lib/apt/lists/*

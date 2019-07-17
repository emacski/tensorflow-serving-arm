#!/usr/bin/env bash
# Copyright 2019 Erik Maciejewski
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# install arm cross-compile toolchains
apt-get update && \
apt-get install -y \
  gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
  gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
apt-get clean && \
rm -rf /var/lib/apt/lists/*

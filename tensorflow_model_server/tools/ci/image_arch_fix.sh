#!/usr/bin/env sh
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

# quick and dirty script to fix image arch in configs
# note this sript relies on jq (apt-get install jq)

set -e

work_dir=".image_arch_fix"
image=$1
platform=$2

os="$(echo $platform | cut -d '_' -f1)"
arch="$(echo $platform | cut -d '_' -f2)"

mkdir -p $work_dir
cd $work_dir
docker save $image -o image.tar
tar -xvf image.tar
rm image.tar
config=$(jq -r '.[0].Config' manifest.json)
sed -i "s/amd64/$arch/g" $config
tar -cvf image.tar .
docker load -i image.tar
cd ..
rm -rf $work_dir

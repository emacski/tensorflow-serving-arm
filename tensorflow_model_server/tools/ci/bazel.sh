#!/bin/sh
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

DEFAULT_BUILD_FQIN="emacski/tensorflow-serving-arm:latest-devel"

if [ -z "$PROJECT_BUILD_FQIN" ]; then
    PROJECT_BUILD_FQIN=$DEFAULT_BUILD_FQIN
fi

docker run --rm \
    -e PROJECT_REGISTRY_PREFIX=$PROJECT_REGISTRY_PREFIX \
    -e PROJECT_GIT_COMMIT=$PROJECT_GIT_COMMIT \
    -e PROJECT_GIT_BRANCH=$PROJECT_GIT_BRANCH \
    -e PROJECT_GIT_URL=$PROJECT_GIT_URL \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v $PWD:/build \
    -w /build \
    $PROJECT_BUILD_FQIN bazel $@

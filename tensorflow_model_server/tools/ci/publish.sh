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

set -e

# this script must be run in the top-level project dir

if [ -z "$PROJECT_REGISTRY_PREFIX" ]; then
    PROJECT_REGISTRY_PREFIX="emacski/tensorflow-serving"
fi

UPSTREAM_TFS_VERSION=$(echo -n $(./tools/wsc.sh | head -n 1 | cut -d ' ' -f 2))

PROJECT_PLATFORMS="linux_amd64_avx_sse4.2 linux_arm64_armv8-a linux_arm64_armv8.2-a linux_arm_armv7-a_neon_vfpv3 linux_arm_armv7-a_neon_vfpv4"

GENERIC_PLATFORMS="linux_amd64 linux_arm64 linux_arm"

retag_platform_bundle() {
    local old_prefix=$1; local new_prefix=$2; local platforms="$3"
    for platform in $platforms; do
        docker tag $old_prefix-$platform $new_prefix-$platform
    done
}

publish_platform_bundle() {
    local manifest=$1; local platforms="$2"
    # push platform image bundle
    for platform in $platforms; do
        # quick and dirty image arch metadata fix for arm images
        tensorflow_model_server/tools/ci/image_arch_fix.sh $manifest-$platform $platform
        docker push $manifest-$platform
    done
    # create and push manifest for arch image bundle
    imgs=""
    for platform in $platforms; do
        imgs="$imgs $manifest-$platform"
    done
    docker manifest create $manifest $imgs
    for platform in $platforms; do
        os="$(echo $platform | cut -d '_' -f1)"
        arch="$(echo $platform | cut -d '_' -f2)"
        if_variant=""
        if [ $arch = "arm64" ]; then
            if_variant="--variant v8"
        fi
        if [ $arch = "arm" ]; then
            if_variant="--variant v7"
        fi
        docker manifest annotate --arch $arch $if_variant --os $os $manifest $manifest-$platform
    done
    docker manifest push --purge $manifest
}

export DOCKER_CLI_EXPERIMENTAL=enabled

# individual images

for platform in $PROJECT_PLATFORMS; do
    image_prefix=$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION
    # quick and dirty image arch metadata fix for arm images
    tensorflow_model_server/tools/ci/image_arch_fix.sh $image_prefix-$platform $platform
    docker push "$image_prefix-$platform"
done

# aliases and manifest lists

docker tag "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_amd64_avx_sse4.2" "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_amd64"
docker tag "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_arm64_armv8-a" "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_arm64"
docker tag "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_arm_armv7-a_neon_vfpv4" "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-linux_arm"

publish_platform_bundle "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION" "$GENERIC_PLATFORMS"

retag_platform_bundle "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION" "$PROJECT_REGISTRY_PREFIX:latest" "$GENERIC_PLATFORMS"
publish_platform_bundle "$PROJECT_REGISTRY_PREFIX:latest" "$GENERIC_PLATFORMS"

# push any changes to the build image
docker tag "$PROJECT_REGISTRY_PREFIX:latest-devel" "$PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-devel"
docker push $PROJECT_REGISTRY_PREFIX:$UPSTREAM_TFS_VERSION-devel
docker push $PROJECT_REGISTRY_PREFIX:latest-devel

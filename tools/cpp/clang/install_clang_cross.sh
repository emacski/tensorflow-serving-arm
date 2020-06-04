#!/bin/sh
# Copyright 2020 Erik Maciejewski
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

# Install llvm / clang toolchain on debian-like linux (debian 10)
# including arch specific includes and supporting objects (like libc++)
# for arm and aarch64 cross-compiling.

set -eu

if [ -z "${INSTALL_LLVM_VERSION}" ]; then
    echo "INSTALL_LLVM_VERSION must be set to a valid version"
    exit 1
fi

DOWNLOAD_PREFIX="https://github.com/llvm/llvm-project/releases/download/llvmorg-${INSTALL_LLVM_VERSION}"

SLUG_PREFIX="clang+llvm-${INSTALL_LLVM_VERSION}"
SLUG_AMD64="${SLUG_PREFIX}-x86_64-linux-gnu-ubuntu-18.04"
SLUG_ARM64="${SLUG_PREFIX}-aarch64-linux-gnu"
SLUG_ARM="${SLUG_PREFIX}-armv7a-linux-gnueabihf"

TAR_FILE_SUFFIX=".tar.xz"

download_extract() {
    local tarfile=$1; local taropts="$2"
    echo ${DOWNLOAD_PREFIX}/${tarfile}
    curl -L ${DOWNLOAD_PREFIX}/${tarfile} -o ${tarfile}
    tar xf ${tarfile} ${taropts}
    rm -rf ${tarfile}
}

download_install_full() {
    local slug=$1
    download_extract ${slug}${TAR_FILE_SUFFIX} "--strip-components=1 -C /usr"
}

download_install_cross() {
    local slug=$1; local triple=$2; local arch=$3
    download_extract ${slug}${TAR_FILE_SUFFIX} ""
    mkdir -p /usr/${triple}/lib/clang/${INSTALL_LLVM_VERSION}
    mv ${slug}/include/c++/v1 /usr/${triple}/include/c++/
    mv ${slug}/lib/clang/${INSTALL_LLVM_VERSION}/include /usr/${triple}/lib/clang/${INSTALL_LLVM_VERSION}/
    mv ${slug}/lib/libc++.a /usr/${triple}/lib/
    mv ${slug}/lib/libc++abi.a /usr/${triple}/lib/
    mv ${slug}/lib/libunwind.a /usr/${triple}/lib/
    mv ${slug}/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/libclang_rt.builtins-${arch}.a /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
    mv ${slug}/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtbegin-${arch}.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
    mv ${slug}/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtend-${arch}.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
    rm -rf ${slug}
}

# amd64 - full toolchain install for host
download_install_full ${SLUG_AMD64}
# arm64 - only keep what we need to cross compile
download_install_cross ${SLUG_ARM64} "aarch64-linux-gnu" "aarch64"
# arm - only keep what we need to cross compile
download_install_cross ${SLUG_ARM} "arm-linux-gnueabihf" "armhf"

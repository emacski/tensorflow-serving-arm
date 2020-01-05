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

# containerized build environment
FROM debian:buster as build
# install gnu/gcc cross-build toolchain (gcc 8.3)
RUN apt-get update && \
    apt-get install -y \
        curl xz-utils \
        gcc g++ \
        gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
# install llvm/clang cross-build toolchain
RUN apt-get update && \
    apt-get install -y libtinfo5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV INSTALL_LLVM_VERSION=9.0.0
ADD install_clang_cross.sh /tmp/
RUN /tmp/install_clang_cross.sh
# install bazel
RUN apt-get update && \
    apt-get install -y zip unzip && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV INSTALL_BAZEL_VERSION=2.0.0
RUN curl -L https://github.com/bazelbuild/bazel/releases/download/${INSTALL_BAZEL_VERSION}/bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh \
        -o bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    chmod +x bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    ./bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    rm -f bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh
# project build deps
ENV DOCKER_CLI_EXPERIMENTAL=enabled
RUN apt-get update && \
    apt-get install -y \
        pkg-config autoconf libtool \
        make patch zlib1g-dev \
        docker.io \
        python3 \
        python3-six && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1
# containerized development environment
FROM build as devel
RUN echo 'PS1="\[$(tput setaf 3)$(tput bold)[\]devel@\\h:\\W]#\[$(tput sgr0) \]"' >> /root/.bashrc

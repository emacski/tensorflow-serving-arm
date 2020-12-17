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
# cc toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        gcc g++ \
        gcc-arm-linux-gnueabihf g++-arm-linux-gnueabihf \
        gcc-aarch64-linux-gnu g++-aarch64-linux-gnu \
        libtinfo5 \
        curl xz-utils ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV INSTALL_LLVM_VERSION=10.0.0
RUN curl -L https://raw.githubusercontent.com/emacski/bazel-tools/master/toolchain/cpp/clang/install_clang_cross.sh \
        -o install_clang_cross.sh && \
    sh install_clang_cross.sh && rm -f install_clang_cross.sh
# python toolchain
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        python3 python3-distutils python3-six \
        libpython3.7-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    update-alternatives --install /usr/bin/python python /usr/bin/python3.7 1 && \
    curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py && \
    python get-pip.py && rm -f get-pip.py && \
    python -m pip install --no-cache-dir numpy
# docker cli
ENV INSTALL_DOCKER_VERSION=19.03.14
RUN curl -L https://download.docker.com/linux/ubuntu/dists/bionic/pool/stable/amd64/docker-ce-cli_${INSTALL_DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb \
        -o docker-ce-cli_${INSTALL_DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb && \
    dpkg -i docker-ce-cli_${INSTALL_DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb && \
    rm -f docker-ce-cli_${INSTALL_DOCKER_VERSION}~3-0~ubuntu-bionic_amd64.deb
ENV DOCKER_CLI_EXPERIMENTAL=enabled
# bazel
RUN apt-get update && \
    apt-get install -y \
        zip unzip pkg-config autoconf libtool \
        make patch zlib1g-dev git && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
ENV INSTALL_BAZEL_VERSION=3.7.0
RUN curl -L https://github.com/bazelbuild/bazel/releases/download/${INSTALL_BAZEL_VERSION}/bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh \
        -o bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    chmod +x bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    ./bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh && \
    rm -f bazel-${INSTALL_BAZEL_VERSION}-installer-linux-x86_64.sh
# containerized development environment
FROM build as devel
RUN echo 'PS1="\[$(tput setaf 3)$(tput bold)[\]devel@\\h:\\W]#\[$(tput sgr0) \]"' >> /root/.bashrc

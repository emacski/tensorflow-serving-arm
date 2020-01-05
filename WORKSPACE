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

workspace(name = "com_github_emacski_tensorflowservingarm")

# x86_64 to arm(64) cross-compile toolchain
register_toolchains(
    "//tools/cpp/cross:cc-toolchain-clang",
)

# hack: tf depends on this specific toolchain target name to be used
# as crosstool for one its config settings when building for arm
load("//tools/cpp:cc_repo_config.bzl", "cc_repo_config")

cc_repo_config(name = "local_config_arm_compiler")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

# project rules

# deb_package
# https://github.com/bazelbuild/rules_pkg
http_archive(
    name = "deb_package",
    sha256 = "08ce92b9aea59ce6d592404de6cdfd7100c1140cdf4d4b9266942c20ec998b27",
    strip_prefix = "rules_pkg-0.2.4/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.2.4.tar.gz"],
)

# rules_docker
# https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "14ac30773fdb393ddec90e158c9ec7ebb3f8a4fd533ec2abbfd8789ad81a284b",
    strip_prefix = "rules_docker-0.12.1",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.12.1/rules_docker-v0.12.1.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repos = "repositories")

container_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

# tensorflow/tensorflow and deps

# https://github.com/tensorflow/tensorflow
http_archive(
    name = "org_tensorflow",
    patches = [
        "//third_party/tensorflow:curl.BUILD.patch",
        "//third_party/tensorflow:hwloc.BUILD.bazel.patch",
    ],
    sha256 = "750186951a699cb73d6b440c7cd06f4b2b80fd3ebb00cbe00f655c7da4ae243e",
    strip_prefix = "tensorflow-590d6eef7e91a6a7392c8ffffb7b58f2e0c8bc6b",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/590d6eef7e91a6a7392c8ffffb7b58f2e0c8bc6b.tar.gz",
    ],
)

# see tensorflow/serving/WORKSPACE
http_archive(
    name = "io_bazel_rules_closure",
    sha256 = "ddce3b3a3909f99b28b25071c40b7fec7e2e1d1d1a4b2e933f3082aa99517105",
    strip_prefix = "rules_closure-316e6133888bfc39fb860a4f1a31cfcbae485aef",
    urls = [
        "https://github.com/bazelbuild/rules_closure/archive/316e6133888bfc39fb860a4f1a31cfcbae485aef.tar.gz",
    ],
)

# requires c++ includes for non-c++ compile action, so this patch
# disables default libc++ includes as the toolchain sets includes manually.
http_archive(
    name = "nsync",
    patches = [
        "//third_party/tensorflow:nsync.BUILD.patch",
    ],
    sha256 = "caf32e6b3d478b78cff6c2ba009c3400f8251f646804bcb65465666a9cea93c4",
    strip_prefix = "nsync-1.22.0",
    urls = [
        "https://storage.googleapis.com/mirror.tensorflow.org/github.com/google/nsync/archive/1.22.0.tar.gz",
        "https://github.com/google/nsync/archive/1.22.0.tar.gz",
    ],
)

# tensorflow/serving and deps

# override tf_serving libevent for the latest stable 2.1.x version
http_archive(
    name = "com_github_libevent_libevent",
    build_file = "@//third_party/libevent:BUILD",
    sha256 = "dffa4e78139a6f927edc6396c9c54d1aa4dbf8413e537863c59b179d7beabdd0",
    strip_prefix = "libevent-release-2.1.11-stable",
    urls = [
        "https://github.com/libevent/libevent/archive/release-2.1.11-stable.zip",
    ],
)

# https://github.com/tensorflow/serving
http_archive(
    name = "tf_serving",
    patches = [
        "//third_party/serving:apis.BUILD.patch",
    ],
    sha256 = "4ad265afb5b7a5cfa38e374a6d7a2f8fcb25b5222ac0c413dbc04cd00a3499c0",
    strip_prefix = "serving-1.15.0",
    urls = [
        "https://github.com/tensorflow/serving/archive/1.15.0.tar.gz",
    ],
)

load("@tf_serving//tensorflow_serving:workspace.bzl", "tf_serving_workspace")

tf_serving_workspace()

# debian packages

load("@deb_package//:deb_packages.bzl", "deb_packages")

http_file(
    name = "buster_archive_key",
    sha256 = "9c854992fc6c423efe8622c3c326a66e73268995ecbe8f685129063206a18043",
    urls = ["https://ftp-master.debian.org/keys/archive-key-10.asc"],
)

http_file(
    name = "buster_archive_security_key",
    sha256 = "4cf886d6df0fc1c185ce9fb085d1cd8d678bc460e6267d80a833d7ea507a0fbd",
    urls = ["https://ftp-master.debian.org/keys/archive-key-10-security.asc"],
)

deb_packages(
    name = "debian_buster_armhf",
    arch = "armhf",
    distro = "buster",
    distro_type = "debian",
    mirrors = ["http://deb.debian.org/debian"],
    packages = {
        "dash": "pool/main/d/dash/dash_0.5.10.2-5_armhf.deb",
    },
    packages_sha256 = {
        "dash": "4287aa31a5c1d9e32f077e90194b37f5d9af326630248c4a3df83c5d3965f219",
    },
    pgp_key = "buster_archive_key",
)

deb_packages(
    name = "debian_buster_arm64",
    arch = "arm64",
    distro = "buster",
    distro_type = "debian",
    mirrors = ["http://deb.debian.org/debian"],
    packages = {
        "dash": "pool/main/d/dash/dash_0.5.10.2-5_arm64.deb",
    },
    packages_sha256 = {
        "dash": "63d948ae0479c25652798cb072ecb4a24ab281cda477224773f033b570760058",
    },
    pgp_key = "buster_archive_key",
)

deb_packages(
    name = "debian_buster_amd64",
    arch = "amd64",
    distro = "buster",
    distro_type = "debian",
    mirrors = ["http://deb.debian.org/debian"],
    packages = {
        "dash": "pool/main/d/dash/dash_0.5.10.2-5_amd64.deb",
    },
    packages_sha256 = {
        "dash": "e4872d9f258e76665317c94c637b4270dc1c15c9cf42da90dbfde0225c7f4564",
    },
    pgp_key = "buster_archive_key",
)

# docker base images

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

# amd64

container_pull(
    name = "discolix_cc_linux_amd64",
    digest = "sha256:96a7d582cbc74f094346b51894d6b855d3a43323084f8805d3c188ef1f32586c",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_debug_linux_amd64",
    digest = "sha256:cdf4fd88dcc9cae6508084b50b7aa1e7834a065426b99989cebc6982de67db77",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:b9d8dd4a3aa547d12651a1085db2296381d8ee593087f68ed84e13e66ef3f5a7",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_debug_linux_arm64",
    digest = "sha256:f6e3d0c9b57c3924cab2f891e8f077f4f1390388fb3ca08eec5c85c7681ffcc2",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:d3e387995f8f1f892b00dd7da58a8dc87fab9b9ca8ec70692df674b390c4bdd8",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_debug_linux_arm",
    digest = "sha256:4fb7463db2391762742fcbf8acbf8a5e0c251b7aa2eb8f83cf4e626c907a0394",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

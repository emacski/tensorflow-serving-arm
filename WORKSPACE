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
# as crosstool for one of its config_settings when building for arm
load("//tools/cpp:cc_repo_config.bzl", "cc_repo_config")

cc_repo_config(name = "local_config_arm_compiler")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

# project rules

# deb_package
# https://github.com/bazelbuild/rules_pkg
http_archive(
    name = "deb_package",
    sha256 = "f8bf72e76a15d045f786ef0eba92e073a50bbdbd807d237a43a759d36b1b1e2c",
    strip_prefix = "rules_pkg-0.2.5/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.2.5.tar.gz"],
)

# rules_docker
# https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "6287241e033d247e9da5ff705dd6ef526bac39ae82f3d17de1b69f8cb313f9cd",
    strip_prefix = "rules_docker-0.14.3",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.3/rules_docker-v0.14.3.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repos = "repositories")

container_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

# tensorflow/tensorflow and deps

# tensorflow 2.2.0
# https://github.com/tensorflow/tensorflow
http_archive(
    name = "org_tensorflow",
    patches = [
        # use canonical cpu value
        "//third_party/tensorflow:BUILD.patch",
        # arm (32-bit) datatype sizes
        "//third_party/tensorflow:curl.BUILD.patch",
        "//third_party/tensorflow:hwloc.BUILD.bazel.patch",
        # possible bug introducing avx2 (x86) intrinsics in aarch64 build
        "//third_party/tensorflow:aws-c-common.bazel.patch",
    ],
    sha256 = "b3d7829fac84e3a26264d84057367730b6b85b495a0fce15929568f4b55dc144",
    strip_prefix = "tensorflow-2b96f3662bd776e277f86997659e61046b56c315",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/2b96f3662bd776e277f86997659e61046b56c315.tar.gz",
    ],
)

# see tensorflow/serving/WORKSPACE and tensorflow/tensorflow/WORKSPACE
http_archive(
    name = "io_bazel_rules_closure",
    sha256 = "5b00383d08dd71f28503736db0500b6fb4dda47489ff5fc6bed42557c07c6ba9",
    strip_prefix = "rules_closure-308b05b2419edb5c8ee0471b67a40403df940149",
    urls = [
        "https://github.com/bazelbuild/rules_closure/archive/308b05b2419edb5c8ee0471b67a40403df940149.tar.gz",
    ],
)

# see tensorflow/serving/WORKSPACE and tensorflow/tensorflow/WORKSPACE
http_archive(
    name = "bazel_skylib",
    sha256 = "1dde365491125a3db70731e25658dfdd3bc5dbdfd11b840b3e987ecf043c7ca0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/releases/download/0.9.0/bazel-skylib.0.9.0.tar.gz"],
)

# patch: requires c++ includes for non-c++ compile action, so this patch
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

# see tensorflow/serving/WORKSPACE
http_archive(
    name = "rules_pkg",
    sha256 = "f8bf72e76a15d045f786ef0eba92e073a50bbdbd807d237a43a759d36b1b1e2c",
    strip_prefix = "rules_pkg-0.2.5/pkg",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.2.5.tar.gz"],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

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
    sha256 = "946c1a58d677686e6b986634b51f4bc19486230c7fc2ab669c8492b0662ad4cc",
    strip_prefix = "serving-d22fc192c7ad7b48d9a81346224aff637b8988f1",
    urls = [
        "https://github.com/tensorflow/serving/archive/d22fc192c7ad7b48d9a81346224aff637b8988f1.tar.gz",
    ],
)

load("@tf_serving//tensorflow_serving:workspace.bzl", "tf_serving_workspace")

tf_serving_workspace()

# see tensorflow/serving/WORKSPACE
load("@com_github_grpc_grpc//bazel:grpc_deps.bzl", "grpc_deps")

grpc_deps()

load("@upb//bazel:repository_defs.bzl", "bazel_version_repository")

bazel_version_repository(name = "bazel_version")

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
    digest = "sha256:2d313ecdc0e55bd5468f1a1b5dc4cf32decea11f3deaf7d2db7bd3fed96e5662",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_linux_amd64_debug",
    digest = "sha256:e568bbd8855d7e818f287617307c5eb66ff9e30dc8237ac7c3008695858c9613",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:cd425296fb528f809c61a3e123dcb0bfbca3852935f35bcba72eee18e6227d9a",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_linux_arm64_debug",
    digest = "sha256:6079947b317b45b28e580df66d56b7799795bbe4401b2689dc3047cd9e21fd23",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:30c491a8fa9c4278d404964906d8a072b9b7485e3b81b93a85b3e1bafbd30800",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_linux_arm_debug",
    digest = "sha256:da7fdb519a423940160b06649a363d16df1c00dab1f3dae80c54ce9d416d1b83",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

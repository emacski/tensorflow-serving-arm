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

# x86_64 to arm(64) cross-compile toolchains
register_toolchains("//tools/cpp/clang:all")

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
    sha256 = "b9d1387deed06eef45edd3eb7fd166577b8ad1884cb6a17898d136059d03933c",
    strip_prefix = "rules_pkg-0.2.6-1/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.2.6-1.tar.gz"],
)

# rules_docker
# https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "4521794f0fba2e20f3bf15846ab5e01d5332e587e9ce81629c7f96c793bb7036",
    strip_prefix = "rules_docker-0.14.4",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.14.4/rules_docker-v0.14.4.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repos = "repositories")
container_repos()
load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")
container_deps()
load("@io_bazel_rules_docker//repositories:pip_repositories.bzl", "pip_deps")
pip_deps()

# tensorflow/tensorflow and deps

# tensorflow 2.3.0
# https://github.com/tensorflow/tensorflow
http_archive(
    name = "org_tensorflow",
    patches = [
        # arm (32-bit) datatype sizes
        "//third_party/tensorflow:curl.BUILD.patch",
        "//third_party/tensorflow:hwloc.BUILD.bazel.patch",
        # use canonical cpu value
        # as of tf 2.3.0, this seems to only affect aws deps
        "//third_party/tensorflow:BUILD.patch",
    ],
    sha256 = "a474d4328524de1951655cd6afb4888d256c37a0b4a47e6c623b353ab382b39f",
    strip_prefix = "tensorflow-b36436b087bd8e8701ef51718179037cccdfc26e",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/b36436b087bd8e8701ef51718179037cccdfc26e.tar.gz",
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
    strip_prefix = "rules_pkg-0.2.6-1/pkg",
    sha256 = "b9d1387deed06eef45edd3eb7fd166577b8ad1884cb6a17898d136059d03933c",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.2.6-1.tar.gz"],
)

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")
rules_pkg_dependencies()

# override tf_serving libevent for the latest stable 2.1.x version
http_archive(
    name = "com_github_libevent_libevent",
    build_file = "@//third_party/libevent:BUILD",
    strip_prefix = "libevent-release-2.1.12-stable",
    sha256 = "8836ad722ab211de41cb82fe098911986604f6286f67d10dfb2b6787bf418f49",
    urls = [
        "https://github.com/libevent/libevent/archive/release-2.1.12-stable.zip",
    ],
)

# tensorflow serving 2.3.0
# https://github.com/tensorflow/serving
http_archive(
    name = "tf_serving",
    sha256 = "88aaf8aaa5e3719f617679015b5938570e06a02c7793f1a6ca6ebf96e7656252",
    strip_prefix = "serving-0617d7acafcf4073e60bfbdaa2f624ed0b3e1808",
    urls = [
        "https://github.com/tensorflow/serving/archive/0617d7acafcf4073e60bfbdaa2f624ed0b3e1808.tar.gz",
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
    digest = "sha256:3a66e91f4196381f813c75e33900225a7b8911a334d4f49bf177c986fa3a6be7",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_linux_amd64_debug",
    digest = "sha256:dada54e242c04570149f3287684f53047a352cdcdbc7bf84933ca6882cfbf423",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:644ea3eb52c1e4b479f462c9f911da720aead288a3ffd2b1fd4a731456945ae9",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_linux_arm64_debug",
    digest = "sha256:37a1d13c4e6a42a6ec964a717b55830b910b059058259399a04994cb0efafa5e",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:0d27abb6cbf7ad760216954f74a0f502e8d1227122e35104e68c580da5ceb1ed",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_linux_arm_debug",
    digest = "sha256:9dfb903077406172a126ed5e17945b5db0d2d3175d283be25f6b454c358f39bd",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

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

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

http_archive(
    name = "com_github_emacski_bazeltools",
    sha256 = "dba9e8f0613401ed3c052d6fe79b3517197a7747046659845309fb17e9b3038d",
    strip_prefix = "bazel-tools-17a0d8b9ae66bc542853a72365ef1aeb85086827",
    urls = ["https://github.com/emacski/bazel-tools/archive/17a0d8b9ae66bc542853a72365ef1aeb85086827.tar.gz"],
)

load(
    "@com_github_emacski_bazeltools//toolchain/cpp/clang:defs.bzl",
    "register_clang_cross_toolchains",
)

# x86_64 to arm(64) cross-compile toolchains
register_clang_cross_toolchains(clang_version = "11")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "59d5b42ac315e7eadffa944e86e90c2990110a1c8075f1cd145f487e999d22b3",
    strip_prefix = "rules_docker-0.17.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.17.0/rules_docker-v0.17.0.tar.gz"],
)

load(
    "@io_bazel_rules_docker//repositories:repositories.bzl",
    container_repositories = "repositories",
)

container_repositories()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

http_archive(
    name = "com_google_protobuf",
    sha256 = "0cbdc9adda01f6d2facc65a22a2be5cecefbefe5a09e5382ee8879b522c04441",
    strip_prefix = "protobuf-3.15.8",
    urls = ["https://github.com/protocolbuffers/protobuf/archive/v3.15.8.tar.gz"],
)

load("@com_google_protobuf//:protobuf_deps.bzl", "protobuf_deps")

protobuf_deps()

# tensorflow/tensorflow and deps

# tensorflow 2.5.0
http_archive(
    name = "org_tensorflow",
    patches = [
        # align arm cpu config values
        "//third_party/tensorflow:aws.patch",
        # arm (32-bit) datatype sizes
        "//third_party/tensorflow:curl.patch",
        "//third_party/tensorflow:hwloc.patch",
        # set platform cpu constraint on aarch64 config_setting
        "//third_party/tensorflow:mkl.patch",
        # remove explicit linker dep on libgomp
        "//third_party/tensorflow:mkl_dnn.patch",
        # allow android cpu helper to be used for linux_arm and linux_arm64
        "//third_party/tensorflow:tensorflow.patch",
    ],
    patch_args = ["-p1"],
    sha256 = "cb99f136dc5c89143669888a44bfdd134c086e1e2d9e36278c1eb0f03fe62d76",
    strip_prefix = "tensorflow-a4dfb8d1a71385bd6d122e4f27f86dcebb96712d",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/a4dfb8d1a71385bd6d122e4f27f86dcebb96712d.tar.gz",
    ],
)

# tensorflow dependency patch: disable default c++ includes as these are set
# (and configurable) within the custom llvm/clang toolchain
http_archive(
    name = "nsync",
    patches = [
        "//third_party/tensorflow:nsync.patch",
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
    build_file = "//third_party/libevent:BUILD",
    sha256 = "8836ad722ab211de41cb82fe098911986604f6286f67d10dfb2b6787bf418f49",
    strip_prefix = "libevent-release-2.1.12-stable",
    urls = [
        "https://github.com/libevent/libevent/archive/release-2.1.12-stable.zip",
    ],
)

# tensorflow serving 2.5.1
http_archive(
    name = "tf_serving",
    sha256 = "e94726632a0637a460b07e5e1c6c5a30c9f776dda22b5e9132b9ef526fbefa7e",
    strip_prefix = "serving-da76fc74b48f6afe190125f9ed572e690cef8570",
    urls = [
        "https://github.com/tensorflow/serving/archive/da76fc74b48f6afe190125f9ed572e690cef8570.tar.gz",
    ],
)

load("@tf_serving//tensorflow_serving:workspace.bzl", "tf_serving_workspace")

tf_serving_workspace()

load("@org_tensorflow//tensorflow:workspace3.bzl", "tf_workspace3")

tf_workspace3()

load("@org_tensorflow//tensorflow:workspace2.bzl", "tf_workspace2")

tf_workspace2()

load("@org_tensorflow//tensorflow:workspace1.bzl", "tf_workspace1")

tf_workspace1()

load("@org_tensorflow//tensorflow:workspace0.bzl", "tf_workspace0")

tf_workspace0()

load("@rules_pkg//:deps.bzl", "rules_pkg_dependencies")

rules_pkg_dependencies()

# local cross lib repos

new_local_repository(
    name = "local_crosslib_amd64",
    build_file = "BUILD.local_crosslib",
    path = "/usr/lib/x86_64-linux-gnu",
)

new_local_repository(
    name = "local_crosslib_arm64",
    build_file = "BUILD.local_crosslib",
    path = "/usr/aarch64-linux-gnu/lib",
)

new_local_repository(
    name = "local_crosslib_arm",
    build_file = "BUILD.local_crosslib",
    path = "/usr/arm-linux-gnueabihf/lib",
)

# debian packages

http_archive(
    name = "deb_package",
    sha256 = "dff10e80f2d58d4ce8434ef794e5f9ec0856f3a355ae41c6056259b65e1ad11a",
    strip_prefix = "rules_pkg-0.4.0/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.4.0.tar.gz"],
)

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
    digest = "sha256:67268fbe9ca7e6ee25774dd3c5359a81eec285362ef0932f1eeed0e0bf32e0fd",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_linux_amd64_debug",
    digest = "sha256:b02ee67449f57d7b5eeefa611986151bbcf8bb0ff72b05f7b426848455e27ba6",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:dec982052e6f6c1d28f1c1304d2a93b79a2169d8a3273e6029f1033c95be6f31",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_linux_arm64_debug",
    digest = "sha256:c0a4668fc09e174d321f6d0d81e00cf1ee0515d7c220efdcf3b030a92ec98e1b",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:9834a18225f8d9f9651a2144867be78da77c517e1334f2c3c00619d3c62299cc",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_linux_arm_debug",
    digest = "sha256:f1698d4d4d68b4c0c0a7d88a8c2b3abf55c4512ddc7212804d5c5760edb7918f",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

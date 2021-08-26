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
    sha256 = "5d31ad261b9582515ff52126bf53b954526547a3e26f6c25a9d64c48a31e45ac",
    strip_prefix = "rules_docker-0.18.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.18.0/rules_docker-v0.18.0.tar.gz"],
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

# tensorflow 2.6.0
http_archive(
    name = "org_tensorflow",
    patches = [
        # aws - align arm cpu config values
        "//third_party/tensorflow:aws.patch",
        # curl and hwloc - arm (32-bit) datatype sizes
        "//third_party/tensorflow:curl.patch",
        "//third_party/tensorflow:hwloc.patch",
        # mkl - set platform cpu constraint on aarch64 config_setting
        "//third_party/tensorflow:mkl.patch",
        # mkl_dnn - remove explicit linker dep on libgomp
        "//third_party/tensorflow:mkl_dnn.patch",
        # tensorflow - use android cpu helper for arm and arm64 on linux, don't
        # let cuda tools hijack rules_cc, llvm omp.h is already in the include
        # path for this project's cc toolchain
        "//third_party/tensorflow:tensorflow.patch",
    ],
    patch_args = ["-p1"],
    sha256 = "70a865814b9d773024126a6ce6fea68fefe907b7ae6f9ac7e656613de93abf87",
    strip_prefix = "tensorflow-919f693420e35d00c8d0a42100837ae3718f7927",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/919f693420e35d00c8d0a42100837ae3718f7927.tar.gz",
    ],
)

# tensorflow dependency patch: disable default c++ includes as these are set
# at build time by the llvm/clang toolchain
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

# tensorflow serving 2.6.0
http_archive(
    name = "tf_serving",
    sha256 = "5fe87c899e2afea297dead1ee0e1709852ed55578b7975cffefe135f82b61c77",
    strip_prefix = "serving-04d47f8aa567f429185a4416ef58f7fe11a21a43",
    urls = [
        "https://github.com/tensorflow/serving/archive/04d47f8aa567f429185a4416ef58f7fe11a21a43.tar.gz",
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
    sha256 = "0d2e97f71161e8af97cb2fffe321017293127f6ea8b497cb27b2b8a711e64174",
    strip_prefix = "rules_pkg-0.5.1/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.5.1.tar.gz"],
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
    digest = "sha256:c06aaf461ba4550c480f16144aa80096c53d7024b6bb4c2958e42f90f69429ad",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_linux_amd64_debug",
    digest = "sha256:e7ac2bc94d583838c981f148058688ed103e19890b6ee1aa9f5ef4fb685b9c3c",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:a253bbfeabec0e9d205621f33d2311364534b1863f9b25676cc3585d5ff1b8f8",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_linux_arm64_debug",
    digest = "sha256:5fe98ee8a304b8d436a6eb5a8d27647e819357f8a63e7f785aa5c64f8a3971fc",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:fedcd3167d56d472c441306d4a67e10d7f160129eb325d4eca6aa96c90d2fd83",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_linux_arm_debug",
    digest = "sha256:0fa6243398806621111f29529a22aeafceba5969bd7b3d1db08b9fe8743c23fd",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

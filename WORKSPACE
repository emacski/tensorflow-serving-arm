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
    sha256 = "599ab534e1d4a5c647cb0e02ff22356ee60f25174276316a16b76eed326af291",
    strip_prefix = "bazel-tools-2cff23e6f3930199eaafef5758f325304d71b72f",
    urls = ["https://github.com/emacski/bazel-tools/archive/2cff23e6f3930199eaafef5758f325304d71b72f.tar.gz"],
)

# x86_64 to arm(64) cross-compile toolchains
register_toolchains("@com_github_emacski_bazeltools//toolchain/cpp/clang:all")

# project rules

# deb_package
# https://github.com/bazelbuild/rules_pkg
http_archive(
    name = "deb_package",
    sha256 = "e4a2fde34360931549c31d13bbd2ba579e8706d7a1e5970aefefad2d97ca437c",
    strip_prefix = "rules_pkg-0.3.0/deb_packages",
    urls = ["https://github.com/bazelbuild/rules_pkg/archive/0.3.0.tar.gz"],
)

# rules_docker
# https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "1698624e878b0607052ae6131aa216d45ebb63871ec497f26c67455b34119c80",
    strip_prefix = "rules_docker-0.15.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.15.0/rules_docker-v0.15.0.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repos = "repositories")

container_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

load("@io_bazel_rules_docker//repositories:pip_repositories.bzl", "io_bazel_rules_docker_pip_deps")

io_bazel_rules_docker_pip_deps()

# tensorflow/tensorflow and deps

# tensorflow 2.4.1
# https://github.com/tensorflow/tensorflow
http_archive(
    name = "org_tensorflow",
    patches = [
        # align arm cpu config values
        "//third_party/tensorflow:aws.patch",
        # arm (32-bit) datatype sizes
        "//third_party/tensorflow:curl.patch",
        "//third_party/tensorflow:hwloc.patch",
        # allow android cpu helper to be used for linux_arm and linux_arm64
        "//third_party/tensorflow:tensorflow.patch",
    ],
    sha256 = "ac2d19cf529f9c2c9faaf87e472d08a2bdbb2ab058958e2cafd65e5eb0637b2b",
    strip_prefix = "tensorflow-85c8b2a817f95a3e979ecd1ed95bff1dc1335cff",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/85c8b2a817f95a3e979ecd1ed95bff1dc1335cff.tar.gz",
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
    build_file = "//third_party/libevent:BUILD",
    sha256 = "8836ad722ab211de41cb82fe098911986604f6286f67d10dfb2b6787bf418f49",
    strip_prefix = "libevent-release-2.1.12-stable",
    urls = [
        "https://github.com/libevent/libevent/archive/release-2.1.12-stable.zip",
    ],
)

# tensorflow serving 2.4.1
# https://github.com/tensorflow/serving
http_archive(
    name = "tf_serving",
    sha256 = "c5abcd242f7886631be28a141eaac42556f3cf287c3779ffc672a528eae46358",
    strip_prefix = "serving-8300bd1e8878b7fd8b6cbf604d7feef45eb42ab7",
    urls = [
        "https://github.com/tensorflow/serving/archive/8300bd1e8878b7fd8b6cbf604d7feef45eb42ab7.tar.gz",
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
    digest = "sha256:f888804401ae34244ae3dfe2286a004fea446848fcc9dbd9c19632910e1385f9",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_linux_amd64_debug",
    digest = "sha256:0fe8c9f1e0131dbcbc139263e92e4772c46e7161cd2392cd95bb7fd85e3ead97",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:7eabd63fa0da92ea3cb04ed0fda7fdca8ea07fec8797fd692ae6f8d1419ca835",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_linux_arm64_debug",
    digest = "sha256:2b0332cad7d88fd5d2a2fb1069914557673aef9a86caaa04930760a287a2ca81",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:dbee6bebc8a85afbe0d3ce923e0296bf0fa5edd45a43bcc487a36d6868acf131",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_linux_arm_debug",
    digest = "sha256:f0dd6de42d29eb6f0436dc8345cb753099fc425387c9e361c954eb9365a4c89a",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

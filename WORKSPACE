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
    sha256 = "ac040d00f7f00c9947d61c7b8970a877d907c92e088966c24a0eaeeba5551b19",
    strip_prefix = "bazel-tools-250e4a98908fa0c6631ebccdeae930a60fd4c0d5",
    urls = ["https://github.com/emacski/bazel-tools/archive/250e4a98908fa0c6631ebccdeae930a60fd4c0d5.tar.gz"],
)

# x86_64 to arm(64) cross-compile toolchains
register_toolchains("@com_github_emacski_bazeltools//toolchain/cpp/clang:all")

http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "95d39fd84ff4474babaf190450ee034d958202043e366b9fc38f438c9e6c3334",
    strip_prefix = "rules_docker-0.16.0",
    urls = ["https://github.com/bazelbuild/rules_docker/releases/download/v0.16.0/rules_docker-v0.16.0.tar.gz"],
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
        # allow android cpu helper to be used for linux_arm and linux_arm64
        "//third_party/tensorflow:tensorflow.patch",
    ],
    sha256 = "68437339e0d5854d28157ba77a4ae30954f35d08899675e3bb6da9824fbb904a",
    strip_prefix = "tensorflow-0d1805aede03d25aa9d49adcef6903535fa5ad14",
    urls = [
        "https://github.com/tensorflow/tensorflow/archive/0d1805aede03d25aa9d49adcef6903535fa5ad14.tar.gz",
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

# tensorflow serving 2.5.0
http_archive(
    name = "tf_serving",
    sha256 = "755a717e04e89ef6ef3aad12fcc3f65d276af06269e0979f11aadbf3c1f0f213",
    strip_prefix = "serving-84bc4e4bd5b0c624612438e8b6c6e0d39f2c9a66",
    urls = [
        "https://github.com/tensorflow/serving/archive/84bc4e4bd5b0c624612438e8b6c6e0d39f2c9a66.tar.gz",
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

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

# x86_64 to arm(64) cross-compile gcc based toolchains
register_toolchains(
    "//tools/cpp:cc-toolchain-aarch64",
    "//tools/cpp:cc-toolchain-armeabi",
)

# hack: tf depnds on this specific toolchain target name to be used
# as crosstool for one its config settings when building for arm
load("//tools/cpp:cc_repo_config.bzl", "cc_repo_config")

cc_repo_config(name = "local_config_arm_compiler")

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# project rules

# rules_docker
# https://github.com/bazelbuild/rules_docker
http_archive(
    name = "io_bazel_rules_docker",
    sha256 = "e513c0ac6534810eb7a14bf025a0f159726753f97f74ab7863c650d26e01d677",
    strip_prefix = "rules_docker-0.9.0",
    urls = ["https://github.com/bazelbuild/rules_docker/archive/v0.9.0.tar.gz"],
)

load("@io_bazel_rules_docker//repositories:repositories.bzl", container_repos = "repositories")

container_repos()

load("@io_bazel_rules_docker//repositories:deps.bzl", container_deps = "deps")

container_deps()

# tensorflow/tensorflow and deps

http_archive(
    name = "org_tensorflow",
    sha256 = "c4da79385dfbfb30c1aaf73fae236bc6e208c3171851dfbe0e1facf7ca127a6a",
    strip_prefix = "tensorflow-87989f69597d6b2d60de8f112e1e3cea23be7298",
    urls = [
        "https://mirror.bazel.build/github.com/tensorflow/tensorflow/archive/87989f69597d6b2d60de8f112e1e3cea23be7298.tar.gz",
        "https://github.com/tensorflow/tensorflow/archive/87989f69597d6b2d60de8f112e1e3cea23be7298.tar.gz",
    ],
)

http_archive(
    name = "io_bazel_rules_closure",
    sha256 = "ddce3b3a3909f99b28b25071c40b7fec7e2e1d1d1a4b2e933f3082aa99517105",
    strip_prefix = "rules_closure-316e6133888bfc39fb860a4f1a31cfcbae485aef",
    urls = [
        "https://mirror.bazel.build/github.com/bazelbuild/rules_closure/archive/316e6133888bfc39fb860a4f1a31cfcbae485aef.tar.gz",
        "https://github.com/bazelbuild/rules_closure/archive/316e6133888bfc39fb860a4f1a31cfcbae485aef.tar.gz",
    ],
)

http_archive(
    name = "bazel_skylib",
    sha256 = "2c62d8cd4ab1e65c08647eb4afe38f51591f43f7f0885e7769832fa137633dcb",
    strip_prefix = "bazel-skylib-0.7.0",
    urls = ["https://github.com/bazelbuild/bazel-skylib/archive/0.7.0.tar.gz"],
)

# tensorflow/serving and deps

http_archive(
    name = "tf_serving",
    sha256 = "a9ec3cec537b144da632d9d204ebc2f9016734abd39774c75ad911c718d225b5",
    strip_prefix = "serving-1.14.0",
    urls = [
        "https://github.com/tensorflow/serving/archive/1.14.0.tar.gz",
    ],
)

load("@tf_serving//tensorflow_serving:workspace.bzl", "tf_serving_workspace")

tf_serving_workspace()

# docker base images

load("@io_bazel_rules_docker//container:container.bzl", "container_pull")

# amd64

container_pull(
    name = "discolix_cc_linux_amd64",
    digest = "sha256:7f1cec3f073796c18695690c5f8945c4f35b78eedf15428b6eb4b4cfb41403c7",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_amd64",
)

container_pull(
    name = "discolix_cc_debug_linux_amd64",
    digest = "sha256:4e3518f07f19a92e92ad3243d91944f2631958934b752bb88c458acc48972bb6",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_amd64",
)

# arm64

container_pull(
    name = "discolix_cc_linux_arm64",
    digest = "sha256:81bb8674d3e4ff8c213d5887370de0aa4d43e68b1820ce829d23c0a372a49a8c",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm64",
)

container_pull(
    name = "discolix_cc_debug_linux_arm64",
    digest = "sha256:05cb89ebcaed619af1f0224526cd0aaf51396936f86855ad20e5a1ef0cae8392",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm64",
)

# arm

container_pull(
    name = "discolix_cc_linux_arm",
    digest = "sha256:4918ce342dd8101c36d7f1ca9b440b0b49d1cc5d1eca75585a18a632cc6e055f",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "latest-linux_arm",
)

container_pull(
    name = "discolix_cc_debug_linux_arm",
    digest = "sha256:78e254beac1cddb2b8d14101eeab90104a289c610bd2dd5f5c35098eefad9dbb",
    registry = "index.docker.io",
    repository = "discolix/cc",
    tag = "debug-linux_arm",
)

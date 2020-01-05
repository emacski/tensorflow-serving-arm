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

load("@bazel_skylib//lib:selects.bzl", "selects")
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_bundle",
    "container_image",
    "container_layer",
)
load("@debian_buster_armhf//debs:deb_packages.bzl", "debian_buster_armhf")
load("@debian_buster_arm64//debs:deb_packages.bzl", "debian_buster_arm64")
load("@debian_buster_amd64//debs:deb_packages.bzl", "debian_buster_amd64")

cc_library(
    name = "main_lib",
    srcs = [
        "main.cc",
    ],
    linkstamp = "stamp.cc",
    deps = [
        "@tf_serving//tensorflow_serving/model_servers:server_lib",
        "@org_tensorflow//tensorflow/c:c_api",
        "@org_tensorflow//tensorflow/core:lib",
        "@org_tensorflow//tensorflow/core/platform/cloud:gcs_file_system",
        "@org_tensorflow//tensorflow/core/platform/hadoop:hadoop_file_system",
        "@org_tensorflow//tensorflow/core/platform/s3:s3_file_system",
    ],
)

cc_binary(
    name = "tensorflow_model_server",
    linkopts = [
        "-Wl,--build-id=md5",
        "-Wl,--hash-style=gnu",
    ],
    stamp = 1,
    deps = [
        ":main_lib",
    ],
)

# docker

config_setting(
    name = "linux_arm",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:arm",
    ],
)

config_setting(
    name = "linux_arm64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "linux_amd64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "debug",
    define_values = {"image": "debug"},
)

selects.config_setting_group(
    name = "linux_arm_debug",
    match_all = [":linux_arm", ":debug"],
)

selects.config_setting_group(
    name = "linux_arm64_debug",
    match_all = [":linux_arm64", ":debug"],
)

selects.config_setting_group(
    name = "linux_amd64_debug",
    match_all = [":linux_amd64", ":debug"],
)

container_layer(
    name = "dash",
    debs = select({
        ":linux_arm": [debian_buster_armhf["dash"]],
        ":linux_arm64": [debian_buster_arm64["dash"]],
        ":linux_amd64": [debian_buster_amd64["dash"]],
    }),
)

container_image(
    name = "image",
    base = select({
        ":linux_arm": "@discolix_cc_linux_arm//image",
        ":linux_arm64": "@discolix_cc_linux_arm64//image",
        ":linux_amd64": "@discolix_cc_linux_amd64//image",
        ":linux_arm_debug": "@discolix_cc_debug_linux_arm//image",
        ":linux_arm64_debug": "@discolix_cc_debug_linux_arm64//image",
        ":linux_amd64_debug": "@discolix_cc_debug_linux_amd64//image",
    }),
    directory = "/usr/bin/",
    entrypoint = ["tf_serving_entrypoint.sh"],
    env = {
        "MODEL_NAME": "model",
        "MODEL_BASE_PATH": "/models",
    },
    files = [
        ":tf_serving_entrypoint.sh",
        ":tensorflow_model_server",
    ],
    layers = ["dash"],
    ports = [
        "8500",
        "8501",
    ],
    stamp = True,
)

# these targets only serve to give a project ":image" a fully qualified docker
# image name and should always be accompanied by their respective config group like:
# bazel run //tensorflow_model_server:linux_arm64_armv8-a --config=linux_arm64_armv8-a
[container_bundle(
    name = tag,
    images = {"{PROJECT_REGISTRY_PREFIX}:{UPSTREAM_TFS_VERSION}-" + tag: ":image"},
) for tag in [
    "linux_arm_armv7-a_neon_vfpv4",
    "linux_arm_armv7-a_neon_vfpv3",
    "linux_arm64_armv8.2-a",
    "linux_arm64_armv8-a",
    "linux_amd64_avx_sse4.2",
]]

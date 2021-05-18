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

load(
    "@rules_cc//cc:defs.bzl",
    "cc_binary",
    "cc_library",
)
load(
    "@io_bazel_rules_docker//container:container.bzl",
    "container_bundle",
    "container_image",
    "container_layer",
)
load("@debian_buster_armhf//debs:deb_packages.bzl", "debian_buster_armhf")
load("@debian_buster_arm64//debs:deb_packages.bzl", "debian_buster_arm64")
load("@debian_buster_amd64//debs:deb_packages.bzl", "debian_buster_amd64")

package(default_visibility = ["//visibility:public"])

cc_library(
    name = "main_lib",
    srcs = [
        "main.cc",
    ],
    linkstamp = "stamp.cc",
    deps = [
        "@org_tensorflow//tensorflow/c:c_api",
        "@org_tensorflow//tensorflow/compiler/jit:xla_cpu_jit",
        "@org_tensorflow//tensorflow/core:lib",
        "@org_tensorflow//tensorflow/core/platform/cloud:gcs_file_system",
        "@org_tensorflow//tensorflow/core/platform/hadoop:hadoop_file_system",
        "@org_tensorflow//tensorflow/core/platform/s3:s3_file_system",
        "@tf_serving//tensorflow_serving/model_servers:server_lib",
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

container_layer(
    name = "dash",
    debs = select({
        ":linux_arm": [debian_buster_armhf["dash"]],
        ":linux_arm64": [debian_buster_arm64["dash"]],
        ":linux_amd64": [debian_buster_amd64["dash"]],
    }),
)

container_layer(
    name = "libomp_runtime",
    directory = select({
        ":linux_arm64": "/usr/lib/aarch64-linux-gnu",
        ":linux_amd64": "/usr/lib/x86_64-linux-gnu",
    }),
    files = select({
        ":linux_arm64": ["@local_crosslib_arm64//:libomp"],
        ":linux_amd64": ["@local_crosslib_amd64//:libomp"],
    })
)

[container_image(
    name = "custom_image" + suffix,
    architecture = select({
        ":linux_arm": "arm",
        ":linux_arm64": "arm64",
        ":linux_amd64": "amd64",
    }),
    base = select({
        ":linux_arm": "@discolix_cc_linux_arm" + suffix + "//image",
        ":linux_arm64": "@discolix_cc_linux_arm64" + suffix + "//image",
        ":linux_amd64": "@discolix_cc_linux_amd64" + suffix + "//image",
    }),
    directory = "/usr/bin/",
    entrypoint = ["tf_serving_entrypoint.sh"],
    env = {
        "MODEL_NAME": "model",
        "MODEL_BASE_PATH": "/models",
    },
    files = [
        ":tensorflow_model_server",
        ":tf_serving_entrypoint.sh",
    ],
    layers = ["dash"] + select({
        ":linux_arm64": ["libomp_runtime"],
        ":linux_amd64": ["libomp_runtime"],
        "//conditions:default": [],
    }),
    ports = [
        "8500",
        "8501",
    ],
    stamp = True,
) for suffix in ("", "_debug")]

container_bundle(
    name = "project_image",
    images = {"{PROJECT_REGISTRY_PREFIX}:{BUILD_EMBED_LABEL}-$(tag_suffix)": ":custom_image"},
)

container_bundle(
    name = "project_image_debug",
    images = {"{PROJECT_REGISTRY_PREFIX}:{BUILD_EMBED_LABEL}-debug-$(tag_suffix)": ":custom_image_debug"},
)

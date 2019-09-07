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
    "@io_bazel_rules_docker//container:container.bzl",
    "container_bundle",
    "container_image",
)

config_setting(
    name = "is_linux_amd64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
)

config_setting(
    name = "is_linux_arm64",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
)

config_setting(
    name = "is_linux_arm",
    constraint_values = [
        "@platforms//os:linux",
        "@platforms//cpu:arm",
    ],
)

cc_library(
    name = "main_lib",
    srcs = [
        "main.cc",
    ],
    linkstamp = "stamp.cc",
    deps = [
        "@org_tensorflow//tensorflow/c:c_api",
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

container_image(
    name = "image",
    base = select({
        ":is_linux_amd64": "@discolix_cc_linux_amd64//image",
        ":is_linux_arm64": "@discolix_cc_linux_arm64//image",
        ":is_linux_arm": "@discolix_cc_linux_arm//image",
    }),
    cmd = [
        "--model_name=model",
        "--model_base_path=/models/model",
    ],
    directory = "/usr/bin/",
    entrypoint = [
        "tensorflow_model_server",
        "--port=8500",
        "--rest_api_port=8501",
    ],
    files = [":tensorflow_model_server"],
    ports = [
        "8500",
        "8501",
    ],
    stamp = True,
)

container_image(
    name = "image_debug",
    base = select({
        ":is_linux_amd64": "@discolix_cc_debug_linux_amd64//image",
        ":is_linux_arm64": "@discolix_cc_debug_linux_arm64//image",
        ":is_linux_arm": "@discolix_cc_debug_linux_arm//image",
    }),
    cmd = [
        "--model_name=model",
        "--model_base_path=/models/model",
    ],
    directory = "/usr/bin/",
    entrypoint = [
        "tensorflow_model_server",
        "--port=8500",
        "--rest_api_port=8501",
    ],
    files = [":tensorflow_model_server"],
    ports = [
        "8500",
        "8501",
    ],
    stamp = True,
)

# prepare project images for publishing

project_image_tags = [
    "linux_amd64_avx_sse4.2",
    "linux_arm64_armv8-a",
    "linux_arm64_armv8.2-a",
    "linux_arm_armv7-a_neon_vfpv4",
    "linux_arm_armv7-a_neon_vfpv3",
]

# these targets only serve to give a project ":image" a fully qualified docker
# image name and should always be accompanied by their respective config group like:
# bazel run //tensorflow_model_server:linux_arm64_armv8-a --config=linux_arm64_armv8-a
[container_bundle(
    name = tag,
    images = {"{PROJECT_REGISTRY_PREFIX}:{UPSTREAM_TFS_VERSION}-" + tag: ":image"},
) for tag in project_image_tags]

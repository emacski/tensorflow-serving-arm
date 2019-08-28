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

package(default_visibility = ["//visibility:public"])

load(":cc_toolchain_config.bzl", "cc_toolchain_config")

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "aarch64|compiler": ":cc-compiler-aarch64",
        "armeabi|compiler": ":cc-compiler-armeabi",
        "aarch64": ":cc-compiler-aarch64",
        "armeabi": ":cc-compiler-armeabi",
    },
)

filegroup(
    name = "empty",
    srcs = [],
)

# aarch64 toolchain

cc_toolchain_config(
    name = "local_aarch64",
    compiler = "compiler",
    cpu = "aarch64",
)

cc_toolchain(
    name = "cc-compiler-aarch64",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":local_aarch64",
)

toolchain(
    name = "cc-toolchain-aarch64",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:aarch64",
    ],
    toolchain = ":cc-compiler-aarch64",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

# armeabi toolchain

cc_toolchain_config(
    name = "local_armeabi",
    compiler = "compiler",
    cpu = "armeabi",
)

cc_toolchain(
    name = "cc-compiler-armeabi",
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":local_armeabi",
)

toolchain(
    name = "cc-toolchain-armeabi",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:arm",
    ],
    toolchain = ":cc-compiler-armeabi",
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
)

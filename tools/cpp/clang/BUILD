# Copyright 2020 Erik Maciejewski
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

load("@rules_cc//cc:defs.bzl", "cc_toolchain_suite")
load("@bazel_skylib//rules:common_settings.bzl", "string_flag")
load(":cc_toolchain.bzl", "cc_cross_toolchain", "cc_current_toolchain")

package(default_visibility = ["//visibility:public"])

supported_cpus = ["x86_64", "arm", "aarch64"]

# build setting flag for statically linking against llvm's "libc++" or
# dynamically linking against gnu's "libstdc++"
string_flag(
    name = "use_libcpp",
    values = [ "libc++", "libstdc++"],
    build_setting_default = "libc++",
)

# cross-compile toolchains
[cc_cross_toolchain(
    name = "cc-compiler-k8-to-" + bzl_cpu,
    clang_version = "10.0.0",
    target_cpu = cpu,
    target_libcpp = ":use_libcpp",
) for cpu, bzl_cpu in zip(supported_cpus, ["k8", "arm", "aarch64"])]

# new-style constrained toolchain targets
[toolchain(
    name = "cc-toolchain-x86_64-to-" + cpu,
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:" + cpu
    ],
    toolchain = "cc-compiler-k8-to-" + bzl_cpu,
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
) for cpu, bzl_cpu in zip(supported_cpus, ["k8", "arm", "aarch64"])]

# toolchain target to provide make variables for genrules for cross-compilation
# with values from the current cc cross toolchain
cc_current_toolchain(name = "current_cc_toolchain")

# legacy toolchain resolution support
cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|clang": "cc-compiler-k8-to-k8",
        "arm|clang": "cc-compiler-k8-to-arm",
        "aarch64|clang": "cc-compiler-k8-to-aarch64",
        "k8": "cc-compiler-k8-to-k8",
        "arm": "cc-compiler-k8-to-arm",
        "aarch64": "cc-compiler-k8-to-aarch64",
    },
)

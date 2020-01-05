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

package(default_visibility = ["//visibility:public"])

load(":cc_toolchain_config.bzl",  "cc_toolchain_config")

cc_toolchain_suite(
    name = "toolchain",
    toolchains = {
        "k8|clang": "cc-clang-amd64",
        "arm|clang": ":cc-clang-arm",
        "aarch64|clang": ":cc-clang-arm64",
        "k8": "cc-clang-amd64",
        "arm": ":cc-clang-arm",
        "aarch64": ":cc-clang-arm64",
    },
)

filegroup(
    name = "empty",
    srcs = [],
)

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

cc_toolchain_config(
    name = "local-arm",
    target = "arm-linux-gnueabihf",
)

cc_toolchain_config(
    name = "local-arm-gnu",
    target = "arm-linux-gnueabihf",
    stdlib = "gnu",
)

cc_toolchain_config(
    name = "local-arm64",
    target = "aarch64-linux-gnu",
)

cc_toolchain_config(
    name = "local-arm64-gnu",
    target = "aarch64-linux-gnu",
    stdlib = "gnu",
)

cc_toolchain_config(
    name = "local-amd64",
    target = "x86_64-unknown-linux-gnu",
)

cc_toolchain_config(
    name = "local-amd64-gnu",
    target = "x86_64-unknown-linux-gnu",
    stdlib = "gnu",
)

[cc_toolchain(
    name = "cc-clang-arm" + s,
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":local-arm" + s,
) for s in ("", "-gnu")]

[cc_toolchain(
    name = "cc-clang-arm64" + s,
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":local-arm64" + s,
) for s in ("", "-gnu")]

[cc_toolchain(
    name = "cc-clang-amd64" + s,
    all_files = ":empty",
    compiler_files = ":empty",
    dwp_files = ":empty",
    linker_files = ":empty",
    objcopy_files = ":empty",
    strip_files = ":empty",
    supports_param_files = 1,
    toolchain_config = ":local-amd64" + s,
) for s in ("", "-gnu")]

[toolchain(
    name = "cc-toolchain-clang" + s,
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    target_compatible_with = [
        "@platforms//os:linux",
    ],
    toolchain = select({
        ":linux_arm": ":cc-clang-arm" + s,
        ":linux_arm64": ":cc-clang-arm64" + s,
        ":linux_amd64": ":cc-clang-amd64" + s,
    }),
    toolchain_type = "@bazel_tools//tools/cpp:toolchain_type",
) for s in ("", "-gnu")]

load(":cc_toolchain_make_variables.bzl", "cc_make_variable_supplier")

cc_make_variable_supplier(name = "cc_make_vars")

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

load("@bazel_tools//tools/build_defs/cc:action_names.bzl", "ACTION_NAMES")
load("@bazel_tools//tools/cpp:cc_flags_supplier_lib.bzl", "build_cc_flags")
load("@bazel_tools//tools/cpp:toolchain_utils.bzl", "find_cpp_toolchain")

cross_flag_prefixes = ["--target", "--sysroot", "-march", "-mfpu",
                       "-mcpu", "-mavx", "-msse", "-fuse-ld"]

def _cross_build_cc_flags(ctx, cc_toolchain, action_name):
    """Returns a string of cross-build compiler flags."""
    feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.features,
        unsupported_features = ctx.disabled_features,
    )

    flags_from_features = cc_common.get_memory_inefficient_command_line(
        feature_configuration = feature_configuration,
        action_name = action_name,
        variables = cc_common.create_compile_variables(
            feature_configuration = feature_configuration,
            cc_toolchain = cc_toolchain,
        )
    )
    # add --copts from commandline
    flags_to_filter = flags_from_features + ctx.fragments.cpp.copts

    return " ".join([
        flag for flag in flags_to_filter
        if any([flag.startswith(prefix) for prefix in cross_flag_prefixes])
    ])

def _impl(ctx):
    """Provide just enough information so a genrule can cross build"""
    cc_toolchain = find_cpp_toolchain(ctx)
    cc_flags = _cross_build_cc_flags(ctx, cc_toolchain, ACTION_NAMES.cpp_compile)

    return [platform_common.TemplateVariableInfo({
        "CC": cc_toolchain.compiler_executable,
        "CC_FLAGS": cc_flags,
        "TARGET_GNU_SYSTEM_NAME": cc_toolchain.target_gnu_system_name,
        "SYSROOT": cc_toolchain.sysroot,
    })]

cc_make_variable_supplier = rule(
    implementation = _impl,
    attrs = {
        "_cc_toolchain": attr.label(default = Label("@bazel_tools//tools/cpp:current_cc_toolchain")),
    },
    toolchains = ["@bazel_tools//tools/cpp:toolchain_type"],
    fragments = ["cpp"],
)

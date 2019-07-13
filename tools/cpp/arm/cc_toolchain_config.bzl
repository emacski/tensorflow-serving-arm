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
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "action_config",
    "feature",
    "feature_set",
    "flag_group",
    "flag_set",
    "tool",
    "tool_path",
    "with_feature_set",
)

load(
  "@bazel_tools//tools/cpp:cc_toolchain_config.bzl",
  "all_link_actions",
  "all_compile_actions",
  "all_cpp_compile_actions",
)

def _impl(ctx):
    if (ctx.attr.cpu == "aarch64"):
        toolchain_identifier = "aarch64-linux-gnu"
    elif (ctx.attr.cpu == "armeabi"):
        toolchain_identifier = "arm-linux-gnueabihf"
    else:
        fail("Unreachable")

    compiler = "compiler"

    if (ctx.attr.cpu == "aarch64"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "/usr/bin/aarch64-linux-gnu-objcopy")],
        )
    elif (ctx.attr.cpu == "armeabi"):
        objcopy_embed_data_action = action_config(
            action_name = "objcopy_embed_data",
            enabled = True,
            tools = [tool(path = "/usr/bin/arm-linux-gnueabihf-objcopy")],
        )

    if (ctx.attr.cpu == "aarch64"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-lm",
                                "-fuse-ld=gold",
                                "-Wl,-no-as-needed",
                                "-Wl,-z,relro,-z,now",
                                "-no-canonical-prefixes",
                                "-pass-exit-codes",
                                "-Wl,--build-id=md5",
                                "-Wl,--hash-style=gnu"
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "armeabi"):
        default_link_flags_feature = feature(
            name = "default_link_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-lstdc++",
                                "-Wl,-z,relro,-z,now",
                                "-no-canonical-prefixes",
                                "-pass-exit-codes",
                                "-Wl,--build-id=md5",
                                "-Wl,--hash-style=gnu"
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_link_actions,
                    flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
            ],
        )

    if (ctx.attr.cpu == "aarch64"):
        unfiltered_compile_flags_feature = feature(
            name = "unfiltered_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-no-canonical-prefixes",
                                "-fno-canonical-system-headers",
                                "-Wno-builtin-macro-redefined",
                                "-D__DATE__=\"redacted\"",
                                "-D__TIMESTAMP__=\"redacted\"",
                                "-D__TIME__=\"redacted\"",
                            ],
                        ),
                    ],
                ),
            ],
        )
    elif (ctx.attr.cpu == "armeabi"):
        unfiltered_compile_flags_feature = feature(
            name = "unfiltered_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-no-canonical-prefixes",
                                "-fno-canonical-system-headers",
                                "-Wno-builtin-macro-redefined",
                                "-D__DATE__=\"redacted\"",
                                "-D__TIMESTAMP__=\"redacted\"",
                                "-D__TIME__=\"redacted\"",
                            ],
                        ),
                    ],
                ),
            ],
        )

    if (ctx.attr.cpu == "aarch64"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-U_FORTIFY_SOURCE",
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-Wall",
                                "-Wunused-but-set-parameter",
                                "-Wno-free-nonheap-object",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O2",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = all_cpp_compile_actions,
                    flag_groups = [flag_group(flags = ["-std=c++11"])],
                ),
            ],
        )
    elif (ctx.attr.cpu == "armeabi"):
        default_compile_flags_feature = feature(
            name = "default_compile_flags",
            enabled = True,
            flag_sets = [
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-U_FORTIFY_SOURCE",
                                "-D_FORTIFY_SOURCE=1",
                                "-fstack-protector",
                                "-Wall",
                                "-Wunused-but-set-parameter",
                                "-Wno-free-nonheap-object",
                                "-fno-omit-frame-pointer",
                            ],
                        ),
                    ],
                ),
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [flag_group(flags = ["-g"])],
                    with_features = [with_feature_set(features = ["dbg"])],
                ),
                flag_set(
                    actions = all_compile_actions,
                    flag_groups = [
                        flag_group(
                            flags = [
                                "-g0",
                                "-O2",
                                "-DNDEBUG",
                                "-ffunction-sections",
                                "-fdata-sections",
                            ],
                        ),
                    ],
                    with_features = [with_feature_set(features = ["opt"])],
                ),
                flag_set(
                    actions = all_cpp_compile_actions,
                    flag_groups = [flag_group(flags = ["-std=c++11"])],
                ),
            ],
        )

    objcopy_embed_flags_feature = feature(
        name = "objcopy_embed_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ["objcopy_embed_data"],
                flag_groups = [flag_group(flags = ["-I", "binary"])],
            ),
        ],
    )

    sysroot_feature = feature(
        name = "sysroot",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions + all_link_actions,
                flag_groups = [
                    flag_group(
                        flags = ["--sysroot=%{sysroot}"],
                        expand_if_available = "sysroot",
                    ),
                ],
            ),
        ],
    )

    user_compile_flags_feature = feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = all_compile_actions,
                flag_groups = [
                    flag_group(
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                        expand_if_available = "user_compile_flags",
                    ),
                ],
            ),
        ],
    )

    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)
    supports_pic_feature = feature(name = "supports_pic", enabled = True)
    supports_start_end_lib_feature = feature(name = "supports_start_end_lib", enabled = True)

    opt_feature = feature(name = "opt")
    dbg_feature = feature(name = "dbg")

    if (ctx.attr.cpu == "aarch64"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            supports_start_end_lib_feature,
            objcopy_embed_flags_feature,
            opt_feature,
            dbg_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
        ]
    elif (ctx.attr.cpu == "armeabi"):
        features = [
            default_compile_flags_feature,
            default_link_flags_feature,
            supports_dynamic_linker_feature,
            supports_pic_feature,
            objcopy_embed_flags_feature,
            opt_feature,
            dbg_feature,
            user_compile_flags_feature,
            sysroot_feature,
            unfiltered_compile_flags_feature,
        ]

    if (ctx.attr.cpu == "aarch64"):
        tool_paths = [
            tool_path(name="ar", path="/usr/bin/aarch64-linux-gnu-ar"),
            tool_path(name="ld", path="/usr/bin/aarch64-linux-gnu-ld"),
            tool_path(name="cpp", path="/usr/bin/aarch64-linux-gnu-cpp"),
            tool_path(name="dwp", path="/usr/bin/aarch64-linux-gnu-dwp"),
            tool_path(name="gcc", path="/usr/bin/aarch64-linux-gnu-gcc"),
            tool_path(name="gcov", path="/usr/bin/aarch64-linux-gnu-gcov"),
            tool_path(name="nm", path="/usr/bin/aarch64-linux-gnu-nm"),
            tool_path(name="objcopy", path="/usr/bin/aarch64-linux-gnu-objcopy"),
            tool_path(name="objdump", path="/usr/bin/aarch64-linux-gnu-objdump"),
            tool_path(name="strip", path="/usr/bin/aarch64-linux-gnu-strip"),
        ]
    elif (ctx.attr.cpu == "armeabi"):
        tool_paths = [
            tool_path(name="ar", path="/usr/bin/arm-linux-gnueabihf-ar"),
            tool_path(name="ld", path="/usr/bin/arm-linux-gnueabihf-ld"),
            tool_path(name="cpp", path="/usr/bin/arm-linux-gnueabihf-cpp"),
            tool_path(name="dwp", path="/usr/bin/arm-linux-gnueabihf-dwp"),
            tool_path(name="gcc", path="/usr/bin/arm-linux-gnueabihf-gcc"),
            tool_path(name="gcov", path="/usr/bin/arm-linux-gnueabihf-gcov"),
            tool_path(name="nm", path="/usr/bin/arm-linux-gnueabihf-nm"),
            tool_path(name="objcopy", path="/usr/bin/arm-linux-gnueabihf-objcopy"),
            tool_path(name="objdump", path="/usr/bin/arm-linux-gnueabihf-objdump"),
            tool_path(name="strip", path="/usr/bin/arm-linux-gnueabihf-strip"),
        ]

    if (ctx.attr.cpu == "aarch64"):
        cxx_builtin_include_directories = [
            "/usr/aarch64-linux-gnu/include/",
            "/usr/lib/gcc-cross/aarch64-linux-gnu/",
        ]
    elif (ctx.attr.cpu == "armeabi"):
        cxx_builtin_include_directories = [
            "/usr/arm-linux-gnueabihf/include/",
            "/usr/lib/gcc-cross/arm-linux-gnueabihf/",
        ]

    return cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        action_configs = [objcopy_embed_data_action],
        abi_version = ctx.attr.cpu,
        abi_libc_version = ctx.attr.cpu,
        compiler = compiler,
        cxx_builtin_include_directories = cxx_builtin_include_directories,
        host_system_name = ctx.attr.cpu,
        target_cpu = ctx.attr.cpu,
        target_libc = ctx.attr.cpu,
        target_system_name = ctx.attr.cpu,
        tool_paths = tool_paths,
        toolchain_identifier = toolchain_identifier,
    )

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "cpu": attr.string(mandatory = True),
        "compiler": attr.string(),
    },
    provides = [CcToolchainConfigInfo],
)

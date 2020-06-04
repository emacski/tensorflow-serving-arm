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

"""Clang cross-compile toolchain config rule."""
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config_lib.bzl",
    "feature",
    "flag_group",
    "flag_set",
    "tool_path",
    "with_feature_set",
)
load(
    "@bazel_tools//tools/cpp:cc_toolchain_config.bzl",
    ALL_COMPILE_ACTIONS = "all_compile_actions",
    ALL_CPP_COMPILE_ACTIONS = "all_cpp_compile_actions",
    ALL_LINK_ACTIONS = "all_link_actions",
)
load("@bazel_skylib//rules:common_settings.bzl", "BuildSettingInfo")

def _impl(ctx):
    toolchain_identifier = "clang-linux-cross"
    compiler_version = ctx.attr.clang_version
    compiler = "clang-" + compiler_version
    abi_version = "clang"
    abi_libc_version = "glibc_unknown"
    target_cpu = ctx.attr.target_cpu
    target_libc = "glibc_unknown"
    target_libcpp = ctx.attr.target_libcpp[BuildSettingInfo].value

    if (target_cpu == "aarch64" or target_cpu == "arm"):
        gnu_suffix = "-linux-gnueabihf" if target_cpu == "arm" else "-linux-gnu"
        target_platform_gnu = target_cpu + gnu_suffix
        sysroot = "/usr/" + target_platform_gnu
        include_path_prefix = sysroot
    elif (target_cpu == "x86_64"):
        target_platform_gnu = target_cpu + "-unknown-linux-gnu"
        sysroot = "/"
        include_path_prefix = "/usr"
    else:
        fail("Unreachable")

    if (target_libcpp == "libstdc++"):
        if (target_cpu == "aarch64" or target_cpu == "arm"):
            cross_system_include_dirs = [
                include_path_prefix + "/include/c++/8",
                include_path_prefix + "/include/c++/8/" + target_platform_gnu,
                include_path_prefix + "/lib/clang/" + compiler_version + "/include",
            ]
        else:
            cross_system_include_dirs = [
                include_path_prefix + "/include/c++/8",
                include_path_prefix + "/include/x86_64-linux-gnu/c++/8",
                include_path_prefix + "/lib/clang/" + compiler_version + "/include",
                include_path_prefix + "/include/x86_64-linux-gnu",
            ]
    else:
        if (target_cpu == "aarch64" or target_cpu == "arm"):
            cross_system_include_dirs = [
                include_path_prefix + "/include/c++/v1",
                include_path_prefix + "/lib/clang/" + compiler_version + "/include",
            ]
        else:
            cross_system_include_dirs = [
                include_path_prefix + "/include/c++/v1",
                include_path_prefix + "/lib/clang/" + compiler_version + "/include",
                include_path_prefix + "/include/x86_64-linux-gnu",
            ]

    cross_system_include_dirs += [
        include_path_prefix + "/include/",
        include_path_prefix + "/include/linux",
        include_path_prefix + "/include/asm",
        include_path_prefix + "/include/asm-generic",
    ]

    if (target_cpu == "aarch64" or target_cpu == "arm"):
        cross_system_lib_dirs = [
            "/usr/" + target_platform_gnu + "/lib",
        ]
    else:
        cross_system_lib_dirs = [
            "/usr/lib/x86_64-linux-gnu/",
        ]

    if (target_libcpp == "libstdc++"):
        if (target_cpu == "aarch64" or target_cpu == "arm"):
            cross_system_lib_dirs.append("/usr/lib/gcc-cross/" + target_platform_gnu + "/8")
        else:
            cross_system_lib_dirs.append("/usr/lib/gcc/x86_64-linux-gnu/8")

    opt_feature = feature(name = "opt")
    dbg_feature = feature(name = "dbg")
    fastbuild_feature = feature(name = "fastbuild")
    random_seed_feature = feature(name = "random_seed", enabled = True)
    supports_pic_feature = feature(name = "supports_pic", enabled = True)
    supports_dynamic_linker_feature = feature(name = "supports_dynamic_linker", enabled = True)

    unfiltered_compile_flags_feature = feature(
        name = "unfiltered_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-no-canonical-prefixes",
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

    # explicit arch specific system includes
    system_include_flags = []
    for d in cross_system_include_dirs:
        system_include_flags += ["-idirafter", d]

    default_compile_flags_feature = feature(
        name = "default_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [
                    flag_group(
                        flags = [
                            "--target=" + target_platform_gnu,
                            "-nostdinc",
                            "-U_FORTIFY_SOURCE",
                            "-fstack-protector",
                            "-fno-omit-frame-pointer",
                            "-fcolor-diagnostics",
                            "-Wall",
                            "-Wthread-safety",
                            "-Wself-assign",
                        ] + system_include_flags,
                    ),
                ],
            ),
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [flag_group(flags = ["-g", "-fstandalone-debug"])],
                with_features = [with_feature_set(features = ["dbg"])],
            ),
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [
                    flag_group(
                        flags = [
                            "-g0",
                            "-O2",
                            "-D_FORTIFY_SOURCE=1",
                            "-DNDEBUG",
                            "-ffunction-sections",
                            "-fdata-sections",
                        ],
                    ),
                ],
                with_features = [with_feature_set(features = ["opt"])],
            ),
            flag_set(
                actions = ALL_CPP_COMPILE_ACTIONS,
                flag_groups = [flag_group(flags = ["-std=c++17", "-nostdinc++"])],
            ),
        ],
    )

    if (target_libcpp == "libstdc++"):
        additional_link_flags = ["-lstdc++"]
    else:
        additional_link_flags = [
            "-l:libc++.a",
            "-l:libc++abi.a",
            "-l:libunwind.a",
            "-lpthread",
            "-ldl",
            "-rtlib=compiler-rt",
        ]

    default_link_flags_feature = feature(
        name = "default_link_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_LINK_ACTIONS,
                flag_groups = [
                    flag_group(
                        flags = additional_link_flags + [
                            "--target=" + target_platform_gnu,
                            "-lm",
                            "-no-canonical-prefixes",
                            "-fuse-ld=lld",
                            "-Wl,--build-id=md5",
                            "-Wl,--hash-style=gnu",
                            "-Wl,-z,relro,-z,now",
                        ] + ["-L" + d for d in cross_system_lib_dirs],
                    ),
                ],
            ),
            flag_set(
                actions = ALL_LINK_ACTIONS,
                flag_groups = [flag_group(flags = ["-Wl,--gc-sections"])],
                with_features = [with_feature_set(features = ["opt"])],
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

    user_compile_flags_feature = feature(
        name = "user_compile_flags",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [
                    flag_group(
                        expand_if_available = "user_compile_flags",
                        flags = ["%{user_compile_flags}"],
                        iterate_over = "user_compile_flags",
                    ),
                ],
            ),
        ],
    )

    sysroot_feature = feature(
        name = "sysroot",
        enabled = True,
        flag_sets = [
            flag_set(
                actions = ALL_COMPILE_ACTIONS + ALL_LINK_ACTIONS,
                flag_groups = [
                    flag_group(
                        expand_if_available = "sysroot",
                        flags = ["--sysroot=%{sysroot}"],
                    ),
                ],
            ),
        ],
    )

    coverage_feature = feature(
        name = "coverage",
        flag_sets = [
            flag_set(
                actions = ALL_COMPILE_ACTIONS,
                flag_groups = [
                    flag_group(
                        flags = ["-fprofile-instr-generate", "-fcoverage-mapping"],
                    ),
                ],
            ),
            flag_set(
                actions = ALL_LINK_ACTIONS,
                flag_groups = [flag_group(flags = ["-fprofile-instr-generate"])],
            ),
        ],
        provides = ["profile"],
    )

    features = [
        opt_feature,
        fastbuild_feature,
        dbg_feature,
        random_seed_feature,
        supports_pic_feature,
        supports_dynamic_linker_feature,
        unfiltered_compile_flags_feature,
        default_link_flags_feature,
        default_compile_flags_feature,
        objcopy_embed_flags_feature,
        user_compile_flags_feature,
        sysroot_feature,
        coverage_feature,
    ]

    tool_paths = [
        tool_path(name = "ld", path = "/usr/bin/ld.lld"),
        tool_path(name = "cpp", path = "/usr/bin/clang-cpp"),
        tool_path(name = "dwp", path = "/usr/bin/llvm-dwp"),
        tool_path(name = "gcov", path = "/usr/bin/llvm-profdata"),
        tool_path(name = "nm", path = "/usr/bin/llvm-nm"),
        tool_path(name = "objcopy", path = "/usr/bin/llvm-objcopy"),
        tool_path(name = "objdump", path = "/usr/bin/llvm-objdump"),
        tool_path(name = "strip", path = "/usr/bin/strip"),
        tool_path(name = "gcc", path = "/usr/bin/clang"),
        tool_path(name = "ar", path = "/usr/bin/llvm-ar"),
    ]

    return [cc_common.create_cc_toolchain_config_info(
        ctx = ctx,
        features = features,
        abi_version = abi_version,
        abi_libc_version = abi_libc_version,
        builtin_sysroot = sysroot,
        compiler = compiler,
        cxx_builtin_include_directories = cross_system_include_dirs,
        host_system_name = "x86_64-unknown-linux-gnu",
        target_cpu = target_cpu,
        target_libc = target_libc,
        target_system_name = target_platform_gnu,
        tool_paths = tool_paths,
        toolchain_identifier = toolchain_identifier,
    )]

cc_toolchain_config = rule(
    implementation = _impl,
    attrs = {
        "clang_version": attr.string(mandatory = True),
        "target_cpu": attr.string(mandatory = True, values = ["arm", "aarch64", "x86_64"]),
        "target_libcpp": attr.label(),
    },
    provides = [CcToolchainConfigInfo],
)

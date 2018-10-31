package(default_visibility = ["//visibility:public"])

cc_toolchain_suite(
  name = 'toolchain',
  toolchains = {
  'armeabi|compiler':':gcc-linux-arm',
  'aarch64|compiler':':gcc-linux-aarch64',
  },
)

filegroup(
    name = "empty",
    srcs = [],
)

cc_toolchain(
  name = 'gcc-linux-arm',
  all_files = ':empty',
  compiler_files = ':empty',
  cpu = 'armeabi',
  dwp_files = ':empty',
  dynamic_runtime_libs = [':empty'],
  linker_files = ':empty',
  objcopy_files = 'empty',
  static_runtime_libs = [':empty'],
  strip_files = 'empty',
  supports_param_files = 1,
)

cc_toolchain(
  name = 'gcc-linux-aarch64',
  all_files = ':empty',
  compiler_files = ':empty',
  cpu = 'aarch64',
  dwp_files = ':empty',
  dynamic_runtime_libs = [':empty'],
  linker_files = ':empty',
  objcopy_files = 'empty',
  static_runtime_libs = [':empty'],
  strip_files = 'empty',
  supports_param_files = 1,
)

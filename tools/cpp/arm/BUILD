package(default_visibility = ["//visibility:public"])
filegroup(name = "empty", srcs = [])

cc_toolchain_suite(
  name = "toolchain",
  toolchains = {
    "armeabi": ":gcc-linux-arm",
    "aarch64": ":gcc-linux-aarch64",
  },
)

cc_toolchain(
  name = 'gcc-linux-arm',
  toolchain_identifier = 'arm-linux-gnueabihf',
  all_files = ':empty',
  compiler_files = ':empty',
  cpu = 'armeabi',
  dwp_files = ':empty',
  linker_files = ':empty',
  objcopy_files = 'empty',
  strip_files = 'empty',
  supports_param_files = 1,
)

cc_toolchain(
  name = 'gcc-linux-aarch64',
  toolchain_identifier = 'aarch64-linux-gnu',
  all_files = ':empty',
  compiler_files = ':empty',
  cpu = 'aarch64',
  dwp_files = ':empty',
  linker_files = ':empty',
  objcopy_files = 'empty',
  strip_files = 'empty',
  supports_param_files = 1,
)

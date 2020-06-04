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

"""this is only to support the tf hack in WORKSPACE"""

def _impl(repository_ctx):
    repository_ctx.symlink(Label("//tools/cpp/clang:BUILD"), "BUILD")
    repository_ctx.symlink(Label("//tools/cpp/clang:cc_toolchain.bzl"), "cc_toolchain.bzl")
    repository_ctx.symlink(Label("//tools/cpp/clang:cc_toolchain_config.bzl"), "cc_toolchain_config.bzl")

cc_repo_config = repository_rule(
    implementation = _impl,
    attrs = {},
)

TensorFlow Serving on ARM
=========================

TensorFlow Serving cross-compile project targeting linux on common arm cores from
a linux amd64 / x86_64 build host.

## Contents
* [Overview](#overview)
* [Docker Images](#docker-images)
* [Build From Source](#build-from-source)
* [Legacy Builds](#legacy-builds)
* [Disclosures](#disclosures)
* [Disclaimer](#disclaimer)

## Overview

The basis of this project is to provide an alternative build strategy for
[tensorflow/serving](https://github.com/tensorflow/serving)
with the intention of making it relatively easy to cross-build CPU optimized model server
docker images targeting common linux arm platforms. Additonally, a set of docker
image build targets is maintained and built for some of the popular linux arm platforms and hosted on
Docker Hub.

**Upstream Project:** [tensorflow/serving](https://github.com/tensorflow/serving)

## Docker Images

**Hosted on Docker Hub:** [emacski/tensorflow-serving](https://hub.docker.com/r/emacski/tensorflow-serving)

**Usage Documentation:** [TensorFlow Serving with Docker](https://www.tensorflow.org/tfx/serving/docker)

**Note:** The project images are desinged to be functionally equivalent to their upstream counter part.

### Quick Start

On many consumer / developer 64-bit and 32-bit arm platforms you can simply:
```sh
docker pull emacski/tensorflow-serving:latest
# or
docker pull emacski/tensorflow-serving:2.2.0
```

Refer to [TensorFlow Serving with Docker](https://www.tensorflow.org/tfx/serving/docker)
for configuration and setting up a model for serving.

### Images

#### `emacski/tensorflow-serving:[Tag]`

| **Tag** | **ARM Core Compatability** |
|---------|----------------------------|
| <nobr>`[Version]-linux_amd64_avx_sse4.2`</nobr>| N/A |
| <nobr>`[Version]-linux_arm64_armv8-a`</nobr> | Cortex-A35 / A53 / A57 / A72 / A73 |
| <nobr>`[Version]-linux_arm64_armv8.2-a`</nobr> | Cortex-A55 / A75 / A76 |
| <nobr>`[Version]-linux_arm_armv7-a_neon_vfpv3`</nobr> | Cortex-A8 |
| <nobr>`[Version]-linux_arm_armv7-a_neon_vfpv4`</nobr> | Cortex-A7 / A12 / A15 / A17 |

Example
```bash
# on beaglebone black
docker pull emacski/tensorflow-serving:2.2.0-linux_arm_armv7-a_neon_vfpv3
```

### Aliases

#### `emacski/tensorflow-serving:[Alias]`

| **Alias** | **Tag** | **Notes** |
|-----------|---------|-----------|
| <nobr>`[Version]-linux_amd64`</nobr> | <nobr>`[Version]-linux_amd64_avx_sse4.2`</nobr> | default `linux_amd64` image |
| <nobr>`[Version]-linux_arm64`</nobr> | <nobr>`[Version]-linux_arm64_armv8-a`</nobr> | Should work on _most_ 64-bit<br/>raspberry pi and compatible<br/>platforms |
| <nobr>`[Version]-linux_arm`</nobr> | <nobr>`[Version]-linux_arm_armv7-a_neon_vfpv4`</nobr> | Should work on _most_ 32-bit<br/>raspberry pi and compatible<br/>platforms |
| <nobr>`latest-linux_amd64`</nobr> | <nobr>`[Latest-Version]-linux_amd64`</nobr> | |
| <nobr>`latest-linux_arm64`</nobr> | <nobr>`[Latest-Version]-linux_arm64`</nobr> | |
| <nobr>`latest-linux_arm`</nobr> | <nobr>`[Latest-Version]-linux_arm`</nobr> | |

Examples
```bash
# on Raspberry PI 3 B+
docker pull emacski/tensorflow-serving:2.2.0-linux_arm64
# or
docker pull emacski/tensorflow-serving:latest-linux_arm64
```

### Manifest Lists

#### `emacski/tensorflow-serving:latest`

| **Image** | **OS** | **Arch** |
|-----------|:------:|:--------:|
| <nobr>`emacski/tensorflow-serving:latest-linux_arm`</nobr> | `linux` | `arm` |
| <nobr>`emacski/tensorflow-serving:latest-linux_arm64`</nobr> | `linux` | `arm64` |
| <nobr>`emacski/tensorflow-serving:latest-linux_amd64`</nobr> | `linux` | `amd64` |

Examples
```bash
# on Raspberry PI 3 B+
docker pull emacski/tensorflow-serving
# or
docker pull emacski/tensorflow-serving:latest
# the actual image used is emacski/tensorflow-serving:latest-linux_arm64
# itself actually being emacski/tensorflow-serving:[Latest-Version]-linux_arm64_armv8-a
```

#### `emacski/tensorflow-serving:[Version]`

| **Image** | **OS** | **Arch** |
|-----------|:------:|:--------:|
| <nobr>`emacski/tensorflow-serving:[Version]-linux_arm`</nobr> | `linux` | `arm` |
| <nobr>`emacski/tensorflow-serving:[Version]-linux_arm64`</nobr> | `linux` | `arm64` |
| <nobr>`emacski/tensorflow-serving:[Version]-linux_amd`</nobr> | `linux` | `amd64` |

Example
```sh
# on Raspberry PI 3 B+
docker pull emacski/tensorflow-serving:2.2.0
# the actual image used is emacski/tensorflow-serving:2.2.0-linux_arm64
# itself actually being emacski/tensorflow-serving:2.2.0-linux_arm64_armv8-a
```

### Debug Images

As of version `2.0.0`, debug images are also built and published to docker hub.
These images are identical to the non-debug images with the addition of busybox
utils. The utils are located at `/busybox/bin` which is also included in the
image's system `PATH`.

For any image above, add `debug` after the `[Version]` and before the platform
suffix (if one is required) in the image tag.

```sh
# multi-arch
docker pull emacski/tensorflow-serving:2.2.0-debug
# specific image
docker pull emacski/tensorflow-serving:2.2.0-debug-linux_arm64_armv8-a
# specific alias
docker pull emacski/tensorflow-serving:latest-debug-linux_arm64
```

Example Usage
```sh
# start a new container with an interactive ash (busybox) shell
docker run -ti --entrypoint /busybox/bin/sh emacski/tensorflow-serving:latest-debug-linux_arm64
# with an interactive dash (system) shell
docker run -ti --entrypoint sh emacski/tensorflow-serving:latest-debug-linux_arm64
# start an interactive ash shell in a running debug container
docker exec -ti my_running_container /busybox/bin/sh
```

[Back to Top](#contents)

## Build From Source

### Build / Development Environment

**Build Host Platform:** `linux_amd64` (`x86_64`)

**Build Host Requirements:**
* git
* docker

For each version / release, a self contained build environment `devel` image is
created and published. This image contains all necessary tools and dependencies
required for building project artifacts.

```bash
git clone git@github.com:emacski/tensorflow-serving-arm.git
cd tensorflow-serving-arm

# pull devel
docker pull emacski/tensorflow-serving:latest-devel
# or build devel
docker build -t emacski/tensorflow-serving:latest-devel -f tensorflow_model_server/tools/docker/Dockerfile .
```

All of the build examples assume that the commands are executed within the `devel`
container:
```bash
# interactive shell
docker run --rm -ti \
    -w /code -v $PWD:/code \
    -v /var/run/docker.sock:/var/run/docker.sock \
    emacski/tensorflow-serving:latest-devel /bin/bash
# or
# non-interactive
docker run --rm \
    -w /code -v $PWD:/code \
    -v /var/run/docker.sock:/var/run/docker.sock \
    emacski/tensorflow-serving:latest-devel [example_command]
```

### Config Groups

The following bazel config groups represent the build options used for each target
platform (found in `.bazelrc`). These config groups should be treated as mutually
exclusive with each other and only one should be specified in a build command as
a `--config` option.

| Name | Type | Info |
|------|------|------|
| `linux_amd64` | Base | can be used for [custom builds](#build-image-for-custom-arm-target) |
| `linux_arm64` | Base | can be used for [custom builds](#build-image-for-custom-arm-target) |
| `linux_arm` | Base | can be used for [custom builds](#build-image-for-custom-arm-target) |
| **`linux_amd64_avx_sse4.2`** | **Project** | inherits from `linux_amd64` |
| **`linux_arm64_armv8-a`** | **Project** | inherits from `linux_arm64` |
| **`linux_arm64_armv8.2-a`** | **Project** | inherits from `linux_arm64` |
| **`linux_arm_armv7-a_neon_vfpv3`** | **Project** | inherits from `linux_arm` |
| **`linux_arm_armv7-a_neon_vfpv4`** | **Project** | inherits from `linux_arm` |

### Build Project Image Target

#### `//tensorflow_model_server:project_image.tar`

Build a project maintained model server docker image targeting one of the platforms
specified by a project config group as listed above. The resulting image can be
found as a tar file in bazel's output directory.

```bash
bazel build //tensorflow_model_server:project_image.tar --config=linux_arm64_armv8-a
# or
bazel build //tensorflow_model_server:project_image.tar --config=linux_arm_armv7-a_neon_vfpv4
# each build creates a docker loadable image tar in bazel's output dir
```

### Load Project Image Target

#### `//tensorflow_model_server:project_image`

Same as above, but additionally bazel attempts to load the resulting image onto
the host, making it immediatly available to the host's docker.

**Note:** host docker must be available to the build container for final images
to be available on the host automatically.

```bash
bazel run //tensorflow_model_server:project_image --config=linux_arm64_armv8-a
# or
bazel run //tensorflow_model_server:project_image --config=linux_arm_armv7-a_neon_vfpv4
```

### Build Project Binary Target

#### `//tensorflow_model_server`

Build the model server binary targeting one of the platforms specified by a project
config group as listed above.

**Note:** It's not recommended to use these binaries as standalone executables
as they are built specifically to run in their respective containers, but they may
work on debian 10 like systems.

```bash
bazel build //tensorflow_model_server --config=linux_arm64_armv8-a
# or
bazel build //tensorflow_model_server --config=linux_arm_armv7-a_neon_vfpv4
```

### Build Image for Custom ARM Target

#### `//tensorflow_model_server:custom_image.tar`

Can be used to fine-tune builds for specific platforms. Use a "Base" type
[config group](#config-groups) and custom compile options. For `linux_arm64` and
`linux_arm` options see: https://releases.llvm.org/10.0.0/tools/clang/docs/CrossCompilation.html

```bash
# building an image tuned for Cortex-A72
bazel build //tensorflow_model_server:custom_image.tar --config=linux_arm64 --copt=-mcpu=cortex-a72
# look for custom_image.tar in bazel's output directory
```

[Back to Top](#contents)

## Legacy Builds

### Legacy GitHub Tags (prefixed with `v`)
* `v1.11.1`
* `v1.12.0`
* `v1.13.0`
* `v1.14.0`

**Note:** a tag exists for both `v1.14.0` and `1.14.0` as this was the current
upstream tensorflow/serving version when this project was refactored

### Legacy Docker Images
The following tensorflow serving versions were built using the legacy project
structure and are still available on DockerHub.
* `emacski/tensorflow-serving:[Version]-arm64v8`
* `emacski/tensorflow-serving:[Version]-arm32v7`
* `emacksi/tensorflow-serving:[Version]-arm32v7_vfpv3`

Versions: `1.11.1`, `1.12.0`, `1.13.0`, `1.14.0`

[Back to Top](#contents)

## Disclosures

This project uses llvm / clang toolchains for c++ cross-compiling. By
default, the model server is statically linked to llvm's libc++. To dynamically
link against gnu libstdc++, include the build option `--config=gnulibcpp`.

The base docker images used in this project come from another project I
maintain called [Discolix](https://github.com/discolix/discolix) (distroless for arm).

[Back to Top](#contents)

## Disclaimer

* Not an ARM expert
* Not a Bazel expert (but I know a little bit more now)
* Not a TensorFlow expert
* Personal project, so testing is minimal

Should any of those scare you, I recommend NOT using anything here.
Additionally, any help to improve things is always appreciated.

[Back to Top](#contents)

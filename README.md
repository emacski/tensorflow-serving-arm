TensorFlow Serving on ARM
=========================

TensorFlow Serving cross-compile project targeting linux on common ARM cores from a linux x86_64 host. Resulting artifacts include binaries and docker images.

**TensorFlow Serving ARM Docker Images**  
https://hub.docker.com/r/emacski/tensorflow-serving

## Current ARM Core Targets

**32-bit**  
ARMv7-A NEON + VFPv3 (Example: Cortex-A8 / BeagleBone Black)  
ARMv7-A NEON + VFPv4 (Example: Cortex-A7 / Raspberry Pi 2 B)  

**64-bit**  
ARMv8-A NEON + VFPv4 (Example: Cortex-A53 / Raspberry Pi 3 B+)  


## Disclaimer

* Not an ARM expert
* Not a Bazel expert
* Not a TensorFlow expert
* Personal project, so testing is minimal

Should any of those scare you, I recommend NOT using anything here. Additionally, any help to improve things is always appreciated.

## Overview

One of the main goals is to keep this project as concise and easy to maintain as possible. Therefore, existing tensorflow project resources are used wherever possible.

The project's directory structure is intended to mirror the upstream project where files exist only where it is necessary to make additions to or override the upstream source.

**Upstream Project**  
[tensorflow/serving](https://github.com/tensorflow/serving)

## Build

Host Build Dependencies:
* docker
* make

Build cross-compiling development image
```
make devel
# emacski/tensorflow-serving:latest-devel
```

Build individual targets (binaries and docker images)
```
# ARMv7-A NEON + VFPv3
$ make arm32v7_vfpv3

# ARMv7-A NEON + VFPv4
$ make arm32v7

# ARMv8-A NEON + VFPv4
$ make arm64v8
```

Build all artifacts (binaries and docker images)
```
make
```

yeah, yeah, yeah...make wrapping Bazel wrapping make

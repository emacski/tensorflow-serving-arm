#!/bin/sh

set -eu

curl -L http://releases.llvm.org/${INSTALL_LLVM_VERSION}/clang+llvm-${INSTALL_LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04.tar.xz \
    -o clang+llvm-${INSTALL_LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar xf clang+llvm-${INSTALL_LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04.tar.xz --strip-components=1 -C /usr
rm -f clang+llvm-${INSTALL_LLVM_VERSION}-x86_64-linux-gnu-ubuntu-18.04.tar.xz
# arm64
curl -L http://releases.llvm.org/${INSTALL_LLVM_VERSION}/clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu.tar.xz \
    -o clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu.tar.xz
tar xf clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu.tar.xz
rm -f clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu.tar.xz
mkdir -p /usr/aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/include/c++/v1 /usr/aarch64-linux-gnu/include/c++/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}/include /usr/aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/libc++.a /usr/aarch64-linux-gnu/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/libc++abi.a /usr/aarch64-linux-gnu/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/libunwind.a /usr/aarch64-linux-gnu/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/libclang_rt.builtins-aarch64.a /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtbegin-aarch64.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtend-aarch64.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
rm -rf /clang+llvm-${INSTALL_LLVM_VERSION}-aarch64-linux-gnu
# arm
curl -L http://releases.llvm.org/${INSTALL_LLVM_VERSION}/clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf.tar.xz \
    -o clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf.tar.xz
tar xf clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf.tar.xz
rm -f clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf.tar.xz
mkdir -p /usr/arm-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/include/c++/v1 /usr/arm-linux-gnueabihf/include/c++/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}/include /usr/arm-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/libc++.a /usr/arm-linux-gnueabihf/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/libc++abi.a /usr/arm-linux-gnueabihf/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/libunwind.a /usr/arm-linux-gnueabihf/lib/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/libclang_rt.builtins-armhf.a /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtbegin-armhf.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
mv /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/clang_rt.crtend-armhf.o /usr/lib/clang/${INSTALL_LLVM_VERSION}/lib/linux/
rm -rf /clang+llvm-${INSTALL_LLVM_VERSION}-armv7a-linux-gnueabihf

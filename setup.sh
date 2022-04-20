#!/bin/bash
set -e

mkdir -p .packages

if [ ! -d ".packages/toolchain-clang-arm" ]; then
  wget -q --show-progress -O .packages/toolchain-clang-arm-13.tar.gz https://github.com/ARM-software/LLVM-embedded-toolchain-for-Arm/releases/download/release-13.0.0/LLVMEmbeddedToolchainForArm-13.0.0-linux.tar.gz
  tar zxf .packages/toolchain-clang-arm-13.tar.gz -C .packages
  mv .packages/LLVMEmbeddedToolchainForArm-13.0.0 .packages/toolchain-clang-arm
fi

if [ ! -d ".packages/framework-arduino-sam" ]; then
  wget -q --show-progress -O .packages/framework-arduino-sam-clang.tar.gz https://github.com/echtzeit-dev/framework-arduino-sam/archive/refs/tags/ez-clang-0.0.5.tar.gz
  tar zxf .packages/framework-arduino-sam-clang.tar.gz -C .packages
  mv .packages/framework-arduino-sam-ez-clang-0.0.5 .packages/framework-arduino-sam
fi

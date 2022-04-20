#!/bin/bash

if [ ! -d ".packages" ]; then
  echo "Downloading dependencies.."
  ./setup.sh
fi

export ARDUINO_DIR=$(pwd)/.packages/framework-arduino-sam
export PATH=$PATH:$(pwd)/.packages/toolchain-clang-arm/bin
export AR=llvm-ar
export CC=clang
export CXX=clang++

mkdir -p due
mkdir -p qemu

make
#make SHELL='sh -x'

function dump() {
  for f in "$@"; do echo "  $f"; done
}

echo "Arduino Due"
echo "- archives:"
dump $(find due -name '*.a')
echo "- headers:"
dump $(find due -name '*.h')

echo "LM3S811 (QEMU)"
echo "- archives:"
dump $(find qemu -name '*.a')
echo "- headers:"
dump $(find qemu -name '*.h')

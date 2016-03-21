#!/bin/bash
# build-binutils-all.sh

set -e

PREFIX=/usr/local
PARALLEL_MAKE=-j4
CONFIGURATION_OPTIONS="--disable-multilib --disable-nls"

BINUTILS_VERSION=binutils-2.26

mkdir -p build-binutils-all
cd build-binutils-all
../$BINUTILS_VERSION/configure --prefix=$PREFIX --enable-targets=all --enable-64-bit-bfd --program-prefix=all- $CONFIGURATION_OPTIONS
make $PARALLEL_MAKE
make install
cd ..

rm -rf build-binutils-all

#!/bin/sh

echo ""
echo "Building build-osx-x86:"

# Go into current location:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CD=$DIR
cd $CD

cpus=$(sysctl hw.ncpu | awk '{print $2}')

# configure
CC=clang CXX="clang++ -m32" CXXFLAGS="-m32" ../configure --disable-tests --disable-shared-js \
            --enable-strip --enable-strip-install \
            --disable-root-analysis --disable-exact-rooting --enable-gcincremental --enable-optimize=-O1 \
            --enable-llvm-hacks --disable-methodjit --disable-ion --disable-yarr-jit \
            --disable-debug \
            --without-intl-api \
            --disable-threadsafe
# make
xcrun make -j$cpus

# strip
xcrun strip -S libjs_static.a

# info
xcrun lipo -info libjs_static.a

#
# done
#
echo "*** DONE ***"

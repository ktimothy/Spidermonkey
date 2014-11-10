#!/bin/sh

echo ""
echo "Building build-ane-osx-x86:"

# Go into current location:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CD=$DIR
cd $CD

cpus=$(sysctl hw.ncpu | awk '{print $2}')

# configure
PKG_CONFIG_LIBDIR=/usr/lib/pkgconfig CC="gcc -m32" CXX="g++ -m32" AR=ar \
../configure --disable-tests --disable-shared-js \
            --enable-strip --enable-strip-install \
            --disable-root-analysis --disable-exact-rooting --enable-gcincremental --enable-optimize=-O3 \
            --enable-llvm-hacks \
            --disable-debug \
            --without-intl-api \
            --disable-threadsafe
# make
xcrun make AR=ar CC="gcc -m32" CXX="g++ -m32"  -j$cpus

# strip
xcrun strip -S libjs_static.a

# info
xcrun lipo -info libjs_static.a

#
# done
#
echo "*** DONE ***"

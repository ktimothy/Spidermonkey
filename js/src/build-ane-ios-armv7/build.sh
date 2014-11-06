#!/bin/sh

## this script is supposed to be run one directory below the original configure script

echo ""
echo "Building build-ane-ios-armv7:"

# Go into current location:
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CD=$DIR
cd $CD

MIN_IOS_VERSION=4.3
IOS_SDK=7.1

LIPO="xcrun -sdk iphoneos lipo"
STRIP="xcrun -sdk iphoneos strip"

cpus=$(sysctl hw.ncpu | awk '{print $2}')

#
# create ios version (armv7)
#
../configure --with-ios-target=iPhoneOS --with-ios-version=$IOS_SDK --with-ios-min-version=$MIN_IOS_VERSION --with-ios-arch=armv7 \
            --disable-shared-js --disable-tests --disable-ion --disable-jm --disable-tm --enable-llvm-hacks --disable-methodjit --disable-monoic --disable-polyic --disable-yarr-jit \
            --enable-optimize=-O3 --with-thumb=yes --enable-strip --enable-install-strip --without-intl-api --disable-debug --disable-threadsafe
make -j$cpus
if (( $? )) ; then
    echo "error when compiling iOS version of the library"
    exit
fi

# remove debugging info
$STRIP -S libjs_static.a
$LIPO -info libjs_static.a

#
# done
#
echo "*** DONE ***"

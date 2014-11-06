#!/bin/sh

## this script is supposed to be run one directory below the original configure script
echo ""
echo "Building build-ane-ios-x86:"

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
# create i386 version (simulator)
#
../configure --with-ios-target=iPhoneSimulator --with-ios-version=$IOS_SDK --with-ios-min-version=$MIN_IOS_VERSION --with-ios-arch=i386 \
            --disable-shared-js --disable-tests --disable-ion --disable-jm --disable-tm --enable-llvm-hacks --disable-methodjit --disable-monoic --disable-polyic \
            --enable-optimize=-O3 --enable-strip --enable-install-strip \
            --disable-debug --without-intl-api --disable-threadsafe
make -j$cpus
if (( $? )) ; then
    echo "error when compiling i386 (iOS Simulator) version of the library"
    exit
fi

# remove debugging info
$STRIP -S libjs_static.a
$LIPO -info libjs_static.a

#
# done
#
echo "*** DONE ***"

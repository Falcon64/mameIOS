#!/bin/sh

##
## make-ios.sh [target] [clean]
##
## build MAME with OSD=IOS, and create a static lib not an executable.
##
## target is one of the following
##      <blank>                 build libmame-ios.a for iOS
##      ios-simulator           build libmame-ios.a for iOS Simulator
##      tvos                    build libmame-tvos.a for tvOS
##      tvos-simulator          build libmame-tvos.a for tvOS Simulator
##      mac-catalyst            build libmame-mac.a for macOS Catalyst
##      mac-catalyst-arm64      build libmame-mac-arm64.a for macOS Catalyst
##      mac-catalyst-x86_64     build libmame-mac-x86_64.a for macOS Catalyst
##

VERSION_MIN=12.4

## iOS is the default
export BUILDDIR=build-ios
export ARCHOPTS="-arch arm64 -isysroot `xcodebuild -version -sdk iphoneos Path` -miphoneos-version-min=$VERSION_MIN"
LIBMAME=libmame-ios

if [ "$1" == "ios" ]; then
    shift
fi

if [ "$1" == "ios-simulator" ]; then
    LIBMAME=libmame-ios-simulator
    export BUILDDIR=build-ios-simulator
    export ARCHOPTS="-arch `uname -m` -isysroot `xcodebuild -version -sdk iphonesimulator Path` -mios-simulator-version-min=$VERSION_MIN"
    shift
fi

## tvOS
if [ "$1" == "tvos" ] || [ "$1" == "tvOS" ]; then
    LIBMAME=libmame-tvos
    export BUILDDIR=build-tvos
    export ARCHOPTS="-arch arm64 -isysroot `xcodebuild -version -sdk appletvos Path` -mtvos-version-min=$VERSION_MIN"
    shift
fi

if [ "$1" == "tvos-simulator" ]; then
    LIBMAME=libmame-tvos-simulator
    export BUILDDIR=build-tvos-simulator
    export ARCHOPTS="-arch `uname -m` -isysroot `xcodebuild -version -sdk iphonesimulator Path` -mtvos-simulator-version-min=$VERSION_MIN"
    shift
fi

## mac catalyst
if [ "$1" == "mac-catalyst-arm64" ]; then
    VERSION_MIN=13.6
    LIBMAME=libmame-mac-arm64
    SDK=`xcodebuild -version -sdk macosx Path`
    export BUILDDIR=build-mac-arm64
    export ARCHOPTS="-arch arm64 -isysroot $SDK -iframework $SDK/System/iOSSupport/System/Library/Frameworks -miphoneos-version-min=$VERSION_MIN -target arm64-apple-ios13.6-macabi"
    shift
fi

if [ "$1" == "mac-catalyst-x86_64" ]; then
    VERSION_MIN=13.6
    LIBMAME=libmame-mac-x86_64
    SDK="`xcodebuild -version -sdk macosx Path`"
    export BUILDDIR=build-mac-x86_64
    export ARCHOPTS="-arch x86_64 -isysroot $SDK -iframework $SDK/System/iOSSupport/System/Library/Frameworks -miphoneos-version-min=$VERSION_MIN -target x86_64-apple-ios13.6-macabi"
    shift
fi

if [ "$1" == "mac-catalyst" ]; then
    shift
    $0 mac-catalyst-arm64 $@ || exit -1
    $0 mac-catalyst-x86_64 $@ || exit -1
    if [ "$1" == "clean" ]; then
        echo Deleting libmame-mac.a
        rm libmame-mac.a || true
    else
        echo Archiving libmame-mac.a
        lipo -create libmame-mac-*.a -output libmame-mac.a
        rm libmame-mac-*.a
    fi
    exit
fi

if [ "$1" == "all" ]; then
    shift
    $0 $@ || exit -1
    $0 tvos $@ || exit -1
    $0 mac-catalyst $@ || exit -1
    exit
fi

## common OPTS
export ARCHOPTS="$ARCHOPTS -fPIC"

## hack to get sqlite to build
export ARCHOPTS="$ARCHOPTS -DHAVE_GETHOSTUUID=0"

## export FORCE_DRC_C_BACKEND=1
## export NOASM=1
## export REGENIE=1
make OSD=ios -j`sysctl -n hw.logicalcpu` $@ || exit -1

if [ "$1" == "clean" ]; then
    echo Deleting $LIBMAME.a
    rm $LIBMAME.a || true
else
    LIBDIR="$BUILDDIR/osx_clang/bin/x64/Release"
    echo Archiving $LIBMAME.a
    libtool -static -o $LIBMAME.a libmame.a $LIBDIR/*.a $LIBDIR/mame_mame/*.a 2> /dev/null
    rm libmame.a
fi


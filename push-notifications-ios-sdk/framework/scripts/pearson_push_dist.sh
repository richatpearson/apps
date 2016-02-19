#!/bin/sh
#  pearson_push_dist.sh
#  PushNotifications
#
#  Copyright (c) 2014 Pearson. All rights reserved.

function failed()
{
    echo "Build failed: $1" >&2
    exit $2
}

function build_sdk()
{
    cd src/xcode
    echo "BUILDING SDK"
    echo "$PWD"
    xcodebuild -configuration $cfg -sdk $sdk clean;
    xcodebuild -configuration $cfg -sdk $sdk || failed "${sdk}-${cfg} failed to build" $?
}

function buildall()
{
    for cfg in $CONFIGURATION; do
        for sdk in $SDKS; do
        
            #build sdk using configuration
            build_sdk
        done

        lib_386=build/${cfg}-iphonesimulator/lib${LIBNAME}.a
        lib_arm=build/${cfg}-iphoneos/lib${LIBNAME}.a
        lib_fat=lib${FRAMEWORKNAME}.a

        if [ ${cfg} == "Debug" ]; then
            lib_fat=lib${FRAMEWORKNAME}-d.a
        fi

        lipo -create ${lib_arm} ${lib_386} -output build/dist/${lib_fat}
    done
    echo "End of Distribution Build phase"
    echo ""
}

#xcode
#DEVELOPER_DIR="/Applications/Xcode.app/Contents/Developer"
#export DEVELOPER_DIR

#artifacts
LIBNAME="PushNotifications"
FRAMEWORKNAME="PushNotifications"

#configuration
SDKS="iphoneos iphonesimulator"

CONFIGURATION="Debug Release" #uncomment if you want debug configurations built
#CONFIGURATION="Release"

#clean before creating new distribution
rm -rf src/xcode/build/dist
mkdir -p src/xcode/build/dist/Headers

# Unset CC
export CC=

#build all artifacts
buildall

#copy headers
find build/${cfg}-iphoneos/include -name '*.h' -exec cp {} build/dist/Headers \;


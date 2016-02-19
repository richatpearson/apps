#!/bin/sh

#  pearson_push_framework.sh
#  PushNotifications
#
#  Copyright (c) 2012 Pearson. All rights reserved.

# Original Script by  Pete Goodliffe
# from http://accu.org/index.php/journals/1594

# Modified by Juan Batiz-Benet to fit GHUnit
# Modified by Gabriel Handford for GHUnit

set -e

# Define these to suit your nefarious purposes
FRAMEWORK_NAME=PushNotifications
LIB_NAME=libPushNotifications.a
FRAMEWORK_VERSION=A
BUILD_TYPE=Release

#cd ..
echo "$PWD"

#sh ./Scripts/dist.sh $1

# Where we'll put the build framework.
# The script presumes we're in the project root
# directory. Xcode builds in "build" by default
FRAMEWORK_BUILD_PATH="src/xcode/build/framework"

# Clean any existing framework that might be there
# already
echo "Framework: Cleaning framework..."
[ -d "$FRAMEWORK_BUILD_PATH" ] && \
rm -rf "$FRAMEWORK_BUILD_PATH"


# This is the full name of the framework we'll
# build
FRAMEWORK_DIR=$FRAMEWORK_BUILD_PATH/$FRAMEWORK_NAME.framework

# Build the canonical Framework bundle directory
# structure
echo "Framework: Setting up directories... FRAMEWORK_DIR=$FRAMEWORK_DIR"
mkdir -p $FRAMEWORK_DIR
mkdir -p $FRAMEWORK_DIR/Versions
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Resources
mkdir -p $FRAMEWORK_DIR/Versions/$FRAMEWORK_VERSION/Headers

echo "Framework: Creating symlinks..."
ln -s $FRAMEWORK_VERSION $FRAMEWORK_DIR/Versions/Current
ln -s Versions/Current/Headers $FRAMEWORK_DIR/Headers
ln -s Versions/Current/Resources $FRAMEWORK_DIR/Resources
ln -s Versions/Current/$FRAMEWORK_NAME $FRAMEWORK_DIR/$FRAMEWORK_NAME


# The library file is given the same name as the
# framework with no .a extension.
echo "Framework: Copying library..."
echo "$PWD"
cp src/xcode/build/dist/${LIB_NAME} "$FRAMEWORK_DIR/Versions/Current/$FRAMEWORK_NAME"

#lipo \
#-create \
#"$ARM_FILES" \
#"$I386_FILES" \
#-o "$FRAMEWORK_DIR/Versions/Current/$FRAMEWORK_NAME"

# Now copy the final assets over: your library
# header files and the plist file
echo "Framework: Copying assets into current version..."
cp src/xcode/build/dist/Headers/*.h $FRAMEWORK_DIR/Headers/
#cp Framework.plist $FRAMEWORK_DIR/Resources/Info.plist


echo ""
echo "The framework was built at: $FRAMEWORK_DIR"
echo ""

#open "$FRAMEWORK_BUILD_PATH"

# Run Unit Tests

#echo ""
#echo "Running Unit Tests..."
#echo ""

#cd src/xcode
#xcodebuild -sdk iphonesimulator -configuration Debug -scheme PearsonAppServicesUnitTests test;
#cd ..
#cd ..

#echo ""
#echo "Finished running Unit Tests."

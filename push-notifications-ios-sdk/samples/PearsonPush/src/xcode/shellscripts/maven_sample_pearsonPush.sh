#!/bin/bash

#  maven_sample_pearsonPush.sh
#  PearsonAppServicesiOSSDK
#
#  Copyright (c) 2012 Pearson. All rights reserved.
#

echo "BUILDING SAMPLE PEARSONPUSH APPS"

PROJECT_DIR="samples/PearsonPush/src/xcode"
PROJECT_NAME="PearsonPush.xcodeproj"
SDKS="iphoneos iphonesimulator"
CONFIGS="Debug Release"

BUILD_PATH="build"

KEYCHAIN_PASSWORD=""

# not currently using - using default settings in Xcode project - 9/23/13
function validate_keychain()
{
  # unlock the keychain containing the provisioning profile's private key and set it as the default keychain
  security unlock-keychain -p "$keychain_password" "$HOME/Library/Keychains/login.keychain"
  security default-keychain -s "$HOME/Library/Keychains/login.keychain"
  
  #describe the available provisioning profiles
  echo "Available provisioning profiles"
  security find-identity -p codesigning -v

  #verify that the requested provisioning profile can be found
  (security find-certificate -a -c "$DEVELOPER_NAME" -Z | grep ^SHA-1) || failed provisioning_profile  
}

function failed()
{
    echo "SCRIPT ERROR Build failed: $1" >&2
    exit $2
}

function build_clean()
{
    cd $PROJECT_DIR
    xcodebuild -alltargets -configuration $cfg -sdk $sdk clean;
}

function build_archive()
{
	echo "******************** ARCHIVING ********************"
	echo "------------------- DEV VERSION -------------------"
	xcodebuild -verbose -scheme PearsonPush -configuration Release -sdk "iphoneos" archive || failed "${sdk}-${cfg} failed to archive" $?
#	echo "------------------ DIST VERSION -------------------"
#	xcodebuild -verbose -scheme PearsonPushDist -configuration Release -sdk "iphoneos" archive || failed "${sdk}-${cfg} failed to archive" $?
	
	#Note: the xcrun call to build the ipa is located in the Xcode project. Each target scheme's Archive Post-actions contains the following line:
	# xcrun -sdk iphoneos PackageApplication "$ARCHIVE_PRODUCTS_PATH/$INSTALL_PATH/$WRAPPER_NAME" -o "${HOME}/mobileplatform/pearson-appservices-ios-sdk/samples/PearsonPush/build/${PRODUCT_NAME}.ipa"
	
	#open finder window
	HOME=`pwd`
    echo "Archive completed, ipa files are done"
    echo "$HOME/$BUILD_PATH"
    open $HOME/$BUILD_PATH
}

function removePreviousBuild()
{
	echo "Removing previous build..."
	HOME_DIR=`pwd`
	echo "BUILD: ${HOME_DIR}/${PROJECT_DIR}/${BUILD_PATH}"
	PREVIOUS_BUILD=${HOME_DIR}/${PROJECT_DIR}/${BUILD_PATH}
	rm -rf $PREVIOUS_BUILD
}

#Validate keychain 
#validate_keychain

#Clear PearsonPush build folder
removePreviousBuild

#Run Product Clean
build_clean

#Build Product Archives
build_archive
#!/bin/sh
#  get_appservices_from_nexus.sh
#  PushNotifications
#
#  Copyright (c) 2014 Pearson. All rights reserved.

## navigate to project's root directory
cd ${XCS_SOURCE_DIR}/push-notifications-ios-sdk/framework/src/xcode

## the frameworks directory will hold the .framework appservices ependency
mkdir frameworks

## get Pearson Appservices dependency from Nexus 3-rd party repo:
curl --user sanutriamci:Secure#1 -O https://devops-tools.pearson.com/nexus-deps/content/repositories/thirdparty/com/pearson/mobileplatform/ios/appservices/appservices/2.0.12.0/appservices-2.0.12.0.xcode-framework-zip

unzip appservices-2.0.12.0.xcode-framework-zip

cp -r appservices-2.0.12.0/PearsonAppServicesiOSSDK.framework frameworks/.

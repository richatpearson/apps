#!/bin/sh
#  get_pearsonpush_dependencies.sh
#  PushNotifications
#
#  Copyright (c) 2014 Pearson. All rights reserved.

## get PearsonAppServices framework from nexus for push sdk - run existing ciBuild script:
${XCS_SOURCE_DIR}/push-notifications-ios-sdk/framework/scripts/ciBuild/get_appservices_from_nexus.sh

## generate .framework dir for push-notifications-ios-sdk (dependency for Push test app)
cd ${XCS_SOURCE_DIR}/push-notifications-ios-sdk/framework/
scripts/pearson_push_dist.sh

echo Do we have .a?
ls -ltr src/xcode/build/dist/

scripts/pearson_push_framework.sh

echo Do we have .framework?
ls -ltr src/xcode/build/framework/

## navigate to project's root directory for test app
cd ${XCS_SOURCE_DIR}/push-notifications-ios-sdk/samples/PearsonPush/src/xcode/

## the frameworks directory will hold all necessary dependencies
mkdir frameworks

## get Pi dependency from Nexus master release repo:
curl --user sanutriamci:Secure#1 -O https://devops-tools.pearson.com/nexus-master/content/repositories/releases/com/pearson/grid/mobile/ios/pi/pi/1.2.0/pi-1.2.0.xcode-framework-zip

unzip pi-1.2.0.xcode-framework-zip

cp -r Pi-ios-client.framework frameworks/.

## copy push and appservices libraries (.framework dirs)
cp -r ../../../../framework/src/xcode/frameworks/PearsonAppServicesiOSSDK.framework frameworks/.
cp -r ../../../../framework/src/xcode/build/framework/PushNotifications.framework frameworks/.

echo The content of test app frameworks dir:
ls -ltr frameworks/

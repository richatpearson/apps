//
//  PGMCoreDeviceData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Data specific to the Device to be gathered and retained
 */
@interface PGMCoreDeviceData : NSObject

extern NSString* const PGMCoreDeviceVendor;
extern NSString* const PGMCoreDeviceModel;
extern NSString* const PGMCoreDeviceOSName;
extern NSString* const PGMCoreDeviceOSVersion;
extern NSString* const PGMCoreDeviceResoluton;
extern NSString* const PGMCoreDeviceTotalDiskSpace;
extern NSString* const PGMCoreDeviceAvaialbleDiskSpace;

/*!
 The device vendor (obviously, it's always "Apple" but we include this for parity with Android data)
 */
@property (strong, nonatomic, readonly)     NSString  *   deviceVendor;
/*!
 The model of the device. (iPhone, iPod touch, iPad)
 */
@property (strong, nonatomic, readonly)     NSString  *   deviceModel;
/*!
 The name of the operating system running on the device represented by the receiver.
 */
@property (strong, nonatomic, readonly)     NSString  *   deviceOSName;
/*!
 The current version of the operating system.
 */
@property (strong, nonatomic, readonly)     NSString  *   deviceOSVersion;

/*!
 The pixel resolution based on the dimensions of the screen multiplied by the 
 screen scale (standard resolution: 1 point is 1 pixel: scale is 1.0, Retina 
 display 1 point is 4 pixels so the scale is 2.0).
 */
@property (strong, nonatomic, readonly)     NSString  *   deviceResolution;

@property (strong, nonatomic, readonly)     NSNumber * deviceTotalDiskSpace;
@property (strong, nonatomic, readonly)     NSNumber * deviceAvailableDiskSpace;

/*!
 Gather device data.
 */
- (void) gatherData;

/*!
 Retrieve all device data
 
 @return Device Data properties as key-value pairs
 */
- (NSDictionary*) dataAsDictionary;

@end

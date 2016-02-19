//
//  PGMCoreApplicationData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMCoreDeviceData.h"

/*!
 Data specific to the Application to be gathered and retained
 */
@interface PGMCoreApplicationData : NSObject

extern NSString* const PGMCoreAppVendorServices;
extern NSString* const PGMCoreAppName;
extern NSString* const PGMCoreAppVersion;
extern NSString* const PGMCoreAppBuild;
extern NSString* const PGMCoreAppBundleId;

/*!
 An alphanumeric string that uniquely identifies a device to the app’s vendor.
 */
@property (strong, nonatomic, readonly)   NSString  *   appVendorID;
/*!
 Application Name (according to the Application Bundle)
 */
@property (strong, nonatomic, readonly)   NSString  *   appName;
/*!
 Application Version (according to the Application Bundle)
 */
@property (strong, nonatomic, readonly)   NSString  *   appVersion;
/*!
 Application Build number (according to the Application Bundle)
 */
@property (strong, nonatomic, readonly)   NSString  *   appBuild;
/*!
 Applications Bundle Identifier
 */
@property (strong, nonatomic, readonly)  NSString   * appBundleId;

/*!
 Initialize with an instance of the DeviceData class. This method won't be needed
 soon because iOS vesions earlier than 6 won't be supported.
 
 @param deviceData Needed for the OS version
 
 @return an instance of ApplicationData
 */
- (id) initWithDeviceData:(PGMCoreDeviceData*)deviceData;

/*!
 Gather application data.
 */
- (void) gatherData;

/*!
 Retrieve all application data
 
 @return Application Data properties as key-value pairs
 */
- (NSDictionary*) dataAsDictionary;

@end

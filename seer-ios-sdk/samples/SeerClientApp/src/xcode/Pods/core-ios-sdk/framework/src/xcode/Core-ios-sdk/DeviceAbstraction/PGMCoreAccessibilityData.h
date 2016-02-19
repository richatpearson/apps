//
//  PGMCoreAccessibilityData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMCoreDeviceData.h"

/*!
 In order to match functionality with the Android class of the same name, expect
 the enabledAccessibiltyServices array to contain a list of only those accessibility 
 services that are turned on. If none are turned on, the array will be empty 
 ([enabledAccessibilityServices count] == 0).
 */
@interface PGMCoreAccessibilityData : NSObject

extern NSString* const PGMCoreEnabledAccessibilityServices;

/*!
 An array of Accessibility services that are turned on
 */
@property (strong, nonatomic, readonly)   NSArray *enabledAccessibilityServices;

/*!
 Initialize with an instance of the DeviceData class. This method won't be needed
 soon because iOS vesions earlier than 6 won't be supported.
 
 @param deviceData Needed for the OS version
 
 @return an instance of AccessibilityData
 */
- (id) initWithDeviceData:(PGMCoreDeviceData*)deviceData;

/*!
 Call to gether accessibility data
 */
- (void) gatherData;

/*!
 Retrieve enabled accessibility data stored as a value in a dictionary
 
 @return a dictionary with a key of 
 */
- (NSDictionary*) dataAsDictionary;

@end

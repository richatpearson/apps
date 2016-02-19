//
//  PGMCoreServiceProviderData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PGMCoreServiceProvider;
extern NSString* const PGMCoreServiceProviderCountry;

/*!
 Data specific to the Service Provider to be gathered and retained
 */
@interface PGMCoreServiceProviderData : NSObject

/*!
 The name of the user’s home cellular service provider. (@"none" if no provider for device)
 */
@property (strong, nonatomic, readonly)   NSString  *   serviceProvider;

/*!
 The ISO country code for the user’s cellular service provider. (@"unavailable" if there is no provider for the device)
 */
@property (strong, nonatomic, readonly)   NSString  *   serviceProviderCountry;

/*!
 Gather service provider data.
 */
- (void) gatherData;

/*!
 Retrieve all service provider data
 
 @return Service Provider Data properties as key-value pairs
 */
- (NSDictionary*) dataAsDictionary;

@end

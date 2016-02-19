//
//  PGMCoreNetworkData.h
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 12/9/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PGMCoreNetworkType;

/*!
 Data specific to the Network to be gathered and retained
 */
@interface PGMCoreNetworkData : NSObject

/*!
 Uses PGMCoreReachability to determine of the network is reachable via WiFi or WWAN.
 */
@property (strong, nonatomic, readonly)   NSString  *   networkType;

/*!
 Gather localization data.
 */
- (void) gatherData;

/*!
 Retrieve all network data
 
 @return Network Data properties as key-value pairs
 */
- (NSDictionary*) dataAsDictionary;

@end

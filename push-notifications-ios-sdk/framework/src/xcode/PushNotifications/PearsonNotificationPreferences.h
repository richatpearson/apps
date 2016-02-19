//
//  PearsonNotificationPreferences.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 2/5/14.
//  Copyright (c) 2014 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Object contains whitelist and blacklist dictionaries for setting Push
 Notification preferences.
 */
@interface PearsonNotificationPreferences : NSObject <NSCoding>

/*!
 Contains a list of types of notifications the user wants to receive (with exceptions)
 */
@property (nonatomic, strong) NSDictionary* whitelist;

/*!
 Contains a list of types of notifications the user does not want to receive (with exceptions)
 */
@property (nonatomic, strong) NSDictionary* blacklist;

/*!
 Retrieve push notifications preferences object
 
 @return Dictionary object containing two dictionary objects, whitelist and blacklist
 */
- (NSDictionary*) getPreferences;

/*!
 Helper method to build the an entry in the whitelist dictionary via an array
 
 @param list An array where the first entry [0] is the preference keymahi mahi and subsequent entries are exceptions (if any).
 */
- (void) addToWhitelist:(NSArray*)list;

/*!
 Helper method to build the an entry in the blacklist dictionary via an array
 
 @param list An array where the first entry [0] is the preference key and subsequent entries are exceptions (if any).
 */
- (void) addToBlacklist:(NSArray*)list;

@end

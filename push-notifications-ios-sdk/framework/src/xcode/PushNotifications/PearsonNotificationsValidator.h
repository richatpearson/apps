//
//  PearsonNotificationsValidator.h
//  PushNotifications
//
//  Created on 3/19/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!
 Handles any data validation required in the Pearon Push Notifications framework
 */
@interface PearsonNotificationsValidator : NSObject

/*!
 Validate that the group name conforms to the Services requirements of proepr length and using proper characters.
 
 @param groupName The group name to be validated
 
 @return Indicates if the group name is valid (YES) or not (NO).
 */
- (BOOL) validGroupName:(NSString*)groupName;

@end

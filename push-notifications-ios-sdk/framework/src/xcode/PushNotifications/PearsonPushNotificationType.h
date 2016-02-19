//
//  PearsonPushNotificationType.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 8/28/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*!
 A class to easily generate a UIRemoteNotficationType based on application's acceptable notification properties.
 */
@interface PearsonPushNotificationType : NSObject

/*!
 Indicates if the app will receive process badges on the App Icon
 */
@property (assign, nonatomic, readonly) BOOL badge;
/*!
 Indicates if the app wiil play sounds when remote notifications are recieved
 */
@property (assign, nonatomic, readonly) BOOL sound;
/*!
 Indicates if the app wishes to have alerts displayed when remote notifcations are recieved
 */
@property (assign, nonatomic, readonly) BOOL alert;
/*!
 Indicates if app wants newsstand content availability displayed (not yet available for Pearson apps)
 */
@property (assign, nonatomic, readonly) BOOL newsstand;
/*!
 Notification type based on parameters received
 */
@property (assign, nonatomic, readonly) UIRemoteNotificationType notificationType;

@property (assign, nonatomic, readonly) UIUserNotificationType notificationType8;

/*!
 Generates the bit mask value for a `UIRemoteNotificationType` based on boolean parameters.
 
 @param badge     Display badges on the App Icon.
 @param sound     Play sound (custom or default) when notifications are received.
 @param alert     Display an alert (pop-up or banner) when notifications are received.
 @param newsstand Display newsstand content availability (not yet available through Pearson).
 
 @return An bit mask value corresponding to a notification type
 */
+ (NSUInteger) getTypeWithBadge:(BOOL)badge //UIRemoteNotificationType
                          Sound:(BOOL)sound
                          Alert:(BOOL)alert
                      Newsstand:(BOOL)newsstand;

/*!
 Informs if any notification types are set for the app, for user. This method handles both iOS 7 and iOS 8
 
 @return YES (true) if at least one notification is set and NO (false) if none are set
 */
- (BOOL) areNotificationTypesSet;

@end

//
//  PearsonNotification.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 6/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Object containing data in regard to an incoming notification associated with
 a specific user id.
 @framework PearsonPushNotifications.framework
 */
@interface PearsonNotification : NSObject <NSCoding>

extern NSString* const kPN_APSKey;
extern NSString* const kPN_APSAlertKey;
extern NSString* const kPN_APSSoundKey;
extern NSString* const kPN_APSBadgeKey;
extern NSString* const kPN_APSContentAvailable;

/*!
 User Id obtained through the Authorization process
 */
@property (strong, nonatomic) NSString* userID;
/*!
 Alert received from incoming notification as a string
 */
@property (strong, nonatomic) NSString* alert;
/*!
 Alert received from notfication as dictionary
 */
@property (strong, nonatomic) NSDictionary* alertDict;
/*!
 Sound info received from incoming notification
 */
@property (strong, nonatomic) NSString* sound;
/*!
 Badge data received from incoming notification
 */
@property (strong, nonatomic) NSNumber* badge;
/*!
 Indicates if Newsstand content is available (not currently implemented for Pearson)
 */
@property (strong, nonatomic) NSNumber* contentAvailable;
/*!
 Timestamp indicating when the framework received the notification
 */
@property (strong, nonatomic) NSDate* timestamp;
/*!
 The runtime state of the application when the notification was received
 */
@property (assign, nonatomic) NSInteger applicationState;
/*!
 A Boolean to indicate if the Notification has been read
 */
@property (assign, nonatomic) BOOL hasBeenRead;
/*!
 Custom data included in the incoming notification
 */
@property (strong, nonatomic) NSMutableDictionary* customPayload;
/*!
 The incoming notification userInfo
 */
@property (strong, nonatomic) NSDictionary* incomingNotification;

/*!
 Initializes an instance of the PushNotification class using an incoming Notification's
 userInfo dictionary (passed into the PearsonPushNotifications instance from the AppDelegate)
 and the current user Id.
 
 @param incomingNotification The userInfo dictionary associated with the remote
 notification received by the AppDelegate.
 @param userId               The current user id obtained through authorization.
 
 @return a timestamped instance containing all of the incoming data.
 */
-(id)initWithDictionary:(NSDictionary*)incomingNotification forUserID:(NSString*)userId;

@end

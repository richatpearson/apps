//
//  NotificationHistory.h
//  PearsonPush
//
//  Created by Tomack, Barry on 8/23/13.
//  Copyright (c) 2013 PearsonLTG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PushNotifications/PearsonNotification.h>

#define kPN_NotificationsUpdate @"notificationsUpdate"

@interface NotificationHistory : NSObject

@property (readonly) NSInteger capacity;

- (id) initWithCapacity:(NSInteger)num;
- (BOOL) addToHistory:(PearsonNotification*)notification;

- (void) restoreHistory;

- (NSArray*) getStoredNotificationsForUserId:(NSString*)userId;

- (void) clearStoredNotificationsForUserId:(NSString*)userId;

@end

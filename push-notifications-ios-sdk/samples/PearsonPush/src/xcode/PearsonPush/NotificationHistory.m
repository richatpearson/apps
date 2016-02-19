//
//  NotificationHistory.m
//  PearsonPush
//
//  Created by Tomack, Barry on 8/23/13.
//  Copyright (c) 2013 PearsonLTG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NotificationHistory.h"

@interface NotificationHistory()

@property (strong, nonatomic, readwrite) NSMutableArray* notifications;


/**
 The number of notifications to be saved by the app (if 0, the app won't save any)
 */
@property (readwrite) NSInteger capacity;

@end

@implementation NotificationHistory

-(id)init
{
    assert(0);
    return nil;
}

- (id) initWithCapacity:(NSInteger)num
{
    self = [super init];
    if ( self )
    {
        self.capacity = num;
    }
    return self;
}

- (BOOL) addToHistory:(PearsonNotification*)notification
{
    if (self.capacity > 0)
    {
        if ( !self.notifications )
        {
            self.notifications = [NSMutableArray new];
        }
        // If notifications has reached it's capacity, then remove the first item.
        if ( [self.notifications count] >= self.capacity)
        {
            [self.notifications removeObjectAtIndex:0];
        }
        // Add the new item to the end of the array
        [self.notifications addObject:notification];
        // Get the Notification Archive File Path
        NSString* notificationsPath = [self pathToNotificationsArray];
        // Archive notifications to archive file
        [NSKeyedArchiver archiveRootObject:self.notifications toFile:notificationsPath];
        return YES;
    }
    return NO;
}

- (BOOL) clearHistoryForUserId:(NSString*)userId
{
    if (self.capacity > 0)
    {
        NSMutableArray* tempNotifications = [NSMutableArray new];
        for(int i=0;i<[self.notifications count];i++)
        {
            PearsonNotification* pNotification = (PearsonNotification*)[self.notifications objectAtIndex:i];
            if(![pNotification.userID isEqualToString:userId])
            {
                [tempNotifications addObject:pNotification];
            }
        }
        
        [self.notifications removeAllObjects];
        self.notifications = tempNotifications;
        NSString* notificationsPath = [self pathToNotificationsArray];
        [NSKeyedArchiver archiveRootObject:self.notifications toFile:notificationsPath];
        return YES;
    }
    return NO;
}

- (void) restoreHistory
{
    if (self.capacity > 0)
    {
        NSString* notificationsPath = [self pathToNotificationsArray];
        
        if(!self.notifications)
        {
            self.notifications = [NSMutableArray new];
        }
        else
        {
            [self.notifications removeAllObjects];
        }
        
        NSArray* allNotifications = [NSKeyedUnarchiver unarchiveObjectWithFile: notificationsPath];
        
        if(allNotifications)
        {
            [self.notifications addObjectsFromArray:allNotifications];
        }
        
        while ([self.notifications count] > self.capacity)
        {
            [self.notifications removeObjectAtIndex:0];
        }
    }
}

// Return the path to the Notifications array data in the Documents directory as String
- (NSString *) pathToNotificationsArray
{
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    
    return [documentDirectory stringByAppendingPathComponent:@"Notifications.data"];
}

- (NSArray*) getStoredNotificationsForUserId:(NSString*)userId
{
    NSMutableArray* myNotifications = [NSMutableArray new];
    
    for(PearsonNotification* notification in self.notifications)
    {
        if([notification.userID isEqualToString:userId])
        {
            [myNotifications addObject:notification];
        }
    }
    
    return myNotifications;
}

- (void) clearStoredNotificationsForUserId:(NSString*)userId
{
    if (self.capacity > 0)
    {
        if ([self clearHistoryForUserId:userId])
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:kPN_NotificationsUpdate object:nil];
        }
    }
}

@end

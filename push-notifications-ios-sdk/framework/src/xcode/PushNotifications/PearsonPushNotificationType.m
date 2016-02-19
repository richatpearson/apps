//
//  PearsonPushNotificationType.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 8/28/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PearsonPushNotificationType.h"

@interface PearsonPushNotificationType ()

@property (assign, nonatomic, readwrite) BOOL badge;
@property (assign, nonatomic, readwrite) BOOL sound;
@property (assign, nonatomic, readwrite) BOOL alert;
@property (assign, nonatomic, readwrite) BOOL newsstand;

@property (assign, nonatomic, readwrite) UIRemoteNotificationType notificationType;
@property (assign, nonatomic, readwrite) UIUserNotificationType notificationType8;

@end

@implementation PearsonPushNotificationType

#define SYSTEM_VERSION_LESS_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

-(id)init
{
    self = [super init];
    if ( self )
    {
        self.badge = NO;
        self.sound = NO;
        self.alert = NO;
        self.newsstand = NO;
        
        [self setWithEnabledNotificationTypes];
    }
    NSLog(@"Intializing PearsonPushNotificationType and notification types are: %ld for iOS 7 and %ld for iOS 8",
          (unsigned long)self.notificationType, (unsigned long)self.notificationType8);
    return self;
}

+ (NSUInteger) getTypeWithBadge:(BOOL)badge
                          Sound:(BOOL)sound
                          Alert:(BOOL)alert
                      Newsstand:(BOOL)newsstand;
{
    if (!SYSTEM_VERSION_LESS_THAN(@"8.0")) //iOS 8.x
    {
        UIUserNotificationType pushType8 = UIUserNotificationTypeNone;
        
        if ( badge )
        {
            pushType8 = pushType8 | UIUserNotificationTypeBadge;
        }
        if ( sound )
        {
            pushType8 = pushType8 | UIUserNotificationTypeSound;
        }
        if ( alert )
        {
            pushType8 = pushType8 | UIUserNotificationTypeAlert;
        }
        return pushType8;
        
    }
    else //iOS 7.x or lower
    {
        UIRemoteNotificationType pushType = UIRemoteNotificationTypeNone;
        
        if ( badge )
        {
            pushType = pushType | UIRemoteNotificationTypeBadge;
        }
        if ( sound )
        {
            pushType = pushType | UIRemoteNotificationTypeSound;
        }
        if ( alert )
        {
            pushType = pushType | UIRemoteNotificationTypeAlert;
        }
        if ( newsstand )
        {
            pushType = pushType | UIRemoteNotificationTypeNewsstandContentAvailability;
        }
        return pushType;
    }
}

- (void) setWithEnabledNotificationTypes
{
    UIApplication *application = [UIApplication sharedApplication];
    
    if (!SYSTEM_VERSION_LESS_THAN(@"8.0")) //iOS 8.x
    {
        self.notificationType8 = [[application currentUserNotificationSettings] types];
        NSLog(@"Got notification settings for user on iOS 8... and the types are: %ld", (unsigned long)self.notificationType8);
        
        self.badge = (self.notificationType8 & UIUserNotificationTypeBadge);
        self.sound = (self.notificationType8 & UIUserNotificationTypeSound);
        self.alert = (self.notificationType8 & UIUserNotificationTypeAlert);
        NSLog(@"...and badge is %d, and sound is %d, and alert is %d", self.badge, self.sound, self.alert);
    }
    else //iOS 7.x or lower
    {
        self.notificationType = [application enabledRemoteNotificationTypes];
        NSLog(@"Initializing notification types on iOS 7.x or less...");
        
        self.badge = (self.notificationType & UIRemoteNotificationTypeBadge);
        self.sound = (self.notificationType & UIRemoteNotificationTypeSound);
        self.alert = (self.notificationType & UIRemoteNotificationTypeAlert);
        self.newsstand = (self.notificationType & UIRemoteNotificationTypeNewsstandContentAvailability);
    }
}

- (BOOL) areNotificationTypesSet {
    
    return (self.notificationType > 0 || self.notificationType8 > 0);
}

- (NSString *) description
{
    return [NSString stringWithFormat:@"Application registered with Badge: %@, Sound: %@, Alert: %@, Newsstand: %@",self.badge?@"YES":@"NO",
                                                                                                                    self.sound?@"YES":@"NO",
                                                                                                                    self.alert?@"YES":@"NO",
                                                                                                                    self.newsstand?@"YES":@"NO"];
}

@end

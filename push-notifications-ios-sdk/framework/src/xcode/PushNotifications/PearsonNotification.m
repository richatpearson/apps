//
//  PearsonNotification.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 6/19/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PearsonNotification.h"

@implementation PearsonNotification

NSString* const kPN_APSKey              = @"aps";
NSString* const kPN_APSAlertKey         = @"alert";
NSString* const kPN_APSSoundKey         = @"sound";
NSString* const kPN_APSBadgeKey         = @"badge";
NSString* const kPN_APSContentAvailable = @"content-available";

-(id)initWithDictionary:(NSDictionary*)incomingNotification forUserID:(NSString *)userId
{
    self = [super init];
    if ( self )
    {
        self.userID = userId;
        self.incomingNotification = incomingNotification;
        
        for( id key in incomingNotification)
        {
            if ([key isKindOfClass:[NSString class]])
            {
                if ([key isEqualToString:kPN_APSKey])
                {
                    NSDictionary *incomingDict = [incomingNotification objectForKey:kPN_APSKey];
                    [self processIncomingAPSDict: incomingDict];
                }
                else
                {
                    if(! self.customPayload)
                    {
                        self.customPayload = [NSMutableDictionary new];
                    }
                    [self.customPayload setObject:[incomingNotification objectForKey:key] forKey:key];
                }
            }
        }
        self.timestamp = [NSDate date];
        self.applicationState = [[UIApplication sharedApplication] applicationState];
        self.hasBeenRead = NO;
    }
    return self;
}

- (void) processIncomingAPSDict:(NSDictionary*)incomingDict
{
    for( id key in incomingDict)
    {
        if ([key isEqualToString:kPN_APSAlertKey])
        {
            NSDictionary* apsPayload = [incomingDict objectForKey:kPN_APSKey];
            if(apsPayload)
            {
                if([[apsPayload objectForKey:kPN_APSAlertKey] isKindOfClass:[NSString class]])
                {
                    self.alert = [apsPayload objectForKey:kPN_APSAlertKey];
                }
                else
                {
                    self.alertDict = [apsPayload objectForKey:kPN_APSAlertKey];
                }
            }
            else
            {
                if([[incomingDict objectForKey:kPN_APSAlertKey] isKindOfClass:[NSString class]])
                {
                    self.alert = [incomingDict objectForKey:kPN_APSAlertKey];
                }
                else
                {
                    self.alertDict = [incomingDict objectForKey:kPN_APSAlertKey];
                }
            }
        }
        if([key isEqualToString:kPN_APSSoundKey])
        {
            self.sound = [incomingDict objectForKey:kPN_APSSoundKey];
        }
        if([key isEqualToString:kPN_APSBadgeKey])
        {
            NSInteger badgeAsInt = [[incomingDict objectForKey:kPN_APSBadgeKey] intValue];
            self.badge = [NSNumber numberWithInteger:badgeAsInt];
        }
        if([key isEqualToString:kPN_APSContentAvailable])
        {
            NSInteger contentAvailAsInt = [[incomingDict objectForKey:kPN_APSContentAvailable] intValue];
            self.contentAvailable = [NSNumber numberWithInteger:contentAvailAsInt];
        }
    }
}

-(id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if( self )
    {
        self.userID = [decoder decodeObjectForKey:@"nUserID"];
        self.alert = [decoder decodeObjectForKey:@"nAlert"];
        self.alertDict = [decoder decodeObjectForKey:@"nAlertDict"];
        self.sound = [decoder decodeObjectForKey:@"nSound"];
        self.badge = [decoder decodeObjectForKey:@"nBadge"];
        self.contentAvailable = [decoder decodeObjectForKey:@"nContentAvailable"];
        self.customPayload = [decoder decodeObjectForKey:@"nCustomPayload"];
        self.timestamp = [decoder decodeObjectForKey:@"nTimeStamp"];
        self.applicationState = [decoder decodeIntForKey:@"nAppState"];
        self.hasBeenRead = [decoder decodeBoolForKey:@"nBeenRead"];
        self.incomingNotification = [decoder decodeObjectForKey:@"nIncomingNotification"];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.userID forKey:@"nUserID"];
    [enCoder encodeObject:self.alert forKey:@"nAlert"];
    [enCoder encodeObject:self.alertDict forKey:@"nAlertDict"];
    [enCoder encodeObject:self.sound forKey:@"nSound"];
    [enCoder encodeObject:self.badge forKey:@"nBadge"];
    [enCoder encodeObject:self.contentAvailable forKey:@"nContentAvailable"];
    [enCoder encodeObject:self.customPayload forKey:@"nCustomPayload"];
    [enCoder encodeObject:self.timestamp forKey:@"nTimeStamp"];
    [enCoder encodeInteger:self.applicationState forKey:@"nAppState"];
    [enCoder encodeBool:self.hasBeenRead forKey:@"nBeenRead"];
    [enCoder encodeObject:self.incomingNotification forKey:@"nIncomingNotification"];
}

- (NSString *) description
{
    NSMutableString* desc = [NSMutableString string];
    [desc appendFormat:@"           Notification:"];
    [desc appendFormat:@"-----------------------------------------------"];
    [desc appendFormat:@"userID: %@", self.userID];
    if(self.alert)
    {
        [desc appendFormat:@"alert: %@", self.alert];
    }
    if(self.alertDict)
    {
        [desc appendFormat:@"alertDict: %@", self.alertDict];
    }
    [desc appendFormat:@"sound: %@", self.sound];
    [desc appendFormat:@"badge: %@", self.badge];
    if(self.customPayload)
    {
        [desc appendFormat:@"customPayload: %@", self.customPayload];
    }
    [desc appendFormat:@"timestamp: %@", self.timestamp];
    [desc appendFormat:@"applicationState: %ld", (long)self.applicationState];
    [desc appendFormat:@"hasBeenRead: %@", self.hasBeenRead?@"YES":@"NO"];
    [desc appendFormat:@"-----------------------------------------------"];
    
    return desc;
}

@end

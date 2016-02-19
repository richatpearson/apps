//
//  PearsonNotificationPreferences.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 2/5/14.
//  Copyright (c) 2014 Apigee. All rights reserved.
//

#import "PearsonNotificationPreferences.h"

@implementation PearsonNotificationPreferences

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.whitelist = [NSMutableDictionary new];
        self.blacklist = [NSMutableDictionary new];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init])
    {
        self.whitelist = [aDecoder decodeObjectForKey:@"whitelist"];
        self.blacklist = [aDecoder decodeObjectForKey:@"blacklist"];
    }
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.whitelist forKey:@"whitelist"];
    [aCoder encodeObject:self.blacklist forKey:@"blacklist"];
}

- (NSDictionary*) getPreferences
{
    NSMutableDictionary* mobilePlatform = [NSMutableDictionary new];
    
    NSMutableDictionary* preferences = [NSMutableDictionary new];
    
    if (self.whitelist)
    {
        [preferences setObject:self.whitelist forKey:@"whitelist"];
    }
    if (self.blacklist)
    {
        [preferences setObject:self.blacklist forKey:@"blacklist"];
    }
    
    [mobilePlatform setObject:preferences forKey:@"preferences"];
    
    return mobilePlatform;
}

- (void) addToWhitelist:(NSArray*)list
{
    if (!self.whitelist)
    {
        self.whitelist = [NSMutableDictionary new];
    }
    if ([list count] > 0)
    {
        NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.whitelist];
        [mutableDict setObject:[self getExceptionsFromList:list] forKey:[self getKeyFromList:list]];
        
        self.whitelist = mutableDict;
    }
}

- (void) addToBlacklist:(NSArray*)list
{
    if (!self.blacklist)
    {
        self.blacklist = [NSMutableDictionary new];
    }
    if ([list count] > 0)
    {
        NSMutableDictionary* mutableDict = [NSMutableDictionary dictionaryWithDictionary:self.blacklist];
        [mutableDict setObject:[self getExceptionsFromList:list] forKey:[self getKeyFromList:list]];
        
        self.blacklist = mutableDict;
    }
}

- (NSString*) getKeyFromList:(NSArray*)list
{
    NSString* key = @"";
    if ([list count] > 0)
    {
        if ([[list objectAtIndex:0] isKindOfClass:[NSString class]])
        {
            key = [list objectAtIndex:0];
        }
    }
    return key;
}

- (NSArray*) getExceptionsFromList:(NSArray*)list
{
    NSMutableArray* exceptions = [NSMutableArray new];
    
    if ([list count] > 1)
    {
        [exceptions setArray:list];
        [exceptions removeObjectAtIndex:0];
    }

    return exceptions;
}

@end

//
//  AuthResponse.m
//  PearsonPush
//
//  Created by Tomack, Barry on 10/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "AuthResponse.h"

#define SECONDS_IN_MINUTE 60

@interface AuthResponse ()

@property (nonatomic, strong) NSString* wAuthToken;
@property (nonatomic, strong) NSString* wUserId;
@property (nonatomic, assign) NSUInteger expirationInMinutes;
@property (nonatomic, strong) NSDate* wTimestamp;

@property (nonatomic, strong) NSString* wRefreshToken;
@property (nonatomic, strong) NSString* wWindmill;
@end

@implementation AuthResponse

- (id) init
{
    if(self = [super init])
    {
        self.expirationInMinutes = 60;
    }
    return self;
}

# pragma mark GETS

- (NSString*) authToken
{
    NSString* token = @"";
    
    if(self.wAuthToken)
    {
        token = self.wAuthToken;
    }
    
    return token;
}

- (NSString*) userId
{
    NSString* uID = @"";
    
    if(self.wUserId)
    {
        uID = self.wUserId;
    }
    
    return uID;
}


- (NSString*) refreshToken
{
    NSString* rToken = @"";
    
    if(self.wRefreshToken)
    {
        rToken = self.wRefreshToken;
    }
    
    return rToken;
}

- (NSString*) windmill
{
    NSString* windMill = @"";
    
    if(self.wWindmill)
    {
        windMill = self.wWindmill;
    }
    
    return windMill;
}

# pragma mark SETS

- (void) setAuthToken:(NSString*)token
{
    self.wAuthToken = [NSString stringWithFormat:@"Bearer %@", token];
    [self setTimestamp:[NSDate date]];
}

- (void) setUserID:(NSString*)userID
{
    self.wUserId = userID;
    [self setTimestamp:[NSDate date]];
}

- (void) setExpirationTimeInMinutes:(NSUInteger)minutes
{
    self.expirationInMinutes = minutes;
}

- (void) setRefreshToken:(NSString*)refreshToken
{
    self.wRefreshToken = refreshToken;
}

- (void) setWindmill:(NSString*)windMill
{
    self.wWindmill = windMill;
}

- (void) setTimestamp:(NSDate*)date
{
    if(self.wTimestamp)
    {
        NSTimeInterval diff = [date timeIntervalSinceDate:self.wTimestamp];
        if(diff < 0)
        {
            self.wTimestamp = date;
        }
    }
    else
    {
        self.wTimestamp = date;
    }
}

# pragma mark check validity of values

- (BOOL) isCurrent
{
    BOOL goodToGo = NO;
    
    if(self.wAuthToken && !([self.wAuthToken isEqualToString:@""])  )
    {
        if(self.wUserId && !([self.wUserId isEqualToString:@""]) )
        {
            if(![self isExpired])
            {
                goodToGo = YES;
            }
        }
    }
    
    return goodToGo;
}

- (BOOL) isExpired
{
    BOOL expired = YES;
    
    NSDate* now = [NSDate date];
    
    // Time Interval in Seconds
    NSTimeInterval diff = [now timeIntervalSinceDate:self.wTimestamp];
    // Time Interval in Minutes
    double diffInMinutes = diff/SECONDS_IN_MINUTE;
    
    if(diffInMinutes < self.expirationInMinutes)
    {
        expired = NO;
    }
    
    return expired;
}

- (void) clear
{
    self.wAuthToken = @"";
    self.wRefreshToken = @"";
    self.wUserId = @"";
    self.wWindmill = @"";
}

@end

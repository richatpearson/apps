//
//  PGMPiToken.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiToken.h"
#import "PGMPiOperationConstants.h"

@interface PGMPiToken()

@property (nonatomic, readwrite) NSString *accessToken;
@property (nonatomic, readwrite) NSString *refreshToken;
@property (nonatomic, readwrite, assign) NSInteger expiresIn;
@property (nonatomic, readwrite) NSTimeInterval creationDateInterval;

@end

@implementation PGMPiToken

- (id) initWithAccessToken:(NSString*)accessToken
              refreshToken:(NSString*)refreshToken
                 expiresIn:(NSUInteger)expiresIn
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.accessToken = accessToken;
    self.refreshToken = refreshToken;
    self.expiresIn = expiresIn;
    self.creationDateInterval = [[NSDate date] timeIntervalSince1970];
    
    return self;
}

- (id) initWithDictionary:(NSDictionary*)tokenDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.accessToken = [tokenDict objectForKey:PGMPiAccessTokenKey];
    self.refreshToken = [tokenDict objectForKey:PGMPiRefreshTokenKey];
    self.expiresIn = (NSUInteger)[[tokenDict objectForKey:PGMPiExpireKey] integerValue];
    self.creationDateInterval = [[NSDate date] timeIntervalSince1970];
    
    return self;
}

- (BOOL) isCurrent
{
    if (self.expiresIn)
    {
        NSTimeInterval currentDateInterval = [[NSDate date] timeIntervalSince1970];
        
//        NSLog(@"currentDateInterval: %f", currentDateInterval);
//        NSLog(@"creationDateInterval: %f", self.creationDateInterval);
//        NSLog(@"Difference: %f", (currentDateInterval - self.creationDateInterval));
        
        if( (currentDateInterval - self.creationDateInterval) > self.expiresIn )
        {
            return NO;
        }
    
        return YES;
    }
    return NO;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.accessToken = [decoder decodeObjectForKey:@"accessToken"];
    self.refreshToken = [decoder decodeObjectForKey:@"refreshToken"];
    self.expiresIn = [decoder decodeIntegerForKey:@"expiresIn"];
    self.creationDateInterval = [decoder decodeDoubleForKey:@"creationDateInterval"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.accessToken forKey:@"accessToken"];
    [encoder encodeObject:self.refreshToken forKey:@"refreshToken"];
    [encoder encodeInteger:self.expiresIn forKey:@"expiresIn"];
    [encoder encodeDouble:self.creationDateInterval forKey:@"creationDateInterval"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi Token"];
    [desc appendFormat:@": AccessToken: %@", self.accessToken];
    [desc appendFormat:@": RefreshToken: %@", self.refreshToken];
    [desc appendFormat:@": Expires In: %lu", (unsigned long)self.expiresIn];
    [desc appendFormat:@": creationDateInterval: %f", self.creationDateInterval];
    
    return desc;
}

@end

//
//  PGMPiCredentials.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiCredentials.h"

@implementation PGMPiCredentials

+ (instancetype) credentialsWithUsername:(NSString *)username
                                password:(NSString *)password
{
    return [[self alloc] initWithUsername:username password:password];
}

- (id) initWithUsername:(NSString*)username
               password:(NSString*)password
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.username = username;
    self.password = password;
    
    return self;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.username = [decoder decodeObjectForKey:@"username"];
    self.password = [decoder decodeObjectForKey:@"password"];
    self.resetPassword = [decoder decodeBoolForKey:@"resetPassword"];
    self.userId = [decoder decodeObjectForKey:@"userId"];
    self.identity = [decoder decodeObjectForKey:@"identity"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.username forKey:@"username"];
    [encoder encodeObject:self.password forKey:@"password"];
    [encoder encodeBool:self.resetPassword forKey:@"resetPassword"];
    [encoder encodeObject:self.userId forKey:@"userId"];
    [encoder encodeObject:self.identity forKey:@"identity"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi Credentials"];
    [desc appendFormat:@": Username: %@", self.username];
    [desc appendFormat:@": Password: %@", self.password];
    [desc appendFormat:@": ResetPassword: %@", self.resetPassword?@"YES":@"NO"];
    
    [desc appendFormat:@": UserId: %@", self.userId];
    [desc appendFormat:@": Identity: %@", self.identity];
    
    return desc;
}

@end

//
//  PGMPiIdentityProfile.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiIdentityProfile.h"

@interface PGMPiIdentityProfile()

@property (nonatomic, readwrite) NSString *title;
@property (nonatomic, readwrite) NSString *givenName;
@property (nonatomic, readwrite) NSString *middleName;
@property (nonatomic, readwrite) NSString *familyName;
@property (nonatomic, readwrite) NSString *suffix;
@property (nonatomic, readwrite) NSDictionary *preferences;
@property (nonatomic, readwrite) NSArray *emails;

@end

@implementation PGMPiIdentityProfile

#pragma mark - NSCoding

- (id) initWithDictionary:(NSDictionary*)idDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    if (idDict)
    {
        for (NSString *key in idDict)
        {
            if ([key isEqualToString:@"title"])
            {
                self.title = [idDict objectForKey:@"title"];
            }
            if ([key isEqualToString:@"givenName"])
            {
                self.givenName = [idDict objectForKey:@"givenName"];
            }
            if ([key isEqualToString:@"middleName"])
            {
                self.middleName = [idDict objectForKey:@"middleName"];
            }
            if ([key isEqualToString:@"familyName"])
            {
                self.familyName = [idDict objectForKey:@"familyName"];
            }
            if ([key isEqualToString:@"suffix"])
            {
                self.suffix = [idDict objectForKey:@"suffix"];
            }
            if ([key isEqualToString:@"preferences"])
            {
                self.preferences = [idDict objectForKey:@"preferences"];
            }
            if ([key isEqualToString:@"emails"])
            {
                self.emails = [idDict objectForKey:@"emails"];
            }
        }
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    self.title = [decoder decodeObjectForKey:@"title"];
    self.givenName = [decoder decodeObjectForKey:@"givenName"];
    self.middleName = [decoder decodeObjectForKey:@"middleName"];
    self.familyName = [decoder decodeObjectForKey:@"familyName"];
    self.suffix = [decoder decodeObjectForKey:@"suffix"];
    self.preferences = [decoder decodeObjectForKey:@"preferences"];
    self.emails = [decoder decodeObjectForKey:@"emails"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.title forKey:@"title"];
    [encoder encodeObject:self.givenName forKey:@"givenName"];
    [encoder encodeObject:self.middleName forKey:@"middleName"];
    [encoder encodeObject:self.familyName forKey:@"familyName"];
    [encoder encodeObject:self.suffix forKey:@"suffix"];
    [encoder encodeObject:self.preferences forKey:@"preferences"];
    [encoder encodeObject:self.emails forKey:@"emails"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi Identity Profile"];
    [desc appendFormat:@": IdentityId: %@", self.identityId];
    [desc appendFormat:@": Title: %@", self.title];
    [desc appendFormat:@": Given Name In: %@", self.givenName];
    [desc appendFormat:@": Middle Name: %@", self.middleName];
    [desc appendFormat:@": FamilyName: %@", self.familyName];
    [desc appendFormat:@": Suffix: %@", self.suffix];
    [desc appendFormat:@": Preferences: %@", self.preferences];
    [desc appendFormat:@": Emails: %@", self.emails];
    
    return desc;
}
@end

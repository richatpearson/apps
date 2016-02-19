//
//  PGMPiIdentity.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiIdentity.h"

@interface PGMPiIdentity()

@property (nonatomic, readwrite) NSString* identityId;
@property (nonatomic, readwrite) NSString *uri;
@property (nonatomic, readwrite) PGMPiAlternateId *alternateId;

@end

@implementation PGMPiIdentity

- (id) initWithDictionary:(NSDictionary*) idDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    for (NSString *key in idDict)
    {
        if ([key isEqualToString:@"id"])
            self.identityId = [idDict objectForKey:key];
        if ([key isEqualToString:@"uri"])
            self.uri = [idDict objectForKey:key];
        if ([key isEqualToString:@"identityId"])
            self.identityId = [idDict objectForKey:key];
        if ([key isEqualToString:@"alternateId"])
            self.alternateId = [[PGMPiAlternateId alloc] initWithDictionary:[idDict objectForKey:key]];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.identityId = [decoder decodeObjectForKey:@"identityId"];
    self.uri = [decoder decodeObjectForKey:@"uri"];
    self.alternateId = [decoder decodeObjectForKey:@"alternateId"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.identityId forKey:@"identityId"];
    [encoder encodeObject:self.uri forKey:@"uri"];
    [encoder encodeObject:self.alternateId forKey:@"alternateId"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi Identity"];
    [desc appendFormat:@": IdentityId: %@", self.identityId];
    [desc appendFormat:@": uri: %@", self.uri];
    
    if(self.alternateId)
    {
        [desc appendFormat:@": AlternateId: %@", self.alternateId];
    }
    
    return desc;
}

@end

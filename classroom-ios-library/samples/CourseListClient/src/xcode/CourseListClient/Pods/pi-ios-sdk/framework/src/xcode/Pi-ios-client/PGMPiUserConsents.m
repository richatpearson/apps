//
//  PGMPiUserConsents.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiUserConsents.h"

@implementation PGMPiUserConsents

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.consentId = [decoder decodeObjectForKey:@"consentId"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.consentId forKey:@"consentId"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@"Pi User Consent"];
    [desc appendFormat:@": consentId: %@", self.consentId];
    
    return desc;
}

@end

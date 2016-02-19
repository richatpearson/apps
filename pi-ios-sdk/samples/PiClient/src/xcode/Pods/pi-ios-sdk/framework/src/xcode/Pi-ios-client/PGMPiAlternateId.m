//
//  PGMPiAlternateId.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiAlternateId.h"

@interface PGMPiAlternateId()

@property (nonatomic, readwrite) NSString *context;
@property (nonatomic, readwrite) NSString *contextId;

@end

@implementation PGMPiAlternateId

- (id) initWithDictionary:(NSDictionary*) altIdDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    for (NSString *key in altIdDict)
    {
        if ([key isEqualToString:@"context"])
            self.context = [altIdDict objectForKey:key];
        if ([key isEqualToString:@"contextId"])
            self.contextId = [altIdDict objectForKey:key];
    }
    
    return self;
}

- (id) initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    
    self.context = [decoder decodeObjectForKey:@"context"];
    self.contextId = [decoder decodeObjectForKey:@"contextId"];
    
    return self;
}

- (void) encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.context forKey:@"context"];
    [encoder encodeObject:self.contextId forKey:@"contextId"];
}

- (NSString*) description
{
    NSMutableString *desc = [NSMutableString new];
    [desc appendFormat:@": context: %@", self.context];
    [desc appendFormat:@": contextId: %@", self.contextId];
    
    return desc;
}


@end

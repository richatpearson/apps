//
//  SeerQueueResponse.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 2/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerQueueResponse.h"

@implementation SeerQueueResponse

- (NSString*) description
{
    NSMutableString* desc = [NSMutableString new];
    
    [desc appendFormat: @"success: %@", self.success?@"YES, ":@"NO, "];
    [desc appendFormat: @"error: %@, ", self.error];
    [desc appendFormat: @"deleted old items: %@", self.deletedOldestQueueItems];
    
    if([self.object isKindOfClass:[NSString class]] ||
       [self.object isKindOfClass:[NSArray class]] ||
       [self.object isKindOfClass:[NSDictionary class]] ||
       [self.object isKindOfClass:[NSNumber class]])
    {
        [desc appendFormat: @"object: %@", self.object];
    }
    
    return desc;
}

@end

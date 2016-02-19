//
//  SeerClientResponse.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerClientResponse.h"

@implementation SeerClientResponse

- (NSString*) description
{
    NSMutableString* desc = [NSMutableString new];
    
    [desc appendFormat: @"success: %@", self.success?@"YES, ":@"NO, "];
    [desc appendFormat: @"requestId: %ld, ", (long)self.requestId];
    [desc appendFormat: @"error: %@, ", self.error];
    [desc appendFormat: @"requestType: %@, ", self.requestType];
    [desc appendFormat: @"queued: %@, ", self.queued?@"YES":@"NO"];
    [desc appendFormat: @"deleted old items: %@", self.deletedOldestQueueItems];
    
    return desc;
}

@end

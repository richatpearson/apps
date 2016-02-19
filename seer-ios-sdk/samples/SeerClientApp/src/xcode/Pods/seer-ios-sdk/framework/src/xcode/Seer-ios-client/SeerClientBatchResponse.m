//
//  SeerClientBatchResponse.m
//  Seer-ios-client
//
//  Created by Richard Rosiak on 4/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SeerClientBatchResponse.h"

@implementation SeerClientBatchResponse

- (NSString*) description
{
    NSMutableString* desc = [NSMutableString new];
    
    [desc appendFormat: @"success: %@", self.success?@"YES, ":@"NO, "];
    [desc appendFormat: @"requestIds: %@, ", self.requestIds.description];
    [desc appendFormat: @"error: %@, ", self.error];
    [desc appendFormat: @"requestType: %@, ", self.requestType];
    [desc appendFormat: @"queued: %@, ", self.queued?@"YES":@"NO"];
    
    return desc;
}

@end

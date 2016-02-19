//
//  ValidationResult.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "ValidationResult.h"

@implementation ValidationResult

- (id) init
{
    self = [super init];
    
    if(self)
    {
        self.valid  = YES;
        self.title  = @"";
        self.detail = @"";
    }
    
    return self;
}

@end

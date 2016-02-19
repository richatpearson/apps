//
//  SMSPaths.m
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SMSPaths.h"

@implementation SMSPaths

- (id) init
{
    self = [super init];
    if (self)
    {
        self.authPath  = @"https://cert.api.pearsoncmg.com/authentication/v1/user/authentication/login";
    }
    return self;
}

@end

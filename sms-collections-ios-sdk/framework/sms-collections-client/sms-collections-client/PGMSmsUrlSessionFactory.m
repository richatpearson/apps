//
//  PGMSmsUrlSessionFactory.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsUrlSessionFactory.h"

@implementation PGMSmsUrlSessionFactory

- (NSURLSession *)newUrlSession
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    return [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];
}

@end

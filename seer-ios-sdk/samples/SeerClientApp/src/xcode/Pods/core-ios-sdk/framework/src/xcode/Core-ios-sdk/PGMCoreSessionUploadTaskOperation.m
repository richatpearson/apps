//
//  PGMCoreSessionUploadTaskOperation.m
//  Core-ios-sdk
//
//  Created by Tomack, Barry on 8/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCoreSessionUploadTaskOperation.h"

@implementation PGMCoreSessionUploadTaskOperation

- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request
                           data:(NSData *)data
{
    self = [super init];
    if (self)
    {
        self.task = [session uploadTaskWithRequest:request fromData:data];
    }
    return self;
}

- (instancetype)initWithSession:(NSURLSession *)session
                        request:(NSURLRequest *)request
                       fromFile:(NSURL *)url
{
    self = [super init];
    if (self)
    {
        self.task = [session uploadTaskWithRequest:request fromFile:url];
    }
    return self;
}

@end

//
//  RumbaFetcher.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaFetcher.h"

@implementation RumbaFetcher

- (void) cancelFetch
{
    [self.connection cancel];
}

- (void) rumbaFetchErrorMessage:(NSString*)errorStr
                      errorCode:(NSUInteger)code
{
    NSMutableDictionary* errorDetails = [NSMutableDictionary dictionary];
    [errorDetails setValue:errorStr forKey:NSLocalizedDescriptionKey];
    
    self.error = [[NSError alloc] initWithDomain:@"RumbaFetch"
                                            code:code
                                        userInfo:errorDetails];
}

@end

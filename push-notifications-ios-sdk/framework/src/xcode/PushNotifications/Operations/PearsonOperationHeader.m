//
//  PearsonOperationHeader.m
//  PushNotifications
//
//  Created by Tomack, Barry on 7/25/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PearsonOperationHeader.h"

@implementation PearsonOperationHeader

+ (instancetype) operationHeadersForAuthProvider:(NSString*)authProvider
{
    return [[self alloc] initWithAuthProvider:authProvider];
}

- (id) initWithAuthProvider:(NSString*)aProvider
{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if ([aProvider isEqualToString:@"pi"])
    {
        self.authTokenHeader = @"Authorization";
        self.authProviderHeader = @"X-Auth-Provider";
    }
    else if ([aProvider isEqualToString:@"mi"])
    {
        self.authTokenHeader = @"X-Authorization";
        self.authProviderHeader = @"X-Auth-Provider";
    }
    return self;
}

- (PearsonDataClient *) clearPiClientHeaders:(PearsonDataClient *)dataClient
{
    NSArray *headerAR = [dataClient HTTPHeaderFields];
    
    for (NSString *header in headerAR)
    {
        [dataClient removeHTTPHeaderField:header];
    }
    
    return dataClient;
}

@end

//
//  PearsonGetGRoupOperation.m
//  PushNotifications
//
//  Created by Tomack, Barry on 3/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PearsonGetGroupOperation.h"
#import <PearsonAppServicesiOSSDK/PearsonGroup.h>

#import "PearsonOperationHeader.h"

@implementation PearsonGetGroupOperation

- (id) initWithGroup:(NSString*)group
        authProvider:(NSString*)authProvider
           authToken:(NSString*)authToken
              client:(PearsonDataClient *)dataClient;
{
    self = [super init];
    if ( self )
    {
        PearsonOperationHeader * opHeaders = [PearsonOperationHeader operationHeadersForAuthProvider:authProvider];
        
        self.group = group;
        self.dataClient = [opHeaders clearPiClientHeaders:dataClient];
        
        [self.dataClient addHTTPHeaderField:opHeaders.authTokenHeader withValue:authToken];
        [self.dataClient addHTTPHeaderField:opHeaders.authProviderHeader withValue:authProvider];
        [self.dataClient addHTTPHeaderField:@"Content-Type" withValue:@"application/json"];
    }
    return self;
}

- (void)main
{
    if(self.group)
    {
        PearsonClientResponse* response = [self.dataClient getEntity:@"groups" uuid:self.group];
        if(response.transactionState != kPearsonClientResponsePending)
        {
            [self pearsonClientResponse:response];
        }
    }
    else
    {
        PearsonClientResponse* response = [[PearsonClientResponse alloc] initWithDataClient:self.dataClient];
        response.errorCode = @"100";
        response.errorDescription = @"Device token does not exist or is null";
        [self pearsonClientResponse:response];
    }
}

- (void) pearsonClientResponse:(PearsonClientResponse *)response
{
    self.success = NO;
    
    if (response.completedSuccessfully)
    {
        PearsonGroup* pGroup = (PearsonGroup*)[response firstEntity];
        if(pGroup)
        {
            self.success = YES;
        }
        else if( response.error )
        {
            
        }
    }
    
    if(self.success)
    {
        if ([self.delegate respondsToSelector:@selector(getGroupSuccess:)])
        {
            [self.delegate getGroupSuccess:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(getGroupFailure:)])
        {
            if (response.transactionState == kPearsonClientResponseFailure)
            {
                if ([response.response isEqualToString:@"bad URL"])
                {
                    response.error = NSLocalizedString(@"Restricted Characters in Group Name.", @"BadGroupNameError");
                }
                if ([response.response isEqualToString:@"Service resource not found"])
                {
                    response.error = NSLocalizedString(@"Group not found", @"GroupNotFound");
                }
            }
            
            [self.delegate getGroupFailure:response];
        }
    }
}

@end

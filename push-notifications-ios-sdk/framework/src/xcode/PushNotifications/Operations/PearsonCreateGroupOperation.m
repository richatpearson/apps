//
//  PearsonCreateGroupOperation.m
//  PushNotifications
//
//  Created by Tomack, Barry on 3/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PearsonCreateGroupOperation.h"
#import "PearsonGetGroupOperation.h"
#import <PearsonAppServicesiOSSDK/PearsonGroup.h>

#import "PearsonOperationHeader.h"

@implementation PearsonCreateGroupOperation

- (id) initWithGroup:(NSString*)group
        authProvider:(NSString*)authProvider
           authToken:(NSString*)authToken
              client:(PearsonDataClient *)dataClient
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
    BOOL createGroup = YES;
    
    if (self.dependencies.count > 0)
    {
        // CreateGroupOp can have a dependency on a GetGroupOp
        for (id dependency in [self dependencies])
        {
            if ([dependency isKindOfClass:[PearsonGetGroupOperation class]])
            {
                PearsonGetGroupOperation* getGroupOp = (PearsonGetGroupOperation*)dependency;
                createGroup = !getGroupOp.success;
            }
        }
    }
    
    if(createGroup)
    {
        if(self.group)
        {
            PearsonClientResponse* response = [self.dataClient createGroup:self.group
                                                                groupTitle:self.group];
            
            if(response.transactionState != kPearsonClientResponsePending)
            {
                [self pearsonClientResponse:response];
            }
        }
        else
        {
            PearsonClientResponse* response = [[PearsonClientResponse alloc] initWithDataClient:self.dataClient];
            response.errorCode = @"100";
            response.errorDescription = [NSString stringWithFormat:@"Unable to create group %@", self.group];
            [self pearsonClientResponse:response];
        }
    }
    else
    {
        // Group Exists
        self.success = YES;
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
        if ([self.delegate respondsToSelector:@selector(createGroupSuccess:)])
        {
            [self.delegate createGroupSuccess:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(createGroupFailure:)])
        {
            [self.delegate createGroupFailure:response];
        }
    }
}

@end

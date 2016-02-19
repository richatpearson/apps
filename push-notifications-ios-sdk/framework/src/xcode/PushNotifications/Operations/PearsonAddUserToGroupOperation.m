//
//  PearsonAddUserToGroupOperation.m
//  PushNotifications
//
//  Created by Tomack, Barry on 3/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PearsonAddUserToGroupOperation.h"
#import "PearsonGetGroupOperation.h"
#import "PearsonCreateGroupOperation.h"

#import "PearsonOperationHeader.h"

@implementation PearsonAddUserToGroupOperation

- (id) initWithUserId:(NSString*)userId
            groupName:(NSString*)groupName
         authProvider:(NSString*)authProvider
            authToken:(NSString*)authToken
               client:(PearsonDataClient *)dataClient
{
    self = [super init];
    if ( self )
    {
        PearsonOperationHeader * opHeaders = [PearsonOperationHeader operationHeadersForAuthProvider:authProvider];
        
        self.userId = userId;
        self.group = groupName;
        self.dataClient = [opHeaders clearPiClientHeaders:dataClient];
        
        [self.dataClient addHTTPHeaderField:opHeaders.authTokenHeader withValue:authToken];
        [self.dataClient addHTTPHeaderField:opHeaders.authProviderHeader withValue:authProvider];
        [self.dataClient addHTTPHeaderField:@"Content-Type" withValue:@"application/json"];
    }
    return self;
}

- (void)main
{
    BOOL groupExists = NO;
    
    if (self.dependencies.count > 0)
    {
        // CreateGroupOp can have a dependency on a GetGroup Op
        for (id dependency in [self dependencies])
        {
            if ([dependency isKindOfClass:[PearsonGetGroupOperation class]])
            {
                PearsonGetGroupOperation* getGroupOp = (PearsonGetGroupOperation*)dependency;
                groupExists = getGroupOp.success;
            }
            if ([dependency isKindOfClass:[PearsonCreateGroupOperation class]])
            {
                PearsonCreateGroupOperation* createGroupOp = (PearsonCreateGroupOperation*)dependency;
                groupExists = createGroupOp.success;
            }
        }
    }
    
    if(groupExists)
    {
        PearsonClientResponse* response = [self.dataClient addUserToGroup:self.userId group:self.group];
        
        // If Asynchronous, then the immediate transaction state will be kPearsonClientResponsePending (2)
        if(response.transactionState != kPearsonClientResponsePending)
        {
            [self pearsonClientResponse:response];
        }
    }
    else
    {
        PearsonClientResponse* response = [[PearsonClientResponse alloc] initWithDataClient:self.dataClient];
        response.errorCode = @"100";
        response.errorDescription = @"Cannot add user to non-existing group.";
        [self pearsonClientResponse:response];
    }
}

- (void) pearsonClientResponse:(PearsonClientResponse *)response
{
    BOOL success = NO;
    
    if (response.completedSuccessfully)
    {
        // The response could be marked as successful but still fail because of authorization verification
        PearsonUser* user= (PearsonUser*)[response firstEntity];
        if(user)
        {
            success = YES;
        }
    }
    
    if(success)
    {
        if ([self.delegate respondsToSelector:@selector(addUserToGroupSuccess:)])
        {
            [self.delegate addUserToGroupSuccess:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(addUserToGroupFailure:)])
        {
            [self.delegate addUserToGroupFailure:response];
        }
    }
}

@end

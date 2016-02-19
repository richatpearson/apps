//
//  PearsonUserRegistrationOperation.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PearsonUserRegistrationOperation.h"
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonUser.h>

#import "PearsonOperationHeader.h"

@implementation PearsonUserRegistrationOperation

- (id) initWithUserId:(NSString *)userId
         authProvider:(NSString*) authProvider
            authToken:(NSString *)authToken
               client:(PearsonDataClient *)dataClient;
{
    self = [super init];
    if ( self )
    {
        PearsonOperationHeader * opHeaders = [PearsonOperationHeader operationHeadersForAuthProvider:authProvider];
        
        self.userId = userId;
        self.dataClient = [opHeaders clearPiClientHeaders:dataClient];
        
        [self.dataClient addHTTPHeaderField:opHeaders.authTokenHeader withValue:authToken];
        [self.dataClient addHTTPHeaderField:opHeaders.authProviderHeader withValue:authProvider];
        [self.dataClient addHTTPHeaderField:@"Content-Type" withValue:@"application/json"];
    }
    return self;
}

- (void)main
{    
    if(self.userId)
    {        
        PearsonClientResponse* response = [self.dataClient addPearsonUser:self.userId];
        
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
        response.errorDescription = @"User does not exist or is null";
        [self pearsonClientResponse:response];
    }
}

- (void) pearsonClientResponse:(PearsonClientResponse *)response
{    
    BOOL success = NO;
    
    if (response.completedSuccessfully)
    {
        // The response could be marked as successful but still fail because of authorization verification
        PearsonUser* currentUser = (PearsonUser*)[response firstEntity];
        if(currentUser)
        {
            success = YES;
        }
    }
    
    if(success)
    {
        if ([self.delegate respondsToSelector:@selector(userDidRegisterWithAppServices:)])
        {
            [self.delegate userDidRegisterWithAppServices:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(userDidFailToRegisterWithAppServices:)])
        {
            [self.delegate userDidFailToRegisterWithAppServices:response];
        }
    }
}

@end

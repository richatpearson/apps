//
//  PearsonDeviceUserConnectionOperaton.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PearsonDeviceUserConnectionOperation.h"
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonDevice.h>

#import "PearsonOperationHeader.h"

@implementation PearsonDeviceUserConnectionOperation

- (id) initWithUserId:(NSString*)userId
         authProvider:(NSString*)authProvider
            authToken:(NSString*)authToken
               client:(PearsonDataClient *)dataClient
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
    PearsonClientResponse* response = [self.dataClient connectEntities:@"users"
                                                           connectorID:self.userId
                                                                  type:@"devices"
                                                           connecteeID:[self.delegate currentDeviceUUID]];
    
    // If Asynchronous, then the immediate transaction state will be kPearsonClientResponsePending (2)
    if(response.transactionState != kPearsonClientResponsePending)
    {
        [self pearsonClientResponse:response];
    }
}

- (void) pearsonClientResponse:(PearsonClientResponse *)response
{    
    BOOL success = NO;
    
    if (response.completedSuccessfully)
    {
        // The response could be marked as successful but still fail because of authorization verification
        PearsonDevice* device = (PearsonDevice*)[response firstEntity];
        if(device)
        {
            success = YES;
        }
    }
    
    if(success)
    {
        if ([self.delegate respondsToSelector:@selector(userDeviceConnectionSuccess:)])
        {
            [self.delegate userDeviceConnectionSuccess:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(userDeviceConnectionFailure:)])
        {
            [self.delegate userDeviceConnectionFailure:response];
        }
    }
}

@end
//
//  PearsonUpdateDeviceEntityOperation.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 2/4/14.
//  Copyright (c) 2014 Apigee. All rights reserved.
//

#import "PearsonUpdateDeviceEntityOperation.h"

#import "PearsonOperationHeader.h"

@implementation PearsonUpdateDeviceEntityOperation

- (id) initWithAuthToken:(NSString *)authToken
            authProvider:(NSString*) authProvider
              dataClient:(PearsonDataClient *)dataClient
{
    self = [super init];
    if ( self )
    {
        PearsonOperationHeader * opHeaders = [PearsonOperationHeader operationHeadersForAuthProvider:authProvider];
        
        self.dataClient = [opHeaders clearPiClientHeaders:dataClient];
        
        [self.dataClient addHTTPHeaderField:opHeaders.authTokenHeader withValue:authToken];
        [self.dataClient addHTTPHeaderField:opHeaders.authProviderHeader withValue:authProvider];
        [self.dataClient addHTTPHeaderField:@"Content-Type" withValue:@"application/json"];
    }
    return self;
}

- (void)main
{
    PearsonDevice* deviceEntity = [self.delegate deviceEntity];
    
    if(deviceEntity)
    {
        PearsonClientResponse* response = [self.dataClient updateEntity:deviceEntity.uuid entity:deviceEntity.properties];
        
        if(response.transactionState != kPearsonClientResponsePending)
        {
            [self pearsonClientResponse:response];
        }
    }
    else
    {
        PearsonClientResponse* response = [[PearsonClientResponse alloc] initWithDataClient:self.dataClient];
        
        response.errorCode = @"100";
        response.errorDescription = @"Device Entity does not exist or is null";
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
        if ([self.delegate respondsToSelector:@selector(deviceEntityUpdateSuccess:)])
        {
            [self.delegate deviceEntityUpdateSuccess:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(deviceEntityUpdateFailure:)])
        {
            [self.delegate deviceEntityUpdateFailure:response];
        }
    }
}

@end

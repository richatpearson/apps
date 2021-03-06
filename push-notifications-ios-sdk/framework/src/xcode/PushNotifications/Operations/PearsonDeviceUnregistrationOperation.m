//
//  PearsonDeviceUnregistrationOperation.m
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "PearsonDeviceUnregistrationOperation.h"
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonDevice.h>

#import "PearsonOperationHeader.h"

@implementation PearsonDeviceUnregistrationOperation

- (id) initWithDeviceToken:(NSData *)deviceToken
                  notifier:(NSString *)notifier
              authProvider:(NSString*) authProvider
                 authToken:(NSString *)authToken
                    client:(PearsonDataClient *)dataClient
{
    self = [super init];
    if ( self )
    {
        PearsonOperationHeader * opHeaders = [PearsonOperationHeader operationHeadersForAuthProvider:authProvider];
        
        self.deviceToken = deviceToken;
        self.notifier = notifier;
        self.dataClient = [opHeaders clearPiClientHeaders:dataClient];
        
        [self.dataClient addHTTPHeaderField:opHeaders.authTokenHeader withValue:authToken];
        [self.dataClient addHTTPHeaderField:opHeaders.authProviderHeader withValue:authProvider];
        [self.dataClient addHTTPHeaderField:@"Content-Type" withValue:@"application/json"];
    }
    return self;
}

- (void)main
{    
    if(self.deviceToken)
    {        
        // Passing an empty device token sets the notifier to an empty string.
        // Ex.: "apple.notifer.id"="";
        PearsonClientResponse* response = [self.dataClient setDevicePushToken:[NSData new] forNotifier:self.notifier];
        
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
        if ([self.delegate respondsToSelector:@selector(deviceDidUnregisterWithAppServices:)])
        {
            [self.delegate deviceDidUnregisterWithAppServices:response];
        }
    }
    else
    {
        if ([self.delegate respondsToSelector:@selector(deviceDidFailToUnregisterWithWithAppServices:)])
        {
            [self.delegate deviceDidFailToUnregisterWithWithAppServices:response];
        }
    }
}

@end

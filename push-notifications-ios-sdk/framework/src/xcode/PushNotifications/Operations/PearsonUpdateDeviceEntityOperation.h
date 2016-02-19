//
//  PearsonUpdateDeviceEntityOperation.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 2/4/14.
//  Copyright (c) 2014 Apigee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonDevice.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonUpdateDeviceEntityDelegate <NSObject>
@optional
- (PearsonDevice*) deviceEntity;
- (void) deviceEntityUpdateSuccess:(PearsonClientResponse*)response;
- (void) deviceEntityUpdateFailure:(PearsonClientResponse*)response;
@end

@interface PearsonUpdateDeviceEntityOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, assign) PearsonDataClient* dataClient;

@property (nonatomic, assign) id<PearsonUpdateDeviceEntityDelegate> delegate;

- (id) initWithAuthToken:(NSString *)authToken
            authProvider:(NSString*) authProvider
              dataClient:(PearsonDataClient *)dataClient;

@end

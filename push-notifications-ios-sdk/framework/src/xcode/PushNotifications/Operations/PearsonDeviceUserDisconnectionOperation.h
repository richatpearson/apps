//
//  PearsonDeviceUserDisconnectionOperation.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonDeviceUserDisconnectionDelegate <NSObject>
@optional
- (void) userDeviceDisconnectionSuccess:(PearsonClientResponse*)response;
- (void) userDeviceDisconnectionFailure:(PearsonClientResponse*)response;
@required
- (NSString*) currentUserUUID;
- (NSString*) currentDeviceUUID;
@end

@interface PearsonDeviceUserDisconnectionOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, assign) PearsonDataClient* dataClient;
@property (nonatomic, strong) NSString* userId;

@property (nonatomic, assign) id<PearsonDeviceUserDisconnectionDelegate> delegate;

- (id) initWithUserId:(NSString*)userId
         authProvider:(NSString*)authProvider
            authToken:(NSString*)authToken
               client:(PearsonDataClient *)dataClient;

@end

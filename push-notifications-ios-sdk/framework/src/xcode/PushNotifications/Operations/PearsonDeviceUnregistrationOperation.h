//
//  PearsonDeviceUnregistrationOperation.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonDeviceUnregistrationDelegate <NSObject>
@optional
- (void) deviceDidUnregisterWithAppServices:(PearsonClientResponse*)response;
- (void) deviceDidFailToUnregisterWithWithAppServices:(PearsonClientResponse*)response;
@end

@interface PearsonDeviceUnregistrationOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, assign) PearsonDataClient* dataClient;
@property (nonatomic, assign) NSData* deviceToken;
@property (nonatomic, assign) NSString* notifier;

@property (nonatomic, assign) id<PearsonDeviceUnregistrationDelegate> delegate;

- (id) initWithDeviceToken:(NSData *)deviceToken
                  notifier:(NSString *)notifier
              authProvider:(NSString*) authProvider
                 authToken:(NSString *)authToken
                    client:(PearsonDataClient *)dataClient;

@end

//
//  PearsonUserRegistrationOperation.h
//  PearsonAppServicesiOSSDK
//
//  Created by Tomack, Barry on 9/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>
#import <Foundation/Foundation.h>

@protocol PearsonUserRegistrationDelegate <NSObject>
@optional
- (void) userDidRegisterWithAppServices:(PearsonClientResponse*)response;
- (void) userDidFailToRegisterWithAppServices:(PearsonClientResponse*)response;
@end

@interface PearsonUserRegistrationOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, assign) PearsonDataClient* dataClient;
@property (nonatomic, strong) NSString* userId;

@property (nonatomic, assign) id<PearsonUserRegistrationDelegate> delegate;

- (id) initWithUserId:(NSString *)userId
         authProvider:(NSString*) authProvider
            authToken:(NSString *)authToken
               client:(PearsonDataClient *)dataClient;

@end

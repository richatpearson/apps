//
//  PearsonGetGroupOperation.h
//  PushNotifications
//
//  Created by Tomack, Barry on 3/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonGetGroupDelegate <NSObject>
@optional
- (void) getGroupSuccess:(PearsonClientResponse*)response;
- (void) getGroupFailure:(PearsonClientResponse*)response;
@end

@interface PearsonGetGroupOperation : NSOperation

@property (nonatomic, weak) PearsonDataClient* dataClient;
@property (nonatomic, strong) NSString* group;

@property (nonatomic, assign) BOOL success;

@property (nonatomic, weak) id<PearsonGetGroupDelegate> delegate;

- (id) initWithGroup:(NSString*)group
        authProvider:(NSString*)authProvider
           authToken:(NSString*)authToken
              client:(PearsonDataClient *)dataClient;

@end

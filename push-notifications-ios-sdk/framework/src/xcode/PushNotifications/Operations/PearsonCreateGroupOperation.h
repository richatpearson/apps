//
//  PearsonCreateGroupOperation.h
//  PushNotifications
//
//  Created by Tomack, Barry on 3/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonCreateGroupDelegate <NSObject>
@required
- (BOOL) okToCreateGroups;
@optional
- (void) createGroupSuccess:(PearsonClientResponse*)response;
- (void) createGroupFailure:(PearsonClientResponse*)response;
@end

@interface PearsonCreateGroupOperation : NSOperation

@property (nonatomic, assign) PearsonDataClient* dataClient;
@property (nonatomic, weak) NSString* group;

@property (nonatomic, assign) id<PearsonCreateGroupDelegate> delegate;

@property (nonatomic, assign) BOOL success;

- (id) initWithGroup:(NSString*)group
        authProvider:(NSString*)authProvider
           authToken:(NSString*)authToken
              client:(PearsonDataClient *)dataClient;

@end

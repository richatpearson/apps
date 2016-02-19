//
//  PearsonRemoveUserFromGroupOperation.h
//  PushNotifications
//
//  Created by Tomack, Barry on 3/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonRemoveUserFromGroupDelegate <NSObject>
@optional
- (void) removeUserFromGroupSuccess:(PearsonClientResponse*)response;
- (void) removeUserFromGroupFailure:(PearsonClientResponse*)response;
@end

@interface PearsonRemoveUserFromGroupOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, assign) PearsonDataClient* dataClient;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* group;

@property (nonatomic, assign) id<PearsonRemoveUserFromGroupDelegate> delegate;

- (id) initWithUserId:(NSString*)userId
            groupName:(NSString*)groupName
         authProvider:(NSString*)authProvider
            authToken:(NSString*)authToken
               client:(PearsonDataClient *)dataClient;

@end

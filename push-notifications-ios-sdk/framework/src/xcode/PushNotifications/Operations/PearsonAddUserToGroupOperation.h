//
//  PearsonAddUserToGroupOperation.h
//  PushNotifications
//
//  Created by Tomack, Barry on 3/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <PearsonAppServicesiOSSDK/PearsonDataClient.h>
#import <PearsonAppServicesiOSSDK/PearsonClientResponse.h>
#import <PearsonAppServicesiOSSDK/PearsonClientDelegate.h>

@protocol PearsonAddUserToGroupDelegate <NSObject>
@optional
- (void) addUserToGroupSuccess:(PearsonClientResponse*)response;
- (void) addUserToGroupFailure:(PearsonClientResponse*)response;
@end

@interface PearsonAddUserToGroupOperation : NSOperation <PearsonClientDelegate>

@property (nonatomic, weak) PearsonDataClient* dataClient;
@property (nonatomic, strong) NSString* userId;
@property (nonatomic, strong) NSString* group;

@property (nonatomic, weak) id<PearsonAddUserToGroupDelegate> delegate;

- (id) initWithUserId:(NSString*)userId
            groupName:(NSString*)groupName
         authProvider:(NSString*) authProvider
            authToken:(NSString*)authToken
               client:(PearsonDataClient *)dataClient;

@end

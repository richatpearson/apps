//
//  SeerQueueDBItem.h
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/9/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerServerRequest.h"

@interface SeerQueueDBItem : NSObject

@property (nonatomic, assign) NSInteger queueId;
@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, strong) NSString* requestType;
@property (nonatomic, strong) NSString* payload;
@property (nonatomic, assign) NSTimeInterval requestCreated;
@property (nonatomic, assign) SeerServerRequestStatus requestStatus;

-(instancetype) initSeerQueueDBItemWithQueueId:(NSInteger)queueId
                                     requestId:(NSInteger)requestId
                                   requestType:(NSString*)requestType
                                       payload:(NSString*)payload
                                requestCreated:(NSTimeInterval)createdTimeInterval
                                 requestStatus:(SeerServerRequestStatus)requestStatus;

@end

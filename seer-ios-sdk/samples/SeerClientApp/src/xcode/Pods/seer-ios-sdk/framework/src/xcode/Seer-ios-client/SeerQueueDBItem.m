//
//  SeerQueueDBItem.m
//  Seer-ios-client
//
//  Created by Richard Rosiak on 3/9/15.
//  Copyright (c) 2015 Pearson. All rights reserved.
//

#import "SeerQueueDBItem.h"

@implementation SeerQueueDBItem

-(instancetype) initSeerQueueDBItemWithQueueId:(NSInteger)queueId
                                     requestId:(NSInteger)requestId
                                   requestType:(NSString*)requestType
                                       payload:(NSString*)payload
                                requestCreated:(NSTimeInterval)createdTimeInterval
                                 requestStatus:(SeerServerRequestStatus)requestStatus {
    if (self = [super init])
    {
        self.queueId = queueId;
        self.requestId = requestId;
        self.requestType = requestType;
        self.payload = payload;
        self.requestCreated = createdTimeInterval;
        self.requestStatus = requestStatus;
    }
    
    return self;
}

@end

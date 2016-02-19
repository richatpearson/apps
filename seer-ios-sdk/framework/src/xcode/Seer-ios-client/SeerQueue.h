//
//  SeerQueue.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/21/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerReporter.h"
//#import "SeerServerRequest.h"
#import "SeerEndpoints.h"
#import "SeerQueueDelegate.h"
#import "SeerQueueResponse.h"

#import <sqlite3.h>
#import "SeerDatabaseManager.h"


@interface SeerQueue : NSObject
{
    dispatch_queue_t serialQueueForSeerItems;
    
    dispatch_queue_t batchReportingSerialQueue;
    dispatch_semaphore_t batchReportingSemaphore;
}

extern NSString* const kSEER_ActivityStreamBatch;
extern NSString* const kSEER_TincanBatch;

@property (nonatomic, weak) id <SeerQueueDelegate> delegate;

@property (nonatomic, strong) SeerDatabaseManager *dbManager;

-(void) performSeerQueueSetUp;

- (void) reportQueueWithToken:(NSString*)token
                 forEndpoints:(SeerEndpoints*)endpoints;

- (SeerQueueResponse*) queueSeerServerRequest:(SeerServerRequest*)request
                     removeOldItemsWhenFullDB:(BOOL)removeOldItems;

@end

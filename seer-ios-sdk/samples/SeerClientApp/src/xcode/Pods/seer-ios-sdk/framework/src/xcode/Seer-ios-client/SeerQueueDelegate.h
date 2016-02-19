//
//  SeerClientDelegate.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SeerClientBatchResponse.h"
#import "SeerQueueResponse.h"

@protocol SeerQueueDelegate <NSObject>

- (void) reportQueueRequestBatch:(SeerClientBatchResponse*)seerClientResponse;
- (void) reportQueueRequestComplete:(SeerQueueResponse*)qResponse;

- (NSInteger) bundleSizeLimit;

@end

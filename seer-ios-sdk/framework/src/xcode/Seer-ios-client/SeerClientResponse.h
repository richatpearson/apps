//
//  SeerClientResponse.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeerClientResponse : NSObject

/*!
 Denotes the success (YES) or failure (NO) of the request
 */
@property (nonatomic, assign) BOOL success;

/*!
 The original ID assigned to the request (based on the current session).
 */
@property (nonatomic, assign) NSInteger requestId;

/*!
 The error returned if the request fails.
 */
@property (nonatomic, strong) NSError* error;

/*!
 Regarding the Request Type made to the SeerClient object.<br>
 `kSEER_TokenFetch`<br>
 `kSEER_TincanReport`<br>
 `kSEER_ActivityStreamReport`<br>
 `kSEER_InstrumentationReport`<br>
 `kSEER_RequestStartSession`<br>
 `kSEER_RequestReportQueue`<br>
 `kSEER_RequestResultForQueuedBatch`<br>
 `kSEER_BundleSizeLimit`<br>
 @see SeerClient
 */
@property (nonatomic, strong) NSString* requestType;

/*!
 Indicates if the item was queued (YES) or not (NO).
 */
@property (nonatomic, assign) BOOL queued;

/*!
 Old items that were deleted to make room for new item(s) in case of full DB or full disk
 */
@property (nonatomic, strong) NSArray *deletedOldestQueueItems;

@end

//
//  SeerClientBatchResponse.h
//  Seer-ios-client
//
//  Created by Richard Rosiak on 4/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/*!
 Based on SeerClientResponse Object
 Difference from SeerClientResponse in that it contains an array of request ids.
 */
@interface SeerClientBatchResponse : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSArray* requestIds;
@property (nonatomic, strong) NSError* error;
@property (nonatomic, strong) NSString* requestType;
@property (nonatomic, assign) BOOL queued;

@end

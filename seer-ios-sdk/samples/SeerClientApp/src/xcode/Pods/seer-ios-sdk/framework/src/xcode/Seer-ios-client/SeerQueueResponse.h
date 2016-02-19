//
//  SeerQueueResponse.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 2/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeerQueueResponse : NSObject

@property (nonatomic, assign) BOOL success;
@property (nonatomic, strong) NSError* error;

@property (nonatomic, assign) id object;
@property (nonatomic, strong) NSArray *deletedOldestQueueItems;

@end

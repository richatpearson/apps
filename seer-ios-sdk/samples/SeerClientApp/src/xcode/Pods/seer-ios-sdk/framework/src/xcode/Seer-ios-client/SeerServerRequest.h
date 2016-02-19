//
//  SeerServerRequest.h
//  Seer-ios-client
//
//  Created by Tomack, Barry on 1/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    kServerRequestStatusError = 0,
    kServerRequestStatusFailure,
    kServerRequestStatusPending,
    kServerRequestStatusSuccess
} SeerServerRequestStatus;

@interface SeerServerRequest : NSObject

@property (nonatomic, assign) NSInteger requestId;
@property (nonatomic, strong) NSString* requestType;
@property (nonatomic, strong) NSString* requestJSON;
@property (nonatomic, assign) NSTimeInterval requestCreated;
@property (nonatomic, assign) SeerServerRequestStatus requestStatus;

- (id) payloadAsJSONString:(NSDictionary*) dict;
- (id) payloadAsPrettyJSONString:(NSDictionary*) dict;

@end

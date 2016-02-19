//
//  SessionRequest.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"

typedef enum {
    kRequestStatusPending = 0,
    kRequestStatusFailure,
    kRequestStatusError,
    kRequestStatusSuccess
} SeerRequestStatus;

@interface SessionRequest : NSObject

@property (nonatomic, strong) NSDictionary* jsonDict;
@property (nonatomic, strong) NSString* requestType;
@property (nonatomic, assign) SeerRequestStatus status;
@property (nonatomic, strong) NSNumber* requestId;
@property (nonatomic, assign) BOOL queued;

- (NSString*) objectType;
- (NSString*) displayVerb;

- (NSString*) seerRequestStatusToString:(SeerRequestStatus)statusVal;
- (SeerRequestStatus) seerRequestStatusStringToEnum:(NSString*)strVal;

- (NSString*) getRequestTypeAbbreviation;

@end

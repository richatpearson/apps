//
//  PGMPiTokenRefreshOperation.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiAPIDelegate.h"
#import "PGMPiError.h"
#import "PGMPiToken.h"
#import "PGMPiEnvironment.h"
#import "PGMPiResponse.h"
#import "PGMPiClient.h"
#import "PGMPiOperationConstants.h"

@interface PGMPiTokenRefreshOperation : NSOperation
{
    BOOL _executing_;
    BOOL _finished_;
}

@property (nonatomic, weak) id<PGMPiAPIDelegate> delegate;

@property (nonatomic, strong) NSNumber *requestType;
@property (nonatomic, strong) NSNumber *responseId;

@property (nonatomic, assign) BOOL success;

- (id) initWithClientId:(NSString*)clientId
           clientSecret:(NSString*)clientSecret
               tokenObj:(PGMPiToken*)tokenObj
            environment:(PGMPiEnvironment*)environment
             responseId:(NSNumber*)responseId
            requestType:(NSNumber*)requestType;

@end

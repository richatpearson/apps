//
//  PGMPiTokenOperation.h
//  Pi-ios-client
//

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


@interface PGMPiTokenOperation : NSOperation
{
    BOOL _executing_;
    BOOL _finished_;
}

@property (nonatomic, weak) id<PGMPiAPIDelegate> delegate;

@property (nonatomic, strong) NSNumber *requestType;
@property (nonatomic, strong) NSNumber *responseId;

@property (nonatomic, assign) BOOL success;

- (id) initWithClientId:(NSString*)clientId
            redirectUrl:(NSString*)redirectUrl
               username:(NSString*)username
               password:(NSString*)password
            environment:(PGMPiEnvironment*)environment
             responseId:(NSNumber*)responseId
            requestType:(NSNumber*)requestType;

@end

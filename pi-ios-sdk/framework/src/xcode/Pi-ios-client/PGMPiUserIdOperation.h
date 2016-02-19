//
//  PGMPiUserOperation.h
//  Pi-ios-client
//

//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiAPIDelegate.h"
#import "PGMPiEnvironment.h"

/*!
 Gets the user Id from a credentials call by username
 */

@interface PGMPiUserIdOperation : NSOperation
{
    BOOL _executing_;
    BOOL _finished_;
}

extern NSString* const PMGPiUserIdKey;
extern NSString* const PMGPiDataKey;

@property (nonatomic, weak) id<PGMPiAPIDelegate> delegate;

@property (nonatomic, strong) NSNumber *requestType;
@property (nonatomic, strong) NSNumber *responseId;

@property (nonatomic, assign) BOOL success;

- (id) initWithCredentials:(PGMPiCredentials*)credentials
               environment:(PGMPiEnvironment*)environment
                responseId:(NSNumber*)responseId
               requestType:(NSNumber*)requestType;

@end

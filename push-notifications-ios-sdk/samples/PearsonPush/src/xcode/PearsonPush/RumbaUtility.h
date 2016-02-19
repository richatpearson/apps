//
//  RumbaUtility.h
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "RumbaResponse.h"
#import "RumbaPaths.h"
#import "RumbaTokenFetcher.h"
#import "RumbaUserIdFetcher.h"

#define RUMBA_AUTHENTICATION_SUCCESS @"rumbaAuthenticationSuccess"
#define RUMBA_AUTHENTICATION_FAILURE @"rumbaAuthenticationFailure"

@protocol RumbaUtilityDelegate <NSObject>

- (void) rumbaAuthenticationFailed:(NSError*)error;
- (void) rumbaAuthenticationSuccess:(RumbaResponse*)response;

@end

@interface RumbaUtility : NSObject <RumbaFetcherDelegate>

@property (nonatomic, weak) id <RumbaUtilityDelegate> delegate;


- (void) requestRumbaAuthenticationWithUsername:(NSString*)username
                                       password:(NSString*)password;

- (void) cancelRumbaAuthentication;

- (void) clearRumbaAuthentication;

- (NSString*) authToken;
- (NSString*) userId;

- (void) setTokenPath:(NSString*)tokenPath;
- (void) setIdRetrievalPath:(NSString*)idRetrievalPath;

@end

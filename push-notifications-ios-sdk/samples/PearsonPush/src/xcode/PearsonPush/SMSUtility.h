//
//  SMSUtility.h
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SMSResponse.h"
#import "SMSPaths.h"
#import "SMSFetcher.h"

#define SMS_AUTHENTICATION_SUCCESS @"smsAuthenticationSuccess"
#define SMS_AUTHENTICATION_FAILURE @"smsAuthenticationFailure"

@protocol SMSUtilityDelegate <NSObject>

- (void) smsAuthenticationFailed:(NSError*)error;
- (void) smsAuthenticationSuccess:(SMSResponse *)response;

@end

@interface SMSUtility : NSObject <SMSFetcherDelegate>

@property (nonatomic, weak) id <SMSUtilityDelegate> delegate;


- (void) requestSMSAuthenticationWithUsername:(NSString*)username
                                     password:(NSString*)password;

- (void) cancelSMSAuthentication;

- (void) clearSMSAuthentication;

- (NSString*) authToken;
- (NSString*) userId;

- (void) setAuthenticationPath:(NSString*)authPath;

@end

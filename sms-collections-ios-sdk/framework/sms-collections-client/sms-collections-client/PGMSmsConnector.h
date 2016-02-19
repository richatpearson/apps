//
//  PGMSmsConnector.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsEnvironment.h"
#import "PGMSmsResponse.h"
#import "PGMSmsAuthenticationResponseHandler.h"
#import "PGMSmsUrlSessionFactory.h"
#import "PGMCoreNetworkRequester.h"
#import "PGMSmsSecret.h"
#import "PGMSmsUserProfileParser.h"

typedef void (^SmsRequestComplete) (PGMSmsResponse *);

extern NSString *const PGMSmsSalt;

@interface PGMSmsConnector : NSObject

@property (nonatomic, strong) PGMSmsUrlSessionFactory *urlSessionFactory;
@property (nonatomic, strong) PGMSmsAuthenticationResponseHandler *networkResponseHandler;
@property (nonatomic, strong) PGMCoreNetworkRequester *networkRequester;
@property (nonatomic, strong) PGMSmsUserProfileParser *userProfileParser;

- (instancetype)initWithEnvironment:(PGMSmsEnvironment *)environment;

- (void)runAuthenticationRequestWithUsername:(NSString *)username
                                 andPassword:(NSString *)password
                                  onComplete:(SmsRequestComplete)requestComplete;

/**
This is the second of 2 calls to get Module ID's.  The first is runAuthenticationRequestWithUsername which will 
give us a token.  In most cases client will use a salt value of nil.  If they need to override it they can.
*/
- (void)runObtainModuleIDsRequestWithToken:(NSString *)token
                                   andSalt:(NSString *)salt
                                onComplete:(SmsRequestComplete)requestComplete;

/**
Used by runObtainModuleIDsRequestWithToken to get the NSURLRequest.
*/
- (NSURLRequest *)buildNetworkRequestForModuleIDsWithToken:(NSString *)token
                                                   andSalt:(NSString *)salt;


@end


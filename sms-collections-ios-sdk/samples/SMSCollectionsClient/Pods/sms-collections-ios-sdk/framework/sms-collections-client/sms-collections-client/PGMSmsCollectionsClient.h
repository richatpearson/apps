//
//  PGMSmsCollectionsClient.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMSmsEnvironment.h"
#import "PGMSmsConnector.h"

@interface PGMSmsCollectionsClient : NSObject

@property (nonatomic, strong) PGMSmsConnector *connector;

- (instancetype)initWithEnvironment:(PGMSmsEnvironment *)environment;

/** The entry point into this framework.  It is the login.  It executes a client app completion handler. */
- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               onComplete:(SmsRequestComplete)requestComplete;


/** Gets the module ID's after we are logged in. */
- (void)obtainModuleIDsForToken:(NSString *)token
                           salt:(NSString *)salt
                     onComplete:(SmsRequestComplete)requestComplete;


@end

//
//  PGMSmsError.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, PGMSmsClientErrorCode)
{
    PGMSmsAuthenticationError       = 0,
    PGMSmsNetworkCallError          = 1,
    PGMSmsDenySubscriptionError     = 2,
    PGMSmsMissingCredentialsError   = 3,
    PGMSmsMissingTokenError         = 4,
    PGMSmsMissingSiteIdError        = 5,
    PGMSmsTokenShorterThan8Error    = 6
};

extern NSString * const PGMErrorDomain;

@interface PGMSmsError : NSObject

+ (NSError *)createErrorForErrorCode:(PGMSmsClientErrorCode)errorCode andDescription:(NSString *)errorDescription;

@end

//
//  PGMSmsCollectionsClient.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/1/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsCollectionsClient.h"
#import "NSString+MD5.h"
#import "PGMSmsError.h"

@interface PGMSmsCollectionsClient ()

@property (nonatomic, strong) PGMSmsEnvironment *environment;
@property (nonatomic, assign) PGMSmsClientErrorCode errorCdoe;

@end

@implementation PGMSmsCollectionsClient

- (instancetype)initWithEnvironment:(PGMSmsEnvironment *)environment
{
    if (self = [super init])
    {
        self.environment = environment;
    }
    return self;
}

- (PGMSmsConnector *)connector
{
    if (!_connector)
    {
        _connector = [[PGMSmsConnector alloc] initWithEnvironment:self.environment];
    }
    return _connector;
}

- (void)loginWithUsername:(NSString *)username
                 password:(NSString *)password
               onComplete:(SmsRequestComplete)requestComplete
{
    if (![self hasUsername:username password:password]) {
        PGMSmsResponse *response = [PGMSmsResponse new];
        response.error = [PGMSmsError createErrorForErrorCode:PGMSmsMissingCredentialsError
                                               andDescription:@"App must provide both username and password."];
        requestComplete(response);
        return;
    }
    
    [self.connector runAuthenticationRequestWithUsername:username andPassword:password onComplete:requestComplete];
}

-(BOOL) hasUsername:(NSString*)username
           password:(NSString*)password {
    
    return (username && ![username isEqualToString:@""] && password && ![password isEqualToString:@""]);
}

- (void)obtainModuleIDsForToken:(NSString *)token
                           salt:(NSString *)salt
                     onComplete:(SmsRequestComplete)requestComplete {
    
    if (![self hasToken:token]) {
        PGMSmsResponse *response = [PGMSmsResponse new];
        response.error = [PGMSmsError createErrorForErrorCode:self.errorCdoe
                                               andDescription:@"App must provide token which is at least 8 chars in length."];
        requestComplete(response);
        return;
    }
    
    [self.connector runObtainModuleIDsRequestWithToken:token andSalt:salt onComplete:requestComplete];
}

-(BOOL) hasToken:(NSString*)token {
    BOOL result = true;
    
    if (!token || [token isEqualToString:@""]) {
        self.errorCdoe = PGMSmsMissingTokenError;
        return false;
    }
    
    NSLog(@"Token length is %lu", (unsigned long)[token length]);
    if ([token length] < 8) {
        self.errorCdoe = PGMSmsTokenShorterThan8Error;
        return false;
    }
    
    return result;
}

@end



















//
//  SMSUtility.m
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SMSUtility.h"

@interface SMSUtility()

@property (nonatomic, strong) SMSResponse* response;
@property (nonatomic, strong) SMSPaths* paths;
@property (nonatomic, weak) SMSFetcher* currentFetcher;

@end

@implementation SMSUtility

- (id) init
{
    if(self = [super init])
    {
        self.response = [[SMSResponse alloc] init];
        self.paths = [[SMSPaths alloc] init];
        
    }
    return self;
}

- (void) requestSMSAuthenticationWithUsername:(NSString*)username
                                     password:(NSString*)password
{
    [self requestAuthenticationWithUsername:username
                                   password:password];
}

- (void) requestAuthenticationWithUsername:(NSString*)username
                                  password:(NSString*)password
{
#if __has_feature(objc_arc)
    SMSFetcher *authFetcher = [[SMSFetcher alloc] initWithAuthPath:self.paths.authPath];
#else
    SMSFetcher* authFetcher = [[[SMSFetcher alloc] initWithAuthPath:self.paths.authPath] autorelease];
#endif
    authFetcher.delegate = self;
    [authFetcher fetchTokenWithUsername:username
                               password:password];
    
    self.currentFetcher = authFetcher;
}

#pragma mark SMSFetcherDelegate

- (void) smsResponseWithReturnData:(NSDictionary*)fetchedData
                             error:(NSError*)error
{
    if (error)
    {
        [self smsRequestFailure:error];
    }
    else
    {
        [self.response setAuthToken:[fetchedData objectForKey:SMSFetchAuthTokenKey]];
        [self.response setUserID:[fetchedData objectForKey:SMSFetchUserIDKey]];
        [self smsRequestSuccess];
    }
}


- (void) cancelSMSAuthentication
{
    if(self.currentFetcher)
    {
        if([self.currentFetcher respondsToSelector:@selector(cancelFetch)])
        {
            [self.currentFetcher cancelFetch];
        }
    }
}

- (void) clearSMSAuthentication
{
    [self.response clear];
}

- (NSString*) authToken
{
    return [self.response authToken];
}

- (NSString*) userId
{
    return [self.response userId];
}

- (void) setAuthenticationPath:(NSString*)authPath
{
    self.paths.authPath = authPath;
}

- (void) smsRequestSuccess
{
    if(self.delegate)
    {
        [self.delegate smsAuthenticationSuccess:self.response];
    }
    [self dispatchNotificationForEvent:SMS_AUTHENTICATION_SUCCESS object:self.response];
}

- (void) smsRequestFailure:(NSError*)error
{
    if(self.delegate)
    {
        [self.delegate smsAuthenticationFailed:error];
    }
    [self dispatchNotificationForEvent:SMS_AUTHENTICATION_FAILURE object:error];
}

- (void) dispatchNotificationForEvent:(NSString*)event object:(NSObject*)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:event object:obj];
    });
}

@end

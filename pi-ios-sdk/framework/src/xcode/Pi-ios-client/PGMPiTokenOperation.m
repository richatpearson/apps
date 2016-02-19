//
//  PGMPiTokenOperation.m
//  Pi-ios-client
//

//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiTokenOperation.h"

@interface PGMPiTokenOperation ()

@property (nonatomic, strong) NSString* clientId;
@property (nonatomic, strong) NSString* redirectUrl;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) PGMPiEnvironment *environment;

@property (nonatomic, strong) NSMutableData* responseData;

@end

@implementation PGMPiTokenOperation

- (id) initWithClientId:(NSString*)clientId
            redirectUrl:(NSString *)redirectUrl
               username:(NSString*)username
               password:(NSString*)password
            environment:(PGMPiEnvironment*)environment
             responseId:(NSNumber*)responseId
            requestType:(NSNumber*)requestType
{
    self = [super init];
    if (self)
    {
        _executing_ = NO;
        _finished_ = NO;
        
        self.clientId = clientId;
        self.redirectUrl = redirectUrl;
        self.username = username;
        self.password = password;
        self.environment = environment;
        self.responseId = responseId;
        self.requestType = requestType;
        
        self.success = NO;
    }
    return self;
}

- (BOOL)isConcurrent
{
    return YES;
}

- (BOOL)isExecuting
{
    return _executing_;
}

- (BOOL)isFinished
{
    return _finished_;
}

- (void)start
{
    if (![NSThread isMainThread])
    {
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if ([self isCancelled] || _finished_)
    {
        [self willChangeValueForKey:@"isFinished"];
        _finished_ = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    _executing_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
    NSMutableString *postString = [NSMutableString stringWithFormat:@"%@=%@", PGMPiUsernameKey, self.username];
    [postString appendFormat:@"&%@=%@", PGMPiPasswordKey, self.password];
    [postString appendFormat:@"&%@=%@", PGMPiLoginSuccessUrlKey, self.environment.loginSuccessUrl];
    [postString appendFormat:@"&%@=%@", PGMPiRedirectUrlKey, self.redirectUrl];
    [postString appendFormat:@"&%@=%@", PGMPiResponseTypeKey, self.environment.responseType];
    [postString appendFormat:@"&%@=%@", PGMPiScopeKey, self.environment.scope];
    [postString appendFormat:@"&%@=%@", PGMPiClientIdKey, self.clientId];
    NSLog(@"postString: %@", postString);
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    NSLog(@"Login to this url: %@", [self.environment piLoginPath]);
    NSURL* url = [NSURL URLWithString:[self.environment piLoginPath]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    [request setTimeoutInterval:15.0];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
//    NSLog(@"TokenOperation connection: %@", connection);
    if (connection == nil)
    {
//        NSLog(@"CAN't establish a connection");
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Cannot establish a network connection", @"Cannot establish a network connection")
                       forKey:NSLocalizedDescriptionKey];
        
        [self.delegate tokenOpCompleteWithToken:nil
                                          error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail]
                                     responseId:self.responseId
                                    requestType:self.requestType];
        
        [self markAsComplete];
    }
}

- (void) markAsComplete
{
//    NSLog(@"PiTokenComplete");
    [self willChangeValueForKey:@"isExecuting"];
    [self willChangeValueForKey:@"isFinished"];
    _executing_ = NO;
    _finished_ = YES;
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    if([self isCancelled])
    {
        [self markAsComplete];
		return;
    }
    
    self.responseData = [NSMutableData data];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
//    NSLog(@"Token Operation: connection didFailWithError: %@", error);
    [self.delegate tokenOpCompleteWithToken:nil
                                      error:error
                                 responseId:self.responseId
                                requestType:self.requestType];
    [self markAsComplete];
}

/**
 Example of Successful Data Retrieved
 {
    "access_token":"IfpP3bjVoL4jnGFvreprBGSHdGlv",
    "refresh_token":"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN",
    "expires_in":"1799"
 }
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSLog(@"RESPONSE DATA: %@", self.responseData);
    
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&jsonError];
    NSLog(@"connectionDidFinishLoading: %@:::error: %@", jsonDict, jsonError);
    
    if( jsonError )
    {
        if (jsonError.code == 3840)
        {
            NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
            [errorDetail setValue:NSLocalizedString(@"The operation couldn’t be completed. Please check username and password.", @"The operation couldn’t be completed. Please check username and password.")
                           forKey:NSLocalizedDescriptionKey];
        }
        [self.delegate tokenOpCompleteWithToken:nil
                                          error:jsonError
                                     responseId:self.responseId
                                    requestType:self.requestType];
    }
    else
    {
        if ([jsonDict objectForKey:PGMPiConsentRedirectCode])
        {
            // Consent Redirect
            if ([[jsonDict objectForKey:PGMPiConsentRedirectCode] isEqualToString:PGMPiConsentRedirectText])
            {
                if (![jsonDict objectForKey:@"message"] || [[jsonDict objectForKey:@"message"] isEqualToString:@""]) {
                    
                    NSString *errorDesc = [NSString stringWithFormat:@"Consent ticket not found for error: %@", PGMPiConsentRedirectText];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:NSLocalizedString(errorDesc, @"Consent ticket not found")
                                   forKey:NSLocalizedDescriptionKey];
                    
                    [self.delegate tokenOpCompleteWithEscrowTicket:nil
                                                             error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail]
                                                        responseId:self.responseId
                                                       requestType:self.requestType];
                }
                else {
                    //NSLog(@"User missing consent");
                    NSString *errorDesc = [NSString stringWithFormat:@"Missing Consent: %@", PGMPiConsentRedirectText];
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:NSLocalizedString(errorDesc, @"Missing Consent")
                                   forKey:NSLocalizedDescriptionKey];
                    
                    [self.delegate tokenOpCompleteWithEscrowTicket:[jsonDict objectForKey:@"message"]
                                                             error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiNoConsentError userInfo:errorDetail]
                                                        responseId:self.responseId
                                                       requestType:self.requestType];
                }
            }
            if ([[jsonDict objectForKey:PGMPiConsentRedirectCode] isEqualToString:PGMPiConsentErrorText]) //user failed to express consent at least 10 times
            {
                NSString *errorDesc = [NSString stringWithFormat:@"Consent Error: %@. Please contact your System Administrator", PGMPiConsentErrorText];
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:NSLocalizedString(errorDesc, @"Consent Error")
                               forKey:NSLocalizedDescriptionKey];
                
                [self.delegate tokenOpCompleteWithToken:nil
                                                  error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiRefuseConsentError userInfo:errorDetail]
                                             responseId:self.responseId
                                            requestType:self.requestType];
            }
        }
        else
        {
            NSString* accessToken = [jsonDict objectForKey:PGMPiAccessTokenKey];
            NSLog(@"access token is: %@", accessToken);
            NSString* refreshToken = [jsonDict objectForKey:PGMPiRefreshTokenKey];
            NSUInteger expiresIn = (NSUInteger)[[jsonDict objectForKey:PGMPiExpireKey] integerValue];
            
            if( !accessToken || [accessToken isEqualToString:@""] )
            {
                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                [errorDetail setValue:NSLocalizedString(@"Empty access token returned", @"Empty access token returned")
                               forKey:NSLocalizedDescriptionKey];
                
                [self.delegate tokenOpCompleteWithToken:nil
                                                  error:[NSError errorWithDomain:PGMPiErrorDomain code:PGMPiTokenError userInfo:errorDetail]
                                             responseId:self.responseId
                                            requestType:self.requestType];
            }
            else
            {
                self.success = YES;
                PGMPiToken *piToken = [[PGMPiToken alloc] initWithAccessToken:accessToken
                                                                 refreshToken:refreshToken
                                                                    expiresIn:expiresIn];
                [self.delegate tokenOpCompleteWithToken:piToken
                                                  error:nil
                                             responseId:self.responseId
                                            requestType:self.requestType];
            }
        }
    }
    
    [self markAsComplete];
}

@end

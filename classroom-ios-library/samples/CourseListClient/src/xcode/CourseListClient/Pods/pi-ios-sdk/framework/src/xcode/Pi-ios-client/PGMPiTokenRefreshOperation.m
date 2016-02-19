//
//  PGMPiTokenRefreshOperation.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiTokenRefreshOperation.h"

@interface PGMPiTokenRefreshOperation()

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) PGMPiToken *tokenObj;
@property (nonatomic, strong) PGMPiEnvironment *environment;

@property (nonatomic, strong) NSMutableData *responseData;

@end

@implementation PGMPiTokenRefreshOperation

- (id) initWithClientId:(NSString*)clientId
           clientSecret:(NSString*)clientSecret
               tokenObj:(PGMPiToken*)tokenObj
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
        self.clientSecret = clientSecret;
        self.tokenObj = tokenObj;
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
    
    NSString *clientCreds = [NSString stringWithFormat:@"%@:%@", self.clientId, self.clientSecret];
    
    NSString *authString = @"";
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        authString = [self AFBase64EncodedStringFromString:clientCreds];
    }
    else
    {
        authString = [[clientCreds dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    }
    
    authString = [NSString stringWithFormat:@"Basic %@", authString];
    
    NSMutableString *postString = [NSMutableString stringWithFormat:@"%@=%@", PGMPiGrantTypeKey, PGMPiRefreshTokenKey];
    [postString appendFormat:@"&%@=%@", PGMPiRefreshTokenKey, self.tokenObj.refreshToken];
    
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    NSURL* url = [NSURL URLWithString:[self.environment piRefreshPath]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:authString forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection == nil)
    {
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
//    NSLog(@"PiTokenRefreshComplete");
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
    [self.delegate tokenOpCompleteWithToken:nil
                                      error:error
                                 responseId:self.responseId
                                requestType:self.requestType];
    [self markAsComplete];
}

/**
 Example of Data Retrieved
 {
 "access_token":"IfpP3bjVoL4jnGFvreprBGSHdGlv",
 "refresh_token":"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN",
 "expires_in":"1799"
 }
 */
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&jsonError];
//    NSLog(@"tokenRefreshOperation connectionDidFinishLoading: %@", jsonDict);
    NSString* accessToken = [jsonDict objectForKey:PGMPiAccessTokenKey];
    NSString* refreshToken = [jsonDict objectForKey:PGMPiRefreshTokenKey];
    NSUInteger expiresIn = (NSUInteger)[[jsonDict objectForKey:PGMPiExpireKey] integerValue];
    
    if( jsonError )
    {
        [self.delegate tokenRefreshOpCompleteWithToken:nil
                                                 error:jsonError
                                            responseId:self.responseId
                                           requestType:self.requestType];
    }
    if( !accessToken || [accessToken isEqualToString:@""] )
    {
        NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
        [errorDetail setValue:NSLocalizedString(@"Empty access token returned", @"Empty access token returned")
                       forKey:NSLocalizedDescriptionKey];
        [self.delegate tokenRefreshOpCompleteWithToken:nil
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
//        NSLog(@"Refresh PiToken: %@", piToken);
        [self.delegate tokenRefreshOpCompleteWithToken:piToken
                                                 error:nil
                                            responseId:self.responseId
                                           requestType:self.requestType];
    }
    
    [self markAsComplete];
}

- (NSString*) AFBase64EncodedStringFromString:(NSString*)string
{
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string length]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

@end

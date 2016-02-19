//
//  SMSFetcher.m
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SMSFetcher.h"

@interface SMSFetcher()

@property (nonatomic, weak) NSString* provider;
@property (nonatomic, strong) NSHTTPURLResponse* httpResponse;

@end

@implementation SMSFetcher

- (id) initWithAuthPath:(NSString*)authPath
{
    if(self = [super init])
    {
        self.authPath = authPath;
        self.provider = @"sms";
    }
    
    return self;
}

- (void) fetchTokenWithUsername:(NSString *)username
                       password:(NSString *)password
{
    NSURL* authURL = [NSURL URLWithString:self.authPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:authURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    NSString* requestBody = [self createSMSAuthenticationRequestBodyWtihUsername:username password:password];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:[requestBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if ( !self.connection )
    {
        if([self.delegate respondsToSelector:@selector(smsResponseWithReturnData:error:)])
        {
            [self smsFetchErrorMessage:@"SMS Utility unable to initiate connection for auth token retrieval."
                             errorCode:600];
            
            [self.delegate smsResponseWithReturnData:nil
                                               error:self.error];
        }
    }
}

-(NSString*) createSMSAuthenticationRequestBodyWtihUsername:(NSString *)username
                                                   password:(NSString *)password
{
    NSMutableDictionary *payloadDict = [NSMutableDictionary dictionary];
    [payloadDict setObject:self.provider forKey:@"provider"];
    [payloadDict setObject:username forKey:@"username"];
    [payloadDict setObject:password forKey:@"password"];
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payloadDict
                                                       options:0
                                                         error:&error];

    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark Delegate Methods for NSURLConnection

-(NSURLRequest *)connection:(NSURLConnection *)connection
            willSendRequest:(NSURLRequest *)request
           redirectResponse:(NSURLResponse *)redirectResponse
{
    NSURLRequest *newRequest = request;
    if (redirectResponse)
    {
        newRequest = nil;
    }
    return newRequest;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpResponse = (NSHTTPURLResponse*)response;
    
    if(!self.responseData)
    {
        self.responseData = [NSMutableData new];
    }
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(smsResponseWithReturnData:error:)])
    {
        [self.delegate smsResponseWithReturnData:nil
                                           error:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&jsonError];
    
    NSUInteger httpStatusCode = [self.httpResponse statusCode];
    NSString *authToken = [jsonDict objectForKey:SMSFetchAuthTokenKey];
    
    if (httpStatusCode == 200 && authToken && !([authToken isEqualToString:@""]))
    {
        if([self.delegate respondsToSelector:@selector(smsResponseWithReturnData:error:)])
        {
            [self.delegate smsResponseWithReturnData:jsonDict
                                               error:nil];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(smsResponseWithReturnData:error:)])
        {
            [self smsFetchErrorMessage:@"SMS Utility Auth token Fetch did not receive expected data."
                                   errorCode:httpStatusCode];
            
            [self.delegate smsResponseWithReturnData:nil
                                               error:self.error];
        }
    }
}

- (void) smsFetchErrorMessage:(NSString*)errorStr
                    errorCode:(NSUInteger)code
{
    NSMutableDictionary* errorDetails = [NSMutableDictionary dictionary];
    [errorDetails setValue:errorStr forKey:NSLocalizedDescriptionKey];
    
    self.error = [[NSError alloc] initWithDomain:@"smsAuthFetch"
                                            code:code
                                        userInfo:errorDetails];
}

- (void) cancelFetch
{
    [self.connection cancel];
}

@end

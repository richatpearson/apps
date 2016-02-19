//
//  SeerTokenFetcher.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerTokenFetcher.h"
#import "SeerUtility.h"
#import "SeerClientErrors.h"

@interface SeerTokenFetcher ()

@property (nonatomic, strong) NSString* urlString;
@property (nonatomic, strong) NSString* grantType;

@property (nonatomic, strong) NSMutableData* responseData;
@property (nonatomic, strong) NSURLConnection* connection;

@property (nonatomic, assign) NSInteger requestId;

@end

@implementation SeerTokenFetcher

- (id) initWithUrlString:(NSString *)urlString
{
    self = [super init];
    
    if(self)
    {
        self.urlString = urlString;
        self.grantType  = @"client_credentials";
    }
    
    return self;
}

- (void) fetchTokenWithClientId:(NSString*)clientId
                   clientSecret:(NSString*)clientSecret
                      requestId:(NSInteger)requestId
                   onCompletion:(SeerTokenFetcherBlock)completion
{
    self.requestId = requestId;
    
    NSURL* tokenURL = [NSURL URLWithString:self.urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenURL
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSString* basicAuthCredentials = [NSString stringWithFormat:@"%@:%@", clientId, clientSecret];
    NSString* base64EncodedCreds = [NSString stringWithFormat:@"Basic %@", [SeerUtility AFBase64EncodedStringFromString:basicAuthCredentials]];
    
    [request setValue:base64EncodedCreds forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    
    NSString *postString = [NSString stringWithFormat:@"grant_type=%@",self.grantType];
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue currentQueue]
                           completionHandler:
     ^(NSURLResponse *response, NSData *data, NSError *error) {
         if (data) {
             NSError *jsonError = nil;
             NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
             
             NSString* accessToken = nil;
             
             if (jsonDict) {
                 accessToken = [jsonDict objectForKey:@"access_token"];
             }
             
             if( accessToken && !([accessToken isEqualToString:@""]) )
             {
                 SeerTokenResponse* tokenResponse = [SeerTokenResponse new];
                 tokenResponse.accessToken = accessToken;
                 tokenResponse.expirationDate = [NSString stringWithFormat:@"%@", [jsonDict objectForKey:@"expiration_date"]];
                 tokenResponse.tokenType = @"Bearer"; //[jsonDict objectForKey:@"token_type"];
                 NSLog(@"TOKEN EXPIRATION: %@", tokenResponse.expirationDate);
                 
                 completion(tokenResponse, nil);
             }
             else {
                 NSError* err = [self tokenFetchErrorMessage:@"Seer Token Fetch did not receive expected data."];
                 completion(nil, err);
             }
         }
         else {
             completion(nil, error);
         }
     }];
}

- (NSError*) tokenFetchErrorMessage:(NSString*)errorStr
{
    NSError* error = [[NSError alloc] initWithDomain:kSEER_ErrorDomain
                                                code:SeerTokenFetch
                                            userInfo:@{NSLocalizedDescriptionKey:errorStr}];
    return error;
}


@end

//
//  RumbaTokenFetcher.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaTokenFetcher.h"

@interface RumbaTokenFetcher()

@property (nonatomic, strong) NSHTTPURLResponse* httpResponse;

@end

@implementation RumbaTokenFetcher

- (id) initWithDelegate:(id<RumbaFetcherDelegate>)delegate
              tokenPath:(NSString*)tokenPath
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.tokenPath = tokenPath;
        
        self.fetchType  = Rumba_Token_Fetch;
    }
    return self;
}

- (void) fetchTokenWithUsername:username
                       password:password
{
    NSString* urlString = [NSString stringWithFormat:self.tokenPath,username,password];
    
    NSURL* url = [NSURL URLWithString:urlString];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    
    [request setHTTPMethod:@"GET"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if ( !self.connection )
    {
        // failed to connect
        [self rumbaFetchErrorMessage:@"RumbaUtility unable to initiate connection for token retrieval."
                           errorCode:600];
        
        if ([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
        {
            [self.delegate rumbaResponseForFetchType:self.fetchType
                                          returnData:nil
                                               error:self.error];
        }
    }
}

#pragma mark Delegate Methods for NSURLConnection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.httpResponse = (NSHTTPURLResponse*)response;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // Append the new data to receivedData.
    // receivedData is an instance variable declared elsewhere.
    if(!self.responseData)
    {
        self.responseData = [NSMutableData new];
    }
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
    {
        [self.delegate rumbaResponseForFetchType:self.fetchType
                                      returnData:nil
                                           error:error];
    }
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:self.responseData options:kNilOptions error:&jsonError];
    NSLog(@"RumbaTokenFetcher connectionDidFinishLoading: %@", jsonDict);
    NSString* auth_token = [jsonDict objectForKey:RumbaFetchTokenKey];
    
    NSUInteger code = [self.httpResponse statusCode];
    if(!code)
    {
        code = 600;
    }
    
    if( auth_token && !([auth_token isEqualToString:@""]) )
    {
        if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
        {
            [self.delegate rumbaResponseForFetchType:self.fetchType
                                          returnData:jsonDict
                                               error:nil];
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
        {
            [self rumbaFetchErrorMessage:@"Rumba Utility Token Fetch did not receive expected data."
                               errorCode:code];
            
            [self.delegate rumbaResponseForFetchType:self.fetchType
                                          returnData:nil
                                               error:self.error];
        }
    }
}

@end

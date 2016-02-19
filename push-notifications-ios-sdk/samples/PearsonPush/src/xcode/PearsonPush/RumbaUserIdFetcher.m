//
//  RumbaUserIdFetcher.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaUserIdFetcher.h"

@interface RumbaUserIdFetcher ()

@property (nonatomic, strong) NSHTTPURLResponse* httpResponse;

@end

@implementation RumbaUserIdFetcher

- (id) initWithDelegate:(id<RumbaFetcherDelegate>)delegate
             userIdPath:(NSString*)idPath
{
    if(self = [super init])
    {
        self.delegate = delegate;
        self.userIdPath = idPath;
        
        self.fetchType  = Rumba_UserId_Fetch;
    }
    return self;
}

- (void) fetchUserIdWithAuthToken:(NSString*)token
{
    NSURL* url = [NSURL URLWithString:self.userIdPath];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:10.0];
    NSLog(@"Rumba fetchUserIdWithAuthToken: %@", token);
    [request setHTTPMethod:@"GET"];
    [request setValue:token forHTTPHeaderField:@"auth_token"];
    
    self.connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    
    if ( !self.connection )
    {
        // failed to connect
        [self rumbaFetchErrorMessage:@"Rumba User Id Utility unable to initiate connection for token retrieval."
                           errorCode:600];
        
        if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
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
    NSLog(@"RumbaUserIdFetcher didFinishLoading: %@", jsonDict);
    
    NSUInteger code = [self.httpResponse statusCode];
    if(!code)
    {
        code = 600;
    }
    
    if(code == 200)
    {
        NSString* userId = [jsonDict objectForKey:@"user_id"];
        if(userId)
        {            
            if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
            {
                NSDictionary* responseDict = @{RumbaFetchUserIDKey:userId};
                [self.delegate rumbaResponseForFetchType:self.fetchType
                                              returnData:responseDict
                                                   error:nil];
            }
        }
    }
    else
    {
        if([self.delegate respondsToSelector:@selector(rumbaResponseForFetchType:returnData:error:)])
        {
            [self rumbaFetchErrorMessage:@"Rumba Utility User Id Fetch did not receive expected data format."
                               errorCode:code];
            
            [self.delegate rumbaResponseForFetchType:self.fetchType
                                          returnData:nil
                                               error:self.error];
        }
    }
}


@end

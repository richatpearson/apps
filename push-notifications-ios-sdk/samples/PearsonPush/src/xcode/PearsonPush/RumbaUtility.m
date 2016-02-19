//
//  RumbaUtility.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaUtility.h"
#import "RumbatokenFetcher.h"
#import "RumbaUserIdFetcher.h"

@interface RumbaUtility()

@property (nonatomic, strong) RumbaResponse* response;
@property (nonatomic, strong) RumbaPaths* paths;
@property (nonatomic, weak) RumbaFetcher* currentFetcher;

@end

@implementation RumbaUtility

- (id) init
{
    if(self = [super init])
    {
        self.response = [RumbaResponse new];
        self.paths = [RumbaPaths new];
        
    }
    NSLog(@"Rumba Utility Initialized");
    return self;
}

// Step 1
- (void) requestRumbaAuthenticationWithUsername:(NSString*)username
                                       password:(NSString*)password
{
    NSLog(@"RumbaUtility requestAuthenticationCode");

    RumbaTokenFetcher* tokenFetcher = [[RumbaTokenFetcher alloc] initWithDelegate:self
                                                                        tokenPath:self.paths.tokenPath];
    [tokenFetcher fetchTokenWithUsername:username
                                password:password];
    
    self.currentFetcher = tokenFetcher;
}

// Step 2
- (void) requestUserId
{
    NSLog(@"RumbaUtility requestUserId");
    RumbaUserIdFetcher* userIdFetcher = [[RumbaUserIdFetcher alloc] initWithDelegate:self
                                                                          userIdPath:self.paths.idPath];
    [userIdFetcher fetchUserIdWithAuthToken: [self.response authToken]];
    
    self.currentFetcher = userIdFetcher;
}

- (void) rumbaResponseForFetchType:(NSInteger) type
                        returnData:(NSDictionary*)fetchedData
                             error:(NSError*)error
{
    if (error)
    {
        [self rumbaRequestFailure:error];
    }
    else
    {
        if( [fetchedData objectForKey:RumbaFetchTokenKey] )
        {
            NSLog(@"RumbaUtility response for TokenFetch: %@", fetchedData);
            NSString* token = [fetchedData objectForKey:RumbaFetchTokenKey];
            
            [self.response setAuthToken:token];
            
            NSLog(@"RumbaUtility token: %@ ::: responseToken: %@", token, [self.response authToken]);
            [self requestUserId];
        }
        if( [fetchedData objectForKey:RumbaFetchUserIDKey] )
        {
            [self.response setUserID:[fetchedData objectForKey:RumbaFetchUserIDKey]];
            [self rumbaRequestSuccess];
        }
    }
}

- (void) rumbaRequestSuccess
{
    if(self.delegate)
    {
        [self.delegate rumbaAuthenticationSuccess:self.response];
    }
    [self dispatchNotificationForEvent:RUMBA_AUTHENTICATION_SUCCESS object:self.response];
}

- (void) rumbaRequestFailure:(NSError*)error
{
    if(self.delegate)
    {
        [self.delegate rumbaAuthenticationFailed:error];
    }
    [self dispatchNotificationForEvent:RUMBA_AUTHENTICATION_FAILURE object:error];
}

- (void) dispatchNotificationForEvent:(NSString*)event object:(NSObject*)obj
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [[NSNotificationCenter defaultCenter] postNotificationName:event object:obj];
    });
}


- (void) cancelRumbaAuthentication
{
    
}

- (void) clearRumbaAuthentication
{
    
}

- (NSString*) authToken
{
    return [self.response authToken];
}

- (NSString*) userId
{
    return [self.response userId];
}

- (void) setTokenPath:(NSString*)tokenPath
{
    self.paths.tokenPath = tokenPath;
}

- (void) setIdRetrievalPath:(NSString*)idRetrievalPath
{
    self.paths.idPath = idRetrievalPath;
}

@end

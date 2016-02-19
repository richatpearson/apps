//
//  SMSResponse.m
//  PearsonPush
//
//  Created by Richard Rosiak on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SMSResponse.h"

@interface SMSResponse ()

@property (nonatomic, strong) NSString* wAuthToken;
@property (nonatomic, strong) NSString* wUserId;


@end

@implementation SMSResponse

#pragma mark GETS

- (NSString*) authToken
{
    NSString *token = @"";
    if (self.wAuthToken)
    {
        token = self.wAuthToken;
    }
    
    return token;
}

- (NSString*) userId
{
    NSString *uID = @"";
    if(self.wUserId)
    {
        uID = self.wUserId;
    }
    
    return uID;
}

#pragma mark SETS

- (void) setAuthToken:(NSString*)token
{
    self.wAuthToken = token;
}

- (void) setUserID:(NSString*)userID
{
    self.wUserId = userID;
}

- (void) clear
{
    
}

@end

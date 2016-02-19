//
//  RumbaResponse.m
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "RumbaResponse.h"

@interface RumbaResponse()

@property (nonatomic, strong) NSString* rAuthToken;
@property (nonatomic, strong) NSString* rUserId;

@end

@implementation RumbaResponse

- (NSString*) authToken
{
    return self.rAuthToken;
}

- (NSString*) userId
{
    return self.rUserId;
}

- (void) setAuthToken:(NSString*)token
{
    self.rAuthToken = token;
}
- (void) setUserID:(NSString*)userID
{
    self.rUserId = userID;
}

- (void) clear
{
    self.rAuthToken = @"";
    self.rUserId = @"";
}
@end

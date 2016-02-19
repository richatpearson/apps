//
//  PGMCredentials.m
//  CourseListClient
//
//  Created by Joe Miller on 8/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCredentials.h"

@interface PGMCredentials ()

@property (nonatomic, strong) PGMPiToken *piToken;
@property (nonatomic, strong) PGMPiCredentials *piCredentials;

@end

@implementation PGMCredentials

- (instancetype)initWith:(PGMPiToken *)piToken piCredentials:(PGMPiCredentials *)piCredentials
{
    if (self = [super init])
    {
        self.piToken = piToken;
        self.piCredentials = piCredentials;
    }
    return self;
}

- (NSString *)getUserIdentity
{
    return self.piCredentials.identity.identityId;
}

- (NSString *)getAccessToken
{
    return self.piToken.accessToken;
}

@end

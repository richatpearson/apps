//
//  PGMPiCredentials.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiIdentity.h"

@interface PGMPiCredentials : NSObject <NSCoding>

@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, assign) BOOL resetPassword;

@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) PGMPiIdentity *identity;

+ (instancetype) credentialsWithUsername:(NSString *)username
                                password:(NSString *)password;

@end

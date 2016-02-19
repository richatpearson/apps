//
//  PGMCredentials.h
//  CourseListClient
//
//  Created by Joe Miller on 8/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Pi-ios-client/PGMPiToken.h>
#import <Pi-ios-client/PGMPiCredentials.h>

@interface PGMCredentials : NSObject

- (instancetype)initWith:(PGMPiToken *)piToken piCredentials:(PGMPiCredentials *)piCredentials;
- (NSString *)getUserIdentity;
- (NSString *)getAccessToken;

@end

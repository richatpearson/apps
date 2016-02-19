//
//  AuthResponse.h
//  PearsonCore
//
//  Created by Tomack, Barry on 10/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AuthResponse : NSObject

- (NSString*) authToken;
- (NSString*) userId;
- (NSString*) refreshToken;
- (NSString*) windmill;

- (void) setAuthToken:(NSString*)token;
- (void) setUserID:(NSString*)userID;
- (void) setExpirationTimeInMinutes:(NSUInteger)minutes;
- (void) setRefreshToken:(NSString*)refreshToken;
- (void) setWindmill:(NSString*)windMill;

- (BOOL) isCurrent;

- (void) clear;

@end

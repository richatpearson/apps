//
//  PGMPiToken.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMPiToken : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *accessToken;
@property (nonatomic, readonly) NSString *refreshToken;
@property (nonatomic, readonly, assign) NSInteger expiresIn;
@property (nonatomic, readonly) NSTimeInterval creationDateInterval;

- (id) initWithAccessToken:(NSString*)accessToken
              refreshToken:(NSString*)refreshToken
                 expiresIn:(NSUInteger)expiresIn;

- (id) initWithDictionary:(NSDictionary*)tokenDict;

- (BOOL) isCurrent;

@end

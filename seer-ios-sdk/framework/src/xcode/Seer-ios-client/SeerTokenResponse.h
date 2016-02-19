//
//  SeerTokenResponse.h
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SeerTokenResponse : NSObject

@property (nonatomic, strong) NSString* accessToken;
@property (nonatomic, strong) NSString* expirationDate;
@property (nonatomic, strong) NSString* tokenType;

- (BOOL) isExpired;

- (NSString*) tokenString;

@end

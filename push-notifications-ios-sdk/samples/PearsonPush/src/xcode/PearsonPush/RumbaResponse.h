//
//  RumbaResponse.h
//  PearsonPush
//
//  Created by Tomack, Barry on 3/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RumbaResponse : NSObject

- (NSString*) authToken;
- (NSString*) userId;

- (void) setAuthToken:(NSString*)token;
- (void) setUserID:(NSString*)userID;

- (void) clear;

@end

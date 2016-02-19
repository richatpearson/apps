//
//  PGMPiIdentityProfile.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 5/23/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMPiIdentityProfile : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *identityId;
@property (nonatomic, readonly) NSString *title;
@property (nonatomic, readonly) NSString *givenName;
@property (nonatomic, readonly) NSString *middleName;
@property (nonatomic, readonly) NSString *familyName;
@property (nonatomic, readonly) NSString *suffix;
@property (nonatomic, readonly) NSDictionary *preferences;
@property (nonatomic, readonly) NSArray *emails;

- (id) initWithDictionary:(NSDictionary*)idDict;

@end

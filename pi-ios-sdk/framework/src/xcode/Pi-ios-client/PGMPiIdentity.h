//
//  PGMPiIdentity.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMPiAlternateId.h"


@interface PGMPiIdentity : NSObject <NSCoding>

@property (nonatomic, readonly) NSString* identityId;
@property (nonatomic, readonly) NSString *uri;
@property (nonatomic, readonly) PGMPiAlternateId *alternateId;

- (id) initWithDictionary:(NSDictionary*) idDict;

@end

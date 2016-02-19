//
//  PGMPiAlternateId.h
//  Pi-ios-client
//
//  Created by Tomack, Barry on 6/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMPiAlternateId : NSObject <NSCoding>

@property (nonatomic, readonly) NSString *context;
@property (nonatomic, readonly) NSString *contextId;

- (id) initWithDictionary:(NSDictionary*) dataDict;

@end

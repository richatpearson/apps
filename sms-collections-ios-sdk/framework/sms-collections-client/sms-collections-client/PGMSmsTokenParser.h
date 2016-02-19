//
//  PGMSmsTokenParser.h
//  sms-collections-client
//
//  Created by Joe Miller on 12/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMSmsTokenParser : NSObject

+ (NSString *)parseTokenFromUrl:(NSURL *)url;

@end

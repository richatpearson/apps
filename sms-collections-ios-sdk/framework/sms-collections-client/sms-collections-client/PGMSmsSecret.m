//
//  Secret.m
//  sms-collections-client
//
//  Created by Seals, Morris D on 12/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsSecret.h"

@implementation PGMSmsSecret


+(NSString *)getSecretParameterWithLoginToken:(NSString *)token andSalt:(NSString *) salt {
    
    NSString *secret = nil;
    
    // Check for bad input
    NSComparisonResult comparisonResult = [token caseInsensitiveCompare: @""];
    if ( token == nil || comparisonResult == NSOrderedSame ) {
        return secret;
    }
    
    NSString *shortToken = [token substringWithRange: NSMakeRange(0, 8)];
    
    secret = [NSString stringWithUTF8String:crypt([shortToken UTF8String], [salt UTF8String])];
    
    return secret;
}


@end




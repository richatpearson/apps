//
//  PGMSmsTokenParser.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMSmsTokenParser.h"

@implementation PGMSmsTokenParser

+ (NSString *)parseTokenFromUrl:(NSURL *)url
{
    //NSString *query = [url query];
    //NSRange r = [query rangeOfString:@"="];
    //return [query substringFromIndex:r.location+1];
    
    NSString *tokenResult = @"";
    
    for (NSString *queryString in [url.query componentsSeparatedByString:@"&"]) {
        
        NSString *key = [[queryString componentsSeparatedByString:@"="] objectAtIndex:0];
        NSString *value = [[queryString componentsSeparatedByString:@"="] objectAtIndex:1];
        if ([key isEqualToString:@"key"]) {
            //NSLog(@"Found key in url query string %@", value);
            return value;
        }
    }
    return tokenResult;
}

@end

//
//  NSString+MD5.m
//  sms-collections-client
//
//  Created by Joe Miller on 12/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>
#import "NSString+MD5.h"

@implementation NSString(MD5)

- (NSString *)MD5
{
    const char *utf8Str = [self UTF8String];
    
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(utf8Str, ((CC_LONG)strlen(utf8Str)), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *md5Str = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
    {
        [md5Str appendFormat:@"%02x",md5Buffer[i]];
    }
    
    return md5Str;
}

@end
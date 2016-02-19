//
//  SeerUtility.m
//  Seer-ios-client
//
//  Created by Tomack, Barry on 12/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerUtility.h"

@implementation SeerUtility : NSObject

+ (NSString*) iso8601StringFromDate:(NSDate*)incomingDate
{
    struct tm *timeinfo;
    char buffer[80];
    
    time_t rawtime = (time_t)[incomingDate timeIntervalSince1970];
    timeinfo = gmtime(&rawtime);
    
    strftime(buffer, 80, "%Y-%m-%dT%H:%M:%SZ", timeinfo);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}


+ (NSDate*) iso8601DateFromString:(NSString *)iso8601
{
    // Return nil if nil is given
    if (!iso8601 || [iso8601 isEqual:[NSNull null]])
    {
        return nil;
    }
    
    // Parse number
    if ([iso8601 isKindOfClass:[NSNumber class]])
    {
        return [NSDate dateWithTimeIntervalSince1970:[(NSNumber *)iso8601 doubleValue]];
    }
    
    // Parse string
    else if ([iso8601 isKindOfClass:[NSString class]])
    {
        if (!iso8601)
        {
            return nil;
        }
        
        const char *str = [iso8601 cStringUsingEncoding:NSUTF8StringEncoding];
        char newStr[25];
        
        struct tm tm;
        size_t len = strlen(str);
        if (len == 0)
        {
            return nil;
        }
        
        // UTC
        if (len == 20 && str[len - 1] == 'Z')
        {
            strncpy(newStr, str, len - 1);
            strncpy(newStr + len - 1, "+0000", 5);
        }
        
        //Milliseconds parsing
        else if (len == 24 && str[len - 1] == 'Z')
        {
            strncpy(newStr, str, len - 1);
            strncpy(newStr, str, len - 5);
            strncpy(newStr + len - 5, "+0000", 5);
        }
        
        // Timezone
        else if (len == 25 && str[22] == ':')
        {
            strncpy(newStr, str, 22);
            strncpy(newStr + 22, str + 23, 2);
        }
        
        // Poorly formatted timezone
        else
        {
            strncpy(newStr, str, len > 24 ? 24 : len);
        }
        
        // Add null terminator
        newStr[sizeof(newStr) - 1] = 0;
        
        if (strptime(newStr, "%FT%T%z", &tm) == NULL)
        {
            return nil;
        }
        
        time_t t;
        t = mktime(&tm);
        
        return [NSDate dateWithTimeIntervalSince1970:t];
    }
    
    NSAssert1(NO, @"Failed to parse date: %@", iso8601);
    return nil;
}

+ (NSString*) uniqueId
{
    CFUUIDRef cfuuid = CFUUIDCreate(kCFAllocatorDefault);
    
    NSString* uuid = (NSString*)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, cfuuid));
    
    CFRelease(cfuuid);
    
    return uuid;
}

+ (NSString*) AFBase64EncodedStringFromString:(NSString*)string
{
    NSData *data = [NSData dataWithBytes:[string UTF8String] length:[string length]];
    NSUInteger length = [data length];
    NSMutableData *mutableData = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    
    uint8_t *input = (uint8_t *)[data bytes];
    uint8_t *output = (uint8_t *)[mutableData mutableBytes];
    
    for (NSUInteger i = 0; i < length; i += 3) {
        NSUInteger value = 0;
        for (NSUInteger j = i; j < (i + 3); j++) {
            value <<= 8;
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        static uint8_t const kAFBase64EncodingTable[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
        
        NSUInteger idx = (i / 3) * 4;
        output[idx + 0] = kAFBase64EncodingTable[(value >> 18) & 0x3F];
        output[idx + 1] = kAFBase64EncodingTable[(value >> 12) & 0x3F];
        output[idx + 2] = (i + 1) < length ? kAFBase64EncodingTable[(value >> 6)  & 0x3F] : '=';
        output[idx + 3] = (i + 2) < length ? kAFBase64EncodingTable[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:mutableData encoding:NSASCIIStringEncoding];
}

+ (NSUInteger) convertToBytes:(NSUInteger)byteAmt fromUnit:(NSInteger)byteUnit
{
    return (byteAmt*(1024*byteUnit));
}

@end

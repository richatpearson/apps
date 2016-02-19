//
//  DateUtil.m
//  classroom-ios
//
//  Created by Joe Miller on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssDateUtil.h"

@implementation PGMClssDateUtil

NSString *const DateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'";

+ (NSDate*)parseDateFromString:(NSString*)stringDate
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:DateFormat];
    NSDate *date = [formatter dateFromString:stringDate];
    NSLog(@"The date from string is %@", date);
    
    return date;
}

@end

//
//  SeerTokenResponse.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/16/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "SeerTokenResponse.h"
#import "SeerUtility.h"

@implementation SeerTokenResponse


- (BOOL) isExpired
{
    NSTimeInterval currentDate = [[NSDate date] timeIntervalSince1970];
    
    NSLog(@"CurrentDate: %f", currentDate);
    NSLog(@"Expiration Date: %@", self.expirationDate);
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = kCFDateFormatterMediumStyle;
    dateFormatter.timeStyle = kCFDateFormatterMediumStyle;
    dateFormatter.timeZone = [NSTimeZone localTimeZone];
    
    NSString *expirationDateString = [NSString stringWithFormat:@"%@", self.expirationDate];
    expirationDateString = [expirationDateString substringToIndex:[expirationDateString length]-3];
    double expirationDateInterval = [expirationDateString doubleValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:expirationDateInterval];
    NSString *sdate = [dateFormatter stringFromDate:startDate];
    NSLog(@"After removing last 3 digits Expiration Date is %@", sdate);

    
    if(self.expirationDate)
    {
        if (currentDate > expirationDateInterval)
        {
            return YES;
        }
    }
    
    
    return NO;
}

- (NSString*) tokenString
{
    return [NSString stringWithFormat:@"%@ %@", self.tokenType, self.accessToken];
}

@end

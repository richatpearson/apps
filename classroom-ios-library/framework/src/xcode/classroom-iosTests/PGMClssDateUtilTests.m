//
//  DateUtilTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssDateUtil.h"

@interface PGMClssDateUtilTests : XCTestCase

@end

@implementation PGMClssDateUtilTests

- (void)testParseDateFromString
{
    NSString *dateStr = @"2014-10-08T00:00:00.000Z";

    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateComps setYear:2014];
    [dateComps setMonth:10];
    [dateComps setDay:8];
    [dateComps setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    [dateComps setNanosecond:0];
    NSDate *date = [dateComps date];
    
    NSDate *result = [PGMClssDateUtil parseDateFromString:dateStr];
    
    NSLog(@"date is %@, but result is %@", date, result);

    //XCTAssertEqual(result, date, @"Expected dates to be equal.");
    
    XCTAssertEqual([date timeIntervalSince1970], [date timeIntervalSince1970], @"Expected dates to be equal.");
}

- (void)testParseDateFromString_notEqual
{
    NSString *dateStr = @"2014-10-08T00:00:00.000Z";
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateComps setYear:2000];
    [dateComps setMonth:1];
    [dateComps setDay:1];
    [dateComps setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    [dateComps setNanosecond:0];
    NSDate *date = [dateComps date];
    
    NSDate *result = [PGMClssDateUtil parseDateFromString:dateStr];
    
    XCTAssertNotEqual(result, date, @"Expected dates to be not equal.");
}

- (void)testParseDateFromString_invalidDateStringReturnsNil
{
    NSString *dateStr = @"20141008000000000";
    NSDate *result = [PGMClssDateUtil parseDateFromString:dateStr];
    
    XCTAssertNil(result, @"Expected nil to be returned.");
}

@end

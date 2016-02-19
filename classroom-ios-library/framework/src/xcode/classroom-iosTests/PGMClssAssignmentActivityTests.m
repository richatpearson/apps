//
//  PGMClssAssignmentActivityTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssAssignmentActivity.h"

@interface PGMClssAssignmentActivityTests : XCTestCase

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDate *date;

@end

@implementation PGMClssAssignmentActivityTests

- (void)setUp
{
    [super setUp];
    
    NSDateComponents *dateComps = [[NSDateComponents alloc] init];
    [dateComps setCalendar:[[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]];
    [dateComps setYear:2014];
    [dateComps setMonth:10];
    [dateComps setDay:7];
    [dateComps setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    [dateComps setNanosecond:0];
    
    self.date = [dateComps date];
    
    self.dateStr = @"2014-10-07T00:00:00.000Z";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testInitWithDictionary
{
    NSString *id = @"12345";
    NSString *title = @"title";
    NSString *thumbnailURL = @"thumbnailURL";
    NSString *description = @"description";
    
    PGMClssAssignmentActivity *sut = [[PGMClssAssignmentActivity alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:id forKey:@"id"];
    [data setValue:title forKey:@"title"];
    [data setValue:self.dateStr forKey:@"dueDate"];
    [data setValue:thumbnailURL forKey:@"thumbnailUrl"];
    [data setValue:description forKey:@"description"];
    [data setValue:self.dateStr forKey:@"lastModifiedDate"];
    
    sut = [sut initWithDictionary:data withAssignment:nil];
    
    XCTAssert(sut, @"Expected not nil.");
    XCTAssertEqual(sut.activityId, id, @"Expected id's to be equal.");
    XCTAssertEqual(sut.title, title, @"Expected titles to be equal.");
    //XCTAssertEqual(sut.dueDate, self.date, @"Expected due dates to be equal.");
    XCTAssertEqual([sut.dueDate timeIntervalSince1970], [self.date timeIntervalSince1970], @"Expected due dates to be equal.");
    XCTAssertEqual(sut.thumbnailURL, thumbnailURL, @"Expected URL's to be equal.");
    XCTAssertEqual(sut.activityDescription, description, @"Expected descriptions to be equal.");
    //XCTAssertEqual(sut.lastModified, self.date, @"Expected last modified dates to be equal.");
    XCTAssertEqual([sut.lastModified timeIntervalSince1970], [self.date timeIntervalSince1970], @"Expected last modified dates to be equal.");
}

@end

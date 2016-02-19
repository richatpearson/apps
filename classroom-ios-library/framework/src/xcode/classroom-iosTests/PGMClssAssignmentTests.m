//
//  PGMClssAssignmentTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssAssignment.h"
#import "PGMClssAssignmentActivity.h"

@interface PGMClssAssignmentTests : XCTestCase

@property (nonatomic, strong) NSString *dateStr;
@property (nonatomic, strong) NSDate *date;

@end

@implementation PGMClssAssignmentTests

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
    NSString *templateId = @"6789";
    NSString *description = @"description";
    
    PGMClssAssignment *sut = [[PGMClssAssignment alloc] init];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setObject:id forKey:@"id"];
    [data setObject:title forKey:@"title"];
    [data setObject:templateId forKey:@"templateId"];
    [data setObject:description forKey:@"description"];
    [data setObject:self.dateStr forKey:@"lastModified"];
    
    NSMutableArray *activityData = [[NSMutableArray alloc] initWithObjects:[[NSDictionary alloc] init],
                                    [[NSDictionary alloc] init], [[NSDictionary alloc] init], nil];
    [data setObject:activityData forKey:@"activities"];

    sut = [sut initWithDictionary:data withCourseListItem:nil];
    XCTAssert(sut, @"Expected not nil.");
    XCTAssertEqual(sut.assignmentId, id, @"Expected id's to be equal.");
    XCTAssertEqual(sut.title, title, @"Expected titles to be equal.");
    XCTAssertEqual(sut.assignmentTemplateId, templateId, @"Expected template id's to be equal.");
    XCTAssertEqual(sut.self.assignmentDescription, description, @"Expected descriptions to be equal.");
    //XCTAssertEqual(sut.lastModified, self.date, @"Expected last modified dates to be equal.");
    XCTAssertEqual([sut.lastModified timeIntervalSince1970], [self.date timeIntervalSince1970], @"Expected last modified dates to be equal.");
    XCTAssertTrue(sut.assignmentActivities.count == 3, @"Expected 3 activities.");
}

@end

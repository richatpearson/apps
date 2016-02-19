//
//  PGMClssCourseListItemTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseListItem.h"
#import "PGMClssDateUtil.h"

@interface PGMClssCourseListItemTests : XCTestCase

@end

@implementation PGMClssCourseListItemTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCourseListItemInit
{
    PGMClssCourseListItem *listItem = [PGMClssCourseListItem new];
    
    XCTAssertNil(listItem.itemId);
    XCTAssertNil(listItem.courseType);
    XCTAssertNil(listItem.sectionId);
    XCTAssertNil(listItem.sectionTitle);
    XCTAssertNil(listItem.sectionCode);
    XCTAssertNil(listItem.sectionStartDate);
    XCTAssertNil(listItem.sectionStartDate);
    XCTAssertNil(listItem.courseId);
    XCTAssertNil(listItem.courseType);
    XCTAssertNil(listItem.avatarUrl);
    
    NSString *itemID = @"12345";
    NSInteger courseStatus = 1;
    NSString *sectionId = @"abc1234";
    NSString *sectionTitle = @"Math 300";
    NSString *sectionCode = @"A1";
    NSDate *sectionStartDate = [NSDate date];
    NSDate *sectionEndDate = [NSDate dateWithTimeIntervalSinceNow:86400];
    NSString *courseId = @"110220";
    NSString *courseType = @"gridmobile";
    NSString *avatarUrl = @"http://mytest.com";
    
    listItem.itemId = itemID;
    listItem.itemStatus = courseStatus;
    listItem.sectionId = sectionId;
    listItem.sectionTitle = sectionTitle;
    listItem.sectionCode = sectionCode;
    listItem.sectionStartDate = sectionStartDate;
    listItem.sectionEndDate = sectionEndDate;
    listItem.courseId = courseId;
    listItem.courseType = courseType;
    listItem.avatarUrl = avatarUrl;
    
    XCTAssertEqual(itemID, listItem.itemId);
    XCTAssertEqual(1,listItem.itemStatus);
    XCTAssertEqual(sectionId, listItem.sectionId);
    XCTAssertEqual(sectionCode, listItem.sectionCode);
    XCTAssertEqual(sectionStartDate, listItem.sectionStartDate);
    XCTAssertEqual(sectionEndDate, listItem.sectionEndDate);
    XCTAssertEqual(courseId, listItem.courseId);
    XCTAssertEqual(courseType, listItem.courseType);
    XCTAssertEqual(avatarUrl, listItem.avatarUrl);
}

- (void)testCourseListItemInitWithDict
{
    NSString *itemId       = @"abc123";
    NSString *status       = @"active";
    NSString *sectionId    = @"section11";
    NSString *sectionTitle = @"My Fine Arts course";
    NSString *sectionCode  = @"Code 1";
    NSString *startDate    = @"2014-09-03T07:00:00.000Z";
    NSString *endDate      = @"2014-11-25T07:00:00.000Z";
    NSString *courseId     = @"course123";
    NSString *courseType   = @"gridmobile";
    NSString *avatarUrl    = @"http://avatar1.com";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"id\": \"%@\", \"status\": \"%@\", \"section\": {\"sectionId\": \"%@\",\"sectionTitle\": \"%@\",\"sectionCode\": \"%@\",\"startDate\": \"%@\",\"endDate\": \"%@\",\"courseId\": \"%@\",\"courseType\": \"%@\",\"avatarUrl\": \"%@\"}}", itemId, status, sectionId, sectionTitle, sectionCode, startDate, endDate, courseId, courseType, avatarUrl];
    
    NSError *error;
    NSDictionary *dictData = [NSJSONSerialization JSONObjectWithData:[jsonString dataUsingEncoding:NSUTF8StringEncoding]
                                                             options: NSJSONReadingMutableContainers
                                                               error: &error];
    
    PGMClssCourseListItem *courseListItem = [[PGMClssCourseListItem alloc] initWithDictionary:dictData];
    
    XCTAssertNotNil(courseListItem);
    
    XCTAssertEqualObjects(itemId, courseListItem.itemId);
    XCTAssertEqual(1, courseListItem.itemStatus);
    XCTAssertEqualObjects(sectionId, courseListItem.sectionId);
    XCTAssertEqualObjects(sectionTitle, courseListItem.sectionTitle);
    XCTAssertEqualObjects(sectionCode, courseListItem.sectionCode);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:startDate], courseListItem.sectionStartDate);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:endDate], courseListItem.sectionEndDate);
    XCTAssertEqualObjects(courseId, courseListItem.courseId);
    XCTAssertEqualObjects(courseType, courseListItem.courseType);
    XCTAssertEqualObjects(avatarUrl, courseListItem.avatarUrl);
}

@end

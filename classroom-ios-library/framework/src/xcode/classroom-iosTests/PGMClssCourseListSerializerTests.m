//
//  PGMClssCourseListSerializerTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseListSerializer.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssDateUtil.h"

@interface PGMClssCourseListSerializerTests : XCTestCase

@end

@implementation PGMClssCourseListSerializerTests

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

- (void)testDeserializeCourseListItem_NilInput_Error
{
    PGMClssCourseListSerializer *deserializer = [PGMClssCourseListSerializer new];
    
    NSArray *courseListItems = [deserializer deserializeCourseListItems:nil];
    
    XCTAssertNil(courseListItems);
}

- (void)testDeserializeCourseListItem_dataInput_Success
{
    NSString *itemId1       = @"abc123";
    NSString *status        = @"active";
    NSString *sectionId1    = @"section11";
    NSString *sectionTitle1 = @"My Fine Arts course";
    NSString *sectionCode1  = @"Code 1";
    NSString *startDate1    = @"2014-09-03T07:00:00.000Z";
    NSString *endDate1      = @"2014-11-25T07:00:00.000Z";
    NSString *courseId1     = @"course123";
    NSString *courseType    = @"gridmobile";
    NSString *avatarUrl1    = @"http://avatar1.com";
    
    NSString *itemId2       = @"def456";
    NSString *sectionId2    = @"section22";
    NSString *sectionTitle2 = @"Algebra 100";
    NSString *sectionCode2  = @"Code 2";
    NSString *startDate2    = @"2014-09-17T09:00:00.000Z";
    NSString *endDate2      = @"2014-12-11T09:30:00.000Z";
    NSString *courseId2     = @"course456";
    NSString *avatarUrl2    = @"http://avatar2.com";
    
    NSString *jsonString = [NSString stringWithFormat:@"[{\"id\": \"%@\", \"status\": \"%@\", \"section\": {\"sectionId\": \"%@\",\"sectionTitle\": \"%@\",\"sectionCode\": \"%@\",\"startDate\": \"%@\",\"endDate\": \"%@\",\"courseId\": \"%@\",\"courseType\": \"%@\",\"avatarUrl\": \"%@\"}},{\"id\": \"%@\", \"status\": \"%@\", \"section\": {\"sectionId\": \"%@\",\"sectionTitle\": \"%@\", \"sectionCode\": \"%@\",\"startDate\": \"%@\",\"endDate\": \"%@\",\"courseId\": \"%@\",\"courseType\": \"%@\",\"avatarUrl\": \"%@\"}}]", itemId1, status, sectionId1, sectionTitle1, sectionCode1, startDate1, endDate1, courseId1, courseType, avatarUrl1, itemId2, status, sectionId2, sectionTitle2, sectionCode2, startDate2, endDate2, courseId2, courseType, avatarUrl2];
    
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    PGMClssCourseListSerializer *deserializer = [PGMClssCourseListSerializer new];
    NSArray *courseListItems = [deserializer deserializeCourseListItems:data];
    
    XCTAssertNotNil(courseListItems);
    XCTAssertEqual(2, [courseListItems count]);
    
    XCTAssertEqualObjects(itemId1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).itemId);
    XCTAssertEqual(1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).itemStatus);
    XCTAssertEqualObjects(sectionId1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).sectionId);
    XCTAssertEqualObjects(sectionTitle1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).sectionTitle);
    XCTAssertEqualObjects(sectionCode1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).sectionCode);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:startDate1], ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).sectionStartDate);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:endDate1], ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).sectionEndDate);
    XCTAssertEqualObjects(courseId1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).courseId);
    XCTAssertEqualObjects(courseType, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).courseType);
    XCTAssertEqualObjects(avatarUrl1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:0]).avatarUrl);
    
    XCTAssertEqualObjects(itemId2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).itemId);
    XCTAssertEqual(1, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).itemStatus);
    XCTAssertEqualObjects(sectionId2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).sectionId);
    XCTAssertEqualObjects(sectionTitle2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).sectionTitle);
    XCTAssertEqualObjects(sectionCode2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).sectionCode);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:startDate2], ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).sectionStartDate);
    XCTAssertEqualObjects([PGMClssDateUtil parseDateFromString:endDate2], ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).sectionEndDate);
    XCTAssertEqualObjects(courseId2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).courseId);
    XCTAssertEqualObjects(courseType, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).courseType);
    XCTAssertEqualObjects(avatarUrl2, ((PGMClssCourseListItem*)[courseListItems objectAtIndex:1]).avatarUrl);
}

@end

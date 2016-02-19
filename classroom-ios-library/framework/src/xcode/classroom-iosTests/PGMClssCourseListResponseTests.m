//
//  PGMClssCourseListResponseTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseListResponse.h"

@interface PGMClssCourseListResponseTests : XCTestCase

@end

@implementation PGMClssCourseListResponseTests

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

- (void)testCourseListResponseInit
{
    PGMClssCourseListResponse *response = [[PGMClssCourseListResponse alloc] init];
    
    XCTAssert(!response.error);
    XCTAssert(!response.courseListArray);
    
    NSString *domain = @"MyTestDoamin";
    response.error = [NSError errorWithDomain:domain code:123 userInfo:[[NSDictionary alloc]init]];
    
    XCTAssert(response.error);
    XCTAssertEqualObjects(domain, response.error.domain);
    
    NSNumber *item1 = [NSNumber numberWithInt:3];
    NSNumber *item2 = [NSNumber numberWithInt:50];
    NSNumber *item3 = [NSNumber numberWithInt:200];
    
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:item1];
    [testArray addObject:item2];
    [testArray addObject:item3];
    
    response.courseListArray = testArray;
    
    XCTAssert(response.courseListArray);
    XCTAssertEqual(3, [response.courseListArray count]);
}

- (void)testCourseListResponseSetters
{
    PGMClssCourseListResponse *response = [[PGMClssCourseListResponse alloc] init];
    XCTAssertNil(response.error);
    
    NSString *domain = @"MyTestDoamin";
    [response setError:[NSError errorWithDomain:domain code:123 userInfo:[[NSDictionary alloc]init]]];
    
    XCTAssert(response.error);
    XCTAssertEqualObjects(domain, response.error.domain);
    
    XCTAssertNil(response.courseListArray);
    
    NSNumber *item1 = [NSNumber numberWithInt:3];
    NSNumber *item2 = [NSNumber numberWithInt:50];
    NSNumber *item3 = [NSNumber numberWithInt:200];
    
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:item1];
    [testArray addObject:item2];
    [testArray addObject:item3];
    
    [response setCourseListArray:testArray];
    
    XCTAssert(response.courseListArray);
    XCTAssertEqual(3, [response.courseListArray count]);
}

@end

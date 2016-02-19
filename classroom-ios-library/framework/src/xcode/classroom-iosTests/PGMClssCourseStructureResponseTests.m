//
//  PGMClssCourseStructureResponseTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseStructureResponse.h"

@interface PGMClssCourseStructureResponseTests : XCTestCase

@end

@implementation PGMClssCourseStructureResponseTests

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

- (void)testCourseStructureResponse
{
    PGMClssCourseStructureResponse *response = [[PGMClssCourseStructureResponse alloc] init];
    
    XCTAssert(!response.error);
    XCTAssert(!response.courseStructureArray);
    XCTAssert(!response.responseType);
    
    NSString *domain = @"MyTestErrorDoamin";
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
    
    response.courseStructureArray = testArray;
    response.responseType = PGMClssParentItems;
    
    XCTAssert(response.courseStructureArray);
    XCTAssertEqual(3, [response.courseStructureArray count]);
    XCTAssertEqual(1, response.responseType);
}

- (void)testCourseStructureResponseSetters
{
    PGMClssCourseStructureResponse *response = [[PGMClssCourseStructureResponse alloc] init];
    
    XCTAssert(!response.error);
    XCTAssert(!response.courseStructureArray);
    XCTAssert(!response.responseType);
    
    NSString *domain = @"MyTestErrorDoamin";
    [response setError:[NSError errorWithDomain:domain code:123 userInfo:[[NSDictionary alloc]init]]];
    
    XCTAssert(response.error);
    XCTAssertEqualObjects(domain, response.error.domain);
    
    NSNumber *item1 = [NSNumber numberWithInt:3];
    NSNumber *item2 = [NSNumber numberWithInt:50];
    NSNumber *item3 = [NSNumber numberWithInt:200];
    
    NSMutableArray *testArray = [[NSMutableArray alloc] init];
    [testArray addObject:item1];
    [testArray addObject:item2];
    [testArray addObject:item3];
    
    [response setCourseStructureArray:testArray];
    [response setResponseType:PGMClssParentItems];
    
    XCTAssert(response.courseStructureArray);
    XCTAssertEqual(3, [response.courseStructureArray count]);
    XCTAssertEqual(1, response.responseType);
}

@end

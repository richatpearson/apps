//
//  PGMClssAssignmentSortingTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PGMClssAssignmentSorting.h"
#import "PGMClssAssignmentActivity.h"

@interface PGMClssAssignmentSortingTests : XCTestCase

@property (nonatomic, strong) NSArray *assignments;
@property (nonatomic, strong) PGMClssAssignmentActivity *activity1;
@property (nonatomic, strong) PGMClssAssignmentActivity *activity2;
@property (nonatomic, strong) PGMClssAssignmentActivity *activity3;

@end

@implementation PGMClssAssignmentSortingTests

- (void)setUp
{
    [super setUp];
    
    self.activity1 = [PGMClssAssignmentActivity new];
    self.activity1.sectionTitle = @"AAA";
    self.activity1.dueDate = [NSDate distantFuture];
    
    self.activity2 = [PGMClssAssignmentActivity new];
    self.activity2.sectionTitle = @"MMM";
    self.activity2.dueDate = [NSDate date];
    
    self.activity3 = [PGMClssAssignmentActivity new];
    self.activity3.sectionTitle = @"ZZZ";
    self.activity3.dueDate = [NSDate distantPast];
    
    PGMClssAssignment *assignment1 = [PGMClssAssignment new];
    assignment1.assignmentActivities = [NSArray arrayWithObjects:self.activity3, nil];
    
    PGMClssAssignment *assignment2 = [PGMClssAssignment new];
    assignment2.assignmentActivities = [NSArray arrayWithObjects:self.activity2, self.activity1, nil];
    
    self.assignments = [NSArray arrayWithObjects:assignment1, assignment2, nil];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testSortAssignmentActivities_byCourseTitle_asc
{
    NSArray *results = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignments by:PGMClssCourseTitle ascending:YES];
    XCTAssert(results.count == 3, "Expected 3 activities to be returned.");
    XCTAssertEqualObjects([results objectAtIndex:0], self.activity1, "Expected 0 index to be activity 1.");
    XCTAssertEqualObjects([results objectAtIndex:1], self.activity2, "Expected 1 index to be activity 2.");
    XCTAssertEqualObjects([results objectAtIndex:2], self.activity3, "Expected 2 index to be activity 3.");
}

- (void)testSortAssignmentActivities_byCourseTitle_desc
{
    NSArray *results = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignments by:PGMClssCourseTitle ascending:NO];
    XCTAssert(results.count == 3, "Expected 3 activities to be returned.");
    XCTAssertEqualObjects([results objectAtIndex:0], self.activity3, "Expected 0 index to be activity 3.");
    XCTAssertEqualObjects([results objectAtIndex:1], self.activity2, "Expected 1 index to be activity 2.");
    XCTAssertEqualObjects([results objectAtIndex:2], self.activity1, "Expected 2 index to be activity 1.");
}

- (void)testSortAssignmentActivities_byDueDate_asc
{
    NSArray *results = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignments by:PGMClssDueDate ascending:YES];
    XCTAssert(results.count == 3, "Expected 3 activities to be returned.");
    XCTAssertEqualObjects([results objectAtIndex:0], self.activity3, "Expected 0 index to be activity 3.");
    XCTAssertEqualObjects([results objectAtIndex:1], self.activity2, "Expected 1 index to be activity 2.");
    XCTAssertEqualObjects([results objectAtIndex:2], self.activity1, "Expected 2 index to be activity 1.");
}

- (void)testSortAssignmentActivities_byDueDate_desc
{
    NSArray *results = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignments by:PGMClssDueDate ascending:NO];
    XCTAssert(results.count == 3, "Expected 3 activities to be returned.");
    XCTAssertEqualObjects([results objectAtIndex:0], self.activity1, "Expected 0 index to be activity 1.");
    XCTAssertEqualObjects([results objectAtIndex:1], self.activity2, "Expected 1 index to be activity 2.");
    XCTAssertEqualObjects([results objectAtIndex:2], self.activity3, "Expected 2 index to be activity 3.");
}

@end

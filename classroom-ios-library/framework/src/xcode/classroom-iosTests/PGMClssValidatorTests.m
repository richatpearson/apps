//
//  PGMClssValidatorTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/20/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PGMClssEnvironment.h"
#import "PGMClssValidator.h"
#import "PGMClssError.h"

@interface PGMClssValidatorTests : XCTestCase

@end

@implementation PGMClssValidatorTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testValidateCourseStructureEnvironment_nilEnvironment_error
{
    NSError *result = [PGMClssValidator validateCourseStructureEnvironment:nil];
    XCTAssertNotNil(result, @"Expected not nil error result.");
    XCTAssertEqual(result.domain, PGMClssErrorDomain, @"Expected domains to be equal.");
    XCTAssertNotNil(result.userInfo, @"Error not initialized properly.");
}

- (void)testValidateCourseStructureEnvironment_nilBaseRequestCourseStructUrl_error
{
    PGMClssEnvironment *env = [PGMClssEnvironment new];
    NSError *result = [PGMClssValidator validateCourseStructureEnvironment:env];
    XCTAssertNotNil(result, @"Expected not nil error result.");
    XCTAssertEqual(result.domain, PGMClssErrorDomain, @"Expected domains to be equal.");
    XCTAssertNotNil(result.userInfo, @"Error not initialized properly.");
}

- (void)testValidateCourseStructureEnvironment_emptyBaseRequestCourseStructUrl_error
{
    PGMClssEnvironment *env = [PGMClssEnvironment new];
    env.baseRequestCourseStructUrl = @"";
    NSError *result = [PGMClssValidator validateCourseStructureEnvironment:env];
    XCTAssertNotNil(result, @"Expected not nil error result.");
    XCTAssertEqual(result.domain, PGMClssErrorDomain, @"Expected domains to be equal.");
    XCTAssertNotNil(result.userInfo, @"Error not initialized properly.");
}

- (void)testValidateCourseStructureEnvironment
{
    PGMClssEnvironment *env = [PGMClssEnvironment new];
    env.baseRequestCourseStructUrl = @"someURL";
    NSError *result = [PGMClssValidator validateCourseStructureEnvironment:env];
    XCTAssertNil(result, @"Expected nil error result.");
}

@end

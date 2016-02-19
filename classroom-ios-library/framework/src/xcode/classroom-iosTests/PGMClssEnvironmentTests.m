//
//  PGMClssEnvironmentTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssEnvironment.h"

@interface PGMClssEnvironmentTests : XCTestCase

@end

@implementation PGMClssEnvironmentTests

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

- (void)testSetEnvironmentToStaging
{
    PGMClssEnvironment *environment = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    
    XCTAssertEqualObjects(PGMClssDefaultBaseCourseList_Staging, environment.baseRequestCourseListUrl);
    XCTAssertEqualObjects(PGMClssDefaultBaseCourseStruct_Staging, environment.baseRequestCourseStructUrl);
}

- (void) testSetEnvironmentToCustom
{
    NSString *customRequestCourseListUrl = @"http://mybaseurl.com";
    NSString *customRequestCourseStructUrl = @"http://mybaseurlCourseStruct.com";
    PGMClssCustomEnvironment *customEnv = [PGMClssCustomEnvironment new];
    customEnv.customBaseRequestCourseListUrl = customRequestCourseListUrl;
    customEnv.customBaseRequestCourseStructUrl = customRequestCourseStructUrl;
    
    PGMClssEnvironment *environment = [[PGMClssEnvironment alloc] initWithCustomEnvironment:customEnv];
    
    XCTAssertEqualObjects(customRequestCourseListUrl, environment.baseRequestCourseListUrl);
    XCTAssertEqualObjects(customRequestCourseStructUrl, environment.baseRequestCourseStructUrl);
}

@end

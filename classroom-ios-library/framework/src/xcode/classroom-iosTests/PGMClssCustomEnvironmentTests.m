//
//  PGMClssCustomEnvironmentTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCustomEnvironment.h"

@interface PGMClssCustomEnvironmentTests : XCTestCase

@end

@implementation PGMClssCustomEnvironmentTests

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

- (void)testInitProperties
{
    NSString *customCourseListUrl = @"http://course-list.com";
    NSString *customCourseStructUrl = @"http://course-struct.com";
    
    PGMClssCustomEnvironment *customEnv = [PGMClssCustomEnvironment new];
    
    customEnv.customBaseRequestCourseListUrl = customCourseListUrl;
    customEnv.customBaseRequestCourseStructUrl = customCourseStructUrl;
    
    XCTAssertEqualObjects(customCourseListUrl, customEnv.customBaseRequestCourseListUrl);
    XCTAssertEqualObjects(customCourseStructUrl, customEnv.customBaseRequestCourseStructUrl);
}

@end


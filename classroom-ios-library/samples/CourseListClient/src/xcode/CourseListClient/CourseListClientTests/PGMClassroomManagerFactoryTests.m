//
//  PGMClassroomManagerFactoryTests.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PGMClassroomManagerFactory.h"

@interface PGMClassroomManagerFactoryTests : XCTestCase

@end

@implementation PGMClassroomManagerFactoryTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testCreateManagerForEnv {
    
    PGMClssRequestManager *manager = [PGMClassroomManagerFactory createManagerForEnv:PGMClssStaging];
    
    XCTAssertNotNil(manager);
    XCTAssertNotNil(manager.clssEnvironment);
    XCTAssertNotNil(manager.clssEnvironment.baseRequestCourseListUrl);
    XCTAssertNotNil(manager.clssEnvironment.baseRequestCourseStructUrl);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

//
//  PGMAssignmentProviderTests.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "PGMAssignmentsProvider.h"

@interface PGMAssignmentsProviderTests : XCTestCase

@end

@implementation PGMAssignmentsProviderTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitWithEnvironmentType {
    PGMAssignmentsProvider *provider = [[PGMAssignmentsProvider alloc] initWithEnvironmentType:PGMClssStaging];
    
    XCTAssertNotNil(provider);
    XCTAssertNotNil(provider.requestManager);
    XCTAssertNotNil(provider.requestManager.clssEnvironment);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end

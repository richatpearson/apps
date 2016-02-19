//
//  PGMClssErrorTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssError.h"

@interface PGMClssErrorTests : XCTestCase

@end

@implementation PGMClssErrorTests

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

- (void)testcreateClssErrorForErrorCode
{
    NSString *customErrorDesc = @"My error description";
    NSError *error = [PGMClssError createClssErrorForErrorCode:PGMClssCourseListNetworkCallError andDescription:customErrorDesc];
    
    XCTAssertEqualObjects(customErrorDesc, error.localizedDescription);
    XCTAssertEqual(PGMClssCourseListNetworkCallError, error.code);
    XCTAssertEqual(PGMClssErrorDomain, error.domain);
}

@end

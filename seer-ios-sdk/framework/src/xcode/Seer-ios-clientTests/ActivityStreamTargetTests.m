//
//  ActivityStreamTargetTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 1/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStreamTarget.h"

@interface ActivityStreamTargetTests : XCTestCase

@property (nonatomic, strong) ActivityStreamTarget* target;

@end

@implementation ActivityStreamTargetTests

- (void)setUp
{
    [super setUp];
    self.target = [ActivityStreamTarget new];
}

- (void)tearDown
{
    self.target = nil;
    [super tearDown];
}

- (void)testTargetInit
{
    XCTAssertNotNil(self.target, @"ActivityStreamTarget has not been initialized properly");
}

- (void) testSetId
{
    [self.target setId:@"1234567890"];
    
    XCTAssertEqualObjects(@"1234567890", [self.target targetId], @"ActivityStreamTarget not setting/getting targetId properly");
}

@end

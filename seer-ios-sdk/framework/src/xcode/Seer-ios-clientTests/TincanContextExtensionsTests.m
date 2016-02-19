//
//  TincanContextExtensionsTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanContextExtensions.h"

@interface TincanContextExtensionsTests : XCTestCase

@property (nonatomic, strong) TincanContextExtensions* tcExtensions;
@property (nonatomic, strong) NSString* appId;

@end

@implementation TincanContextExtensionsTests

- (void)setUp
{
    [super setUp];
    self.tcExtensions = [TincanContextExtensions new];
    self.appId = @"1234567890";
}

- (void)tearDown
{
    self.tcExtensions = nil;
    [super tearDown];
}

- (void)testTincanContextExtensionsInit
{
    XCTAssertNotNil(self.tcExtensions, @"TincanContextExtensions has not been initialized properly");
}

- (void) testSetAppId
{
    [self.tcExtensions setAppId:self.appId];
    
    XCTAssertEqualObjects([self.tcExtensions appId], self.appId, @"TincanContextExtensions has problem setting an getting an appId");
}

@end

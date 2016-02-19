//
//  TincanContextActivityTest.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanContextActivityItem.h"

@interface TincanContextActivityItemTests : XCTestCase

@property (nonatomic, strong) TincanContextActivityItem* tcActivityItem;

@end

@implementation TincanContextActivityItemTests

- (void)setUp
{
    [super setUp];
    self.tcActivityItem = [TincanContextActivityItem new];
}

- (void)tearDown
{
    self.tcActivityItem = nil;
    [super tearDown];
}

- (void)testTincanContextActivityItemInit
{
    XCTAssertNotNil(self.tcActivityItem, @"TincanContextActivityItem has not been initialized properly");
}

- (void) testSetId
{
    [self.tcActivityItem setId:@"http://example.adlnet.gov/xapi/example/testId"];
    
    XCTAssertEqualObjects([self.tcActivityItem activityId], @"http://example.adlnet.gov/xapi/example/testId", @"TincanContextActivityItem has problem setting an getting an id");
}


@end

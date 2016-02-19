//
//  TincanResultTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/31/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanResult.h"
#import "SeerUtility.h"

@interface TincanResultTests : XCTestCase

@property (nonatomic, strong) TincanResult* tincanResult;

@end

@implementation TincanResultTests

- (void)setUp
{
    [super setUp];
    self.tincanResult = [TincanResult new];
}

- (void)tearDown
{
    self.tincanResult = nil;
    [super tearDown];
}

- (void)testTincanResultInit
{
    XCTAssertNotNil(self.tincanResult, @"TincanResult has not been initialized properly");
}

- (void) testCompletion
{
    [self.tincanResult setCompletion:YES];
    
    XCTAssertTrue([self.tincanResult completion], @"TincanResult not setting/retrieving completion properly");
}

- (void) testSuccess
{
    [self.tincanResult setSuccess:YES];
    
    XCTAssertTrue([self.tincanResult success], @"TincanResult not setting/retrieving success properly");
}

- (void) testDuration
{
    NSString* isoDateStr = [SeerUtility iso8601StringFromDate:[NSDate date]];
    [self.tincanResult setDuration:isoDateStr];
    
    XCTAssertEqualObjects(isoDateStr, [self.tincanResult duration], @"TincanResult not setting/retrieving duration properly");
}

- (void) testScore
{
    TincanResultScore* score = [TincanResultScore new];
    
    [score setMin:@0];
    [score setMax:@100];
    [score setScaled:@0.95];
    [score setRaw:@90];
    
    [self.tincanResult setScore:score];
    
    XCTAssertTrue([[self.tincanResult score] isKindOfClass:[TincanResultScore class]], @"TincanResult is not setting/retrieving score properly");
}

@end

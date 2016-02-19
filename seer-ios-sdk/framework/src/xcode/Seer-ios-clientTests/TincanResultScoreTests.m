//
//  TincanResultScoreTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/31/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanResultScore.h"

@interface TincanResultScoreTests : XCTestCase

@property (nonatomic, strong) TincanResultScore* tincanResultScore;
@property (nonatomic, strong) NSNumber* testMin;
@property (nonatomic, strong) NSNumber* testMax;
@property (nonatomic, strong) NSNumber* testRaw;
@property (nonatomic, strong) NSNumber* testScaled;

@end

@implementation TincanResultScoreTests

- (void)setUp
{
    [super setUp];
    self.tincanResultScore = [TincanResultScore new];
    
    self.testMin = @0;
    self.testMax = @100;
    self.testScaled = @0.95;
    self.testRaw = @90;
}

- (void)tearDown
{
    self.tincanResultScore = nil;
    self.testMin = nil;
    self.testMax = nil;
    self.testScaled = nil;
    self.testRaw = nil;
    [super tearDown];
}

- (void) testTincanResultScoreInit
{
     XCTAssertNotNil(self.tincanResultScore, @"TincanResultScore has not been initialized properly");
}

- (void) testTincanResultScoreMin
{
    [self.tincanResultScore setMin:self.testMin];
    
    XCTAssertEqualObjects(self.testMin, [self.tincanResultScore min], @"TincanResultScore not setting/retrieving min properly");
}

- (void) testTincanResultScoreMax
{
    [self.tincanResultScore setMax:self.testMax];
    
    XCTAssertEqualObjects(self.testMax, [self.tincanResultScore max], @"TincanResultScore not setting/retrieving max properly");
}

- (void) testTincanResultScoreRaw
{
    [self.tincanResultScore setRaw:self.testRaw];
    
    XCTAssertEqualObjects(self.testRaw, [self.tincanResultScore raw], @"TincanResultScore not setting/retrieving raw properly");
}

- (void) testTincanResultScoreScaled
{
    [self.tincanResultScore setScaled:self.testScaled];
    
    XCTAssertEqualObjects(self.testScaled, [self.tincanResultScore scaled], @"TincanResultScore not setting/retrieving scaled properly");
}

@end

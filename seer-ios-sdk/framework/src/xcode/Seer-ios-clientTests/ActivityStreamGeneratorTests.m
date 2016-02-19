//
//  ActivityStreamGeneratorTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 1/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStreamGenerator.h"

@interface ActivityStreamGeneratorTests : XCTestCase

@property (nonatomic, strong) ActivityStreamGenerator* generator;

@end

@implementation ActivityStreamGeneratorTests

- (void)setUp
{
    [super setUp];
    self.generator = [ActivityStreamGenerator new];
}

- (void)tearDown
{
    self.generator = nil;
    [super tearDown];
}
- (void) TestGeneratorActorInit
{
    XCTAssertNotNil(self.generator, @"ActivityStreamGenerator has not been initialized properly");
}

- (void) testSetAppId
{
    [self.generator setAppId:@"Seer-ios-sdk"];
    
    XCTAssertEqualObjects(@"Seer-ios-sdk", [self.generator appId], @"ActivityStreamGenerator not setting/getting appId properly");
}

@end

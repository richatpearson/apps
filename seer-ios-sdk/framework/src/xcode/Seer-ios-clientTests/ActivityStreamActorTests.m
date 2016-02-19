//
//  ActivityStreamActorTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 1/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStreamActor.h"

@interface ActivityStreamActorTests : XCTestCase

@property (nonatomic, strong) ActivityStreamActor* actor;

@end

@implementation ActivityStreamActorTests

- (void)setUp
{
    [super setUp];
    self.actor = [ActivityStreamActor new];
}

- (void)tearDown
{
    self.actor = nil;
    [super tearDown];
}

- (void)testActorInit
{
    XCTAssertNotNil(self.actor, @"ActivityStreamActor has not been initialized properly");
}

- (void) testSetId
{
    [self.actor setId:@"1234567890"];
    
    XCTAssertEqualObjects(@"1234567890", [self.actor actorId], @"ActivityStreamActor not setting/getting actorId properly");
}

@end

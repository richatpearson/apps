//
//  ActivityStreamObjectTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 1/3/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActivityStreamObject.h"

@interface ActivityStreamObjectTests : XCTestCase

@property (nonatomic, strong) ActivityStreamObject* object;

@end

@implementation ActivityStreamObjectTests

- (void)setUp
{
    [super setUp];
    self.object = [ActivityStreamObject new];
}

- (void)tearDown
{
    self.object = nil;
    [super tearDown];
}

- (void)testObjectInit
{
    XCTAssertNotNil(self.object, @"ActivityStreamObject has not been initialized properly");
}

- (void) testSetObjectId
{
    [self.object setId:@"1234567890"];
    
    XCTAssertEqualObjects(@"1234567890", [self.object objectId], @"ActivityStreamObject not setting/getting objectId properly");
}

- (void) testSetObjectType
{
    [self.object setObjectType:@"ObjectType"];
    
    XCTAssertEqualObjects(@"ObjectType", [self.object objectType], @"ActivityStreamObject not setting/getting objectType properly");
}

@end

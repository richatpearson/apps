//
//  TincanObjectTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanObject.h"

@interface TincanObjectTests : XCTestCase

@property (nonatomic, strong) TincanObject* tincanObj;
@property (nonatomic, strong) NSString* objId;
@property (nonatomic, strong) NSString* objType;
@property (nonatomic, strong) NSString* defType;

@end

@implementation TincanObjectTests

- (void)setUp
{
    [super setUp];
    self.tincanObj = [TincanObject new];
    self.objId = @"http://example.com/tests/123456788";
    self.objType = @"Activity";
    self.defType = @"http://adlnet.gov/expapi/activities/assessment";
}

- (void)tearDown
{
    self.tincanObj = nil;
    self.objId = nil;
    self.objType = nil;
    self.defType = nil;
    [super tearDown];
}

- (void)testTincanObjectInit
{
    XCTAssertNotNil(self.tincanObj, @"TincanObject has not been initialized properly");
}

- (void) testSetObjectId
{
    [self.tincanObj setId:self.objId];
    
    XCTAssertEqualObjects([self.tincanObj objectId], self.objId, @"TincanObject has problem setting an getting an objectId");
}

- (void) testSetObjectType
{
    [self.tincanObj setObjectType:self.objType];
    
    XCTAssertEqualObjects([self.tincanObj objectType], self.objType, @"TincanObject has problem setting an getting an objectType");
}

- (void) testSetDefinitionWithType
{
    [self.tincanObj setDefinitionWithType:self.defType];
    
    XCTAssertNotNil([self.tincanObj objectDefinition], @"TincanObject has problem setting an getting an objectDefinition with type");
}

@end

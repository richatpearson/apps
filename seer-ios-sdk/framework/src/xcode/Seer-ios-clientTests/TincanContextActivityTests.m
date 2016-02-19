//
//  TincanContextActivityTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanContextActivity.h"

@interface TincanContextActivityTests : XCTestCase

@property (nonatomic, strong) TincanContextActivity* tcActivity;
@property (nonatomic, strong) NSString* itemId;

@end

@implementation TincanContextActivityTests

- (void)setUp
{
    [super setUp];
    self.tcActivity = [TincanContextActivity new];
    self.itemId = @"http://example.com/courses#12345";
}

- (void)tearDown
{
    self.tcActivity = nil;
    self.itemId = nil;
    [super tearDown];
}

- (void)testTincanContextActivityInit
{
    XCTAssertNotNil(self.tcActivity, @"TincanContextActivity has not been initialized properly");
}

- (void) testAddActivityItem
{
    NSUInteger cnt = [[self.tcActivity asArray] count];
    
    [self.tcActivity addActivityItem:[self buildActivityItem]];
    
    XCTAssertEqual((cnt + 1), [[self.tcActivity asArray] count], @"TincanContextActivity not adding activities to array properly.");
}

- (void) testAddActivityItemWithId
{
    TincanContextActivityItem* activityItem = [self.tcActivity addActivityItemWithId:self.itemId];
    
    XCTAssertNotNil(activityItem, @"TincanContextActivity not adding actiivty items with id properly");
}

- (void) testGetActivityItemWithId
{
    if([[self.tcActivity asArray] count] == 0)
    {
        [self.tcActivity addSeerDictionaryObjectData:[self buildActivityItem]];
    }
    
    TincanContextActivityItem* activityItem = [self.tcActivity getActivityItemWithId:self.itemId];
    
    XCTAssertNotNil(activityItem, @"TincanContextActivity not retrieving stored TincanContextActivityItems");
    XCTAssertEqualObjects(self.itemId, [activityItem activityId], @"TincanContextActivity not retrieving stored TincanContextActivityItmes properly");
}

- (void) testRemoveActivityItem
{
    self.tcActivity = [TincanContextActivity new];
    
    TincanContextActivityItem* activityItem = [self buildActivityItem];
    [self.tcActivity addActivityItem:activityItem];
    
    NSUInteger cnt = [[self.tcActivity asArray] count];
    
    [self.tcActivity removeActivityItems:activityItem];
    
    XCTAssertEqual((cnt -1), [[self.tcActivity asArray] count], @"TincanContextActivity not removing stored ActivityItems");
}

- (void) testRemoveActivityItemWithId
{
    if([[self.tcActivity asArray] count] == 0)
    {
        [self.tcActivity addActivityItem:[self buildActivityItem]];
    }
    
    [self.tcActivity removeActivityItemWithId:self.itemId];
    
    XCTAssertEqual((NSUInteger)0, [[self.tcActivity asArray] count], @"TincanContextActivity not removing stored ActivityItems by activityId");
}

- (TincanContextActivityItem*)buildActivityItem
{
    TincanContextActivityItem* activityItem = [TincanContextActivityItem new];
    [activityItem setId:self.itemId];
    
    return activityItem;
}

@end

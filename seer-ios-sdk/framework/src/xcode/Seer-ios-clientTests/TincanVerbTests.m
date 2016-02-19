//
//  TincanVerbTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/31/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanVerb.h"

@interface TincanVerbTests : XCTestCase

@property (nonatomic, strong) TincanVerb* tincanVerb;
@property (nonatomic, strong) NSString* testId;

@end

@implementation TincanVerbTests

- (void)setUp
{
    [super setUp];
    self.tincanVerb = [TincanVerb new];
    self.testId = @"http://adlnet.gov/expapi/verbs/completed";
}

- (void)tearDown
{
    self.tincanVerb = nil;
    self.testId = nil;
    [super tearDown];
}

- (void) testTincanVerbInit
{
    XCTAssertNotNil(self.tincanVerb, @"TincanVerb has not been initialized properly");
}

- (void) testVerbId
{
    [self.tincanVerb setId:self.testId];
    
    XCTAssertEqualObjects(self.testId, [self.tincanVerb verbId], @"TincanVerb not setting/retrieving id properly");
}

- (void) testDisplay
{
    NSString* displayVal = @"completed";
    
    TincanLanguageMap* displayMap = [TincanLanguageMap new];
    [displayMap setStringValue:displayVal forProperty:@"en-US"];
    
    [self.tincanVerb setDislay:displayMap];
    
    XCTAssertEqualObjects(displayVal, [[self.tincanVerb display] getStringValueForProperty:@"en-US"], @"TincanVerb not setting display properly.");
}

@end

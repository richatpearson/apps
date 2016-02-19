//
//  TincanLanguageMapTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/24/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanLanguageMap.h"

@interface TincanLanguageMapTests : XCTestCase

@property (nonatomic, strong) TincanLanguageMap* langMap;

@end

@implementation TincanLanguageMapTests

- (void)setUp
{
    [super setUp];
    self.langMap = [TincanLanguageMap new];
}

- (void)tearDown
{
    self.langMap = nil;
    [super tearDown];
}

- (void)testTincanLanguageMapInit
{
    XCTAssertNotNil(self.langMap, @"TincanLanguageMap has not been initialized properly");
}

- (void)testLanguageMapIsSeerDictionaryObject
{
    XCTAssertTrue([self.langMap isKindOfClass:[SeerDictionaryObject class]], @"TincanLanguageMap is not a SeerDictionaryObject");
}

@end

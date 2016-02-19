//
//  TincanContextTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanContext.h"

@interface TincanContextTests : XCTestCase

@property (nonatomic, strong) TincanContext* tincanContext;

@end

@implementation TincanContextTests

- (void)setUp
{
    [super setUp];
    self.tincanContext = [TincanContext new];
}

- (void)tearDown
{
    self.tincanContext = nil;
    [super tearDown];
}

- (void)testTincanContextInit
{
    XCTAssertNotNil(self.tincanContext, @"TincanContext has not been initialized with dictionary");
}

- (void)testTincanContextRevision
{
    [self.tincanContext setRevision:@"2"];
    
    XCTAssertEqualObjects(@"2", [self.tincanContext revision], @"TincanContext has problem with setting and retrieving revision");
}

- (void)testTincanContextPlatform
{
    [self.tincanContext setPlatform:@"iOS7"];
    
    XCTAssertEqualObjects(@"iOS7", [self.tincanContext platform], @"TincanContext has problem with setting and retrieving platform");
}

- (void)testTincanContextLanguage
{
    [self.tincanContext setLanguage:@"en-US"];
    
    XCTAssertEqualObjects(@"en-US", [self.tincanContext language], @"TincanContext has problem with setting and retrieving language");
}

- (void)testTincanContextExtensions
{
    [self.tincanContext setExtensionsWithAppId:@"MobilePlatformSeeriOSSDKTestApp"];
    
    XCTAssertTrue([[self.tincanContext extensions] isKindOfClass:[TincanContextExtensions class]], @"TincanContext has problem establishing as a extensions");
}

@end

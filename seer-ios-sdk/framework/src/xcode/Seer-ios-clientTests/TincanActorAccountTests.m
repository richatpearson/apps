//
//  TincanActorAccountTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanActorAccount.h"

@interface TincanActorAccountTests : XCTestCase

@property (nonatomic, strong) TincanActorAccount* tincanActorAccount;

@end

@implementation TincanActorAccountTests

- (void)setUp
{
    [super setUp];
    self.tincanActorAccount = [TincanActorAccount new];
}

- (void)tearDown
{
    self.tincanActorAccount = nil;
    [super tearDown];
}

- (void)testTincanActorAccountInit
{
    XCTAssertNotNil(self.tincanActorAccount, @"TincanActorAccount has not been initialized with dictionary");
}

- (void)testTincanActorAccountHomePage
{
    [self.tincanActorAccount setHomepage:@"http://www.pearson.com"];
    
    XCTAssertEqualObjects(@"http://www.pearson.com", [self.tincanActorAccount homePage], @"TincanActorAccount has problem with setting and retrieving homepage");
}

- (void)testTincanActorAccountName
{
    [self.tincanActorAccount setName:@"PearsonMobilePlatform"];
    
    XCTAssertEqualObjects(@"PearsonMobilePlatform", [self.tincanActorAccount name], @"TincanActorAccount has problem with setting and retrieving name");
}

@end

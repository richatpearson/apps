//
//  TincanActorTests.m
//  SEER-ios-client
//
//  Created by Tomack, Barry on 12/23/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "TincanActor.h"
#import "TincanActorAccount.h"

@interface TincanActorTests : XCTestCase

@property (nonatomic, strong) TincanActor* tincanActor;

@end

@implementation TincanActorTests

- (void)setUp
{
    [super setUp];
    
    self.tincanActor = [TincanActor new];
}

- (void)tearDown
{
    self.tincanActor = nil;
    [super tearDown];
}

- (void)testTincanActorInit
{
    XCTAssertNotNil(self.tincanActor, @"TincanActor has not been initialized with dictionary");
}

- (void)testTincanActorMBox
{
    [self.tincanActor setMbox:@"mailto:jonathan.hodges@pearson.com"];
    
    XCTAssertEqualObjects(@"mailto:jonathan.hodges@pearson.com", [self.tincanActor mbox], @"TincanActor has problem with setting and retrieving mbox");
}

- (void)testTincanActorName
{
    [self.tincanActor setName:@"Jonathan Hodges"];
    
    XCTAssertEqualObjects(@"Jonathan Hodges", [self.tincanActor name], @"TincanActor has problem with setting and retrieving name");
}

- (void)testTincanActorAccount
{
    TincanActorAccount* taAccount = [TincanActorAccount new];
    NSDictionary* dict = @{
                          @"homePage" : @"http://www.pearson.com",
                          @"name" : @"PearsonMobilePlatform"
                          };
    
    [taAccount setDictionary:dict];
    
    [self.tincanActor setAccount:taAccount];
    
    XCTAssertTrue([[self.tincanActor account] isKindOfClass:[TincanActorAccount class]], @"TincanActorAccount has problem establishing as a dictionary");
}

@end

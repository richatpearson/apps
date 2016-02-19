//
//  PGMPiIdentityTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiIdentity.h"

@interface PGMPiIdentityTests : XCTestCase

@end

@implementation PGMPiIdentityTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitIdentity
{
    NSDictionary *idDict = @{@"id":@"123456789",@"uri":@"http://pi.com/identities/123456789"};
    
    PGMPiIdentity *piIdentity = [[PGMPiIdentity alloc] initWithDictionary: idDict];
    
    XCTAssertEqualObjects(@"123456789", piIdentity.identityId, @"Error initializing PGMPiIdentity identityId");
    XCTAssertEqualObjects(@"http://pi.com/identities/123456789", piIdentity.uri, @"Error initializing PGMPiIdentity uri");
}

@end

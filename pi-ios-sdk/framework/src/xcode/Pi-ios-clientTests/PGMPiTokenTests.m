//
//  PGMPiTokenTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiToken.h"

@interface PGMPiTokenTests : XCTestCase

@end

@implementation PGMPiTokenTests

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

- (void) testTokenInit
{
    PGMPiToken *token = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                   refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                      expiresIn:1799];
    
    XCTAssertNotNil(token, @"Error intializing PiToken");
}

- (void)testIsCurrent
{
    PGMPiToken *goodToken = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                       refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                          expiresIn:1799];
    
    XCTAssertTrue([goodToken isCurrent], @"Initialized Token should be current");
}

- (void)testIsNotCurrent
{
    PGMPiToken *oldToken = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                      refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                         expiresIn:-1];
    
    XCTAssertFalse([oldToken isCurrent], @"Initialized Token should notbe current");
}


@end

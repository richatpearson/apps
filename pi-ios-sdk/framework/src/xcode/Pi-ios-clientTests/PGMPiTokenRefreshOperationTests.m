//
//  PGMPiTokenRefreshOperationTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiTokenRefreshOperation.h"
#import "PGMPiToken.h"
#import "PGMPiEnvironment.h"

@interface PGMPiTokenRefreshOperationTests : XCTestCase

@property (nonatomic, strong) PGMPiTokenRefreshOperation *tokenRefreshOp;

@end

@implementation PGMPiTokenRefreshOperationTests

- (void)setUp
{
    [super setUp];
    PGMPiToken *tokenObj = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                      refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                         expiresIn:1799];
    
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    
    self.tokenRefreshOp = [[PGMPiTokenRefreshOperation alloc] initWithClientId:@"xfTw8bxn6Cjzl3jDBX8PbOymE8jmWd4w"
                                                                    clientSecret:@"XOryHWW1K1z9DqfV"
                                                                        tokenObj:tokenObj
                                                                     environment:environment
                                                                      responseId:@(3)
                                                                     requestType:@(PiTokenRefreshRequest)];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTokenRefreshOpInit
{
    XCTAssertNotNil(self.tokenRefreshOp, @"Error intializing PGMPiTokenRefreshOperation");
}

@end

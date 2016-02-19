//
//  PGMPiEnvironmentTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/16/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PGMPiEnvironment.h"

@interface PGMPiEnvironmentTests : XCTestCase

@end

@implementation PGMPiEnvironmentTests

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testDefaultStagingEnvironment
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    
    XCTAssertEqualObjects(PGMPiDefaultBase_Staging, environment.basePiURL, @"Error initalizing environment to staging. basePiURL incorrect");
    XCTAssertEqualObjects(PGMPiEscrowDefaultBase_Staging, environment.baseEscrowURL, @"Error initalizing environment to staging. baseEscrowURL incorrect");
    XCTAssertEqualObjects(@"state", environment.state, @"Error initalizing environment to staging. state incorrect");
    XCTAssertEqualObjects(@"s2", environment.scope, @"Error initalizing environment to staging. scope incorrect");
    XCTAssertEqualObjects(@"http://int-piapi.stg-openclass.com/pioauth-int/authCode", environment.loginSuccessUrl, @"Error initalizing environment to staging. loginSuccessURL incorrect");
    XCTAssertEqualObjects(@"code", environment.responseType, @"Error initalizing environment to staging. responseType incorrect");
    
    XCTAssertEqualObjects(PGMPiLoginPath, environment.loginLocalPath, @"Error initalizing environment to staging. loginLocalPath incorrect");
}

- (void)testDefaultPoductionEnvironment
{
    PGMPiEnvironment *environment = [PGMPiEnvironment productionEnvironment];
    
    XCTAssertEqualObjects(PGMPiDefaultBase_Prod, environment.basePiURL, @"Error initalizing environment to production. basePiURL incorrect");
    XCTAssertEqualObjects(PGMPiEscrowDefaultBase_Prod, environment.baseEscrowURL, @"Error initalizing environment to production. baseEscrowURL incorrect");
    XCTAssertEqualObjects(@"state", environment.state, @"Error initalizing environment to production. state incorrect");
    XCTAssertEqualObjects(@"s2", environment.scope, @"Error initalizing environment to production. scope incorrect");
    XCTAssertEqualObjects(@"http://piapi.openclass.com/pioauth/authCode", environment.loginSuccessUrl, @"Error initalizing environment to production. loginSuccessURL incorrect");
    XCTAssertEqualObjects(@"code", environment.responseType, @"Error initalizing environment to production. responseType incorrect");
    
    XCTAssertEqualObjects(PGMPiLoginPathProd, environment.loginLocalPath, @"Error initalizing environment to production. loginLocalPath incorrect");
}

- (void)testSetCustomProperties
{
    PGMPiEnvironment *customEnv = [PGMPiEnvironment stagingEnvironment];
    
    customEnv.basePiURL = @"https://basePiURL";
    customEnv.baseEscrowURL = @"https://baseEscrowURL";
    customEnv.state = @"customState";
    customEnv.scope = @"customScope";
    customEnv.loginSuccessUrl = @"https://loginSuccessUrl";
    customEnv.responseType = @"responseType";
    
    XCTAssertEqualObjects(@"https://basePiURL", customEnv.basePiURL, @"Error setting environemnt to custom. basePiURL incorrect");
    XCTAssertEqualObjects(@"https://baseEscrowURL", customEnv.baseEscrowURL, @"Error setting environemnt to custom. baseEscrowURL incorrect");
    XCTAssertEqualObjects(@"customState", customEnv.state, @"Error setting environemnt to custom. state incorrect");
    XCTAssertEqualObjects(@"customScope", customEnv.scope, @"Error setting environemnt to custom. scope incorrect");
    XCTAssertEqualObjects(@"https://loginSuccessUrl", customEnv.loginSuccessUrl, @"Error setting environemnt to custom. loginSuccessURL incorrect");
    XCTAssertEqualObjects(@"responseType", customEnv.responseType, @"Error setting environemnt to custom. responseType incorrect");
}

- (void) testPiLoginPath
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    NSString *prodLoginPath = [NSString stringWithFormat:@"%@%@", environment.basePiURL, environment.loginLocalPath];
    
    XCTAssertEqualObjects([environment piLoginPath], prodLoginPath, @"Error with PiLogin Path. Not what was expected.");
}

- (void) testPiUserIdPathWithUsername
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    
    NSString *testName = @"Tester";
    
    NSString* userIdPath = [NSString stringWithFormat: PGMPiUserIdPath_Staging, testName];
    
    NSString *prodUserIdPath = [NSString stringWithFormat:@"%@%@", environment.basePiURL, userIdPath];
    
    XCTAssertEqualObjects([environment piUserIdPathWithUsername:testName], prodUserIdPath, @"Error with PiUserIdPath Path. Not what was expected.");
}

- (void) testPiRefreshPathHTTP
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    NSString *prodRefreshPath = [NSString stringWithFormat:@"%@%@", environment.basePiURL, PGMPiRefreshPath_Prod];
    
    XCTAssertNotEqualObjects([environment piRefreshPath], prodRefreshPath, @"Error with PiRefreshPath. Expected items to be not equal because of https.");
}

- (void) testPiRefreshPathHTTPS
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    
    NSString* httpURL = [environment.basePiURL stringByReplacingOccurrencesOfString:@"https://" withString:@"http://"];
    NSString *prodRefreshPath = [NSString stringWithFormat:@"%@%@", httpURL, PGMPiRefreshPath_Staging];
    
    XCTAssertEqualObjects([environment piRefreshPath], prodRefreshPath, @"Error with PiRefreshPath. Expected items to be equal because of https was converted to http.");
}

@end

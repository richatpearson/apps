//
//  PGMPiClientTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/15/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PGMPiCLient.h"
#import "PGMPiResponse.h"
#import "PGMPiAPIDelegate.h"

@interface PGMPiClientTests : XCTestCase

@property (nonatomic, strong) PGMPiClient *piClient;

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectUrl;

@end

@implementation PGMPiClientTests

- (void)setUp
{
    [super setUp];
    NSLog(@"..............................................SETUP");
    
    self.clientId = @"xfTw8bxn6Cjzl3jDBX8PbOymE8jmWd4w";
    self.clientSecret = @"XOryHWW1K1z9DqfV";
    self.redirectUrl = @"http://catchthis.com";
    self.piClient = [[PGMPiClient alloc] initWithClientId:self.clientId
                                             clientSecret:self.clientSecret
                                              redirectUrl:self.redirectUrl];
}

- (void)tearDown
{
    NSLog(@"..............................................TEAR DOWN");
    self.piClient = nil;
    [super tearDown];
}


- (void)testPiCLientIit
{
    XCTAssertNotNil(self.piClient, @"Error intializing PiClient");
}

- (void) testLoginWithWithNoEnvironemnt
{
    PiRequestComplete loginCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"testLoginWithWithNoEnvironemnt: %@", response.error);
    };
    
    PGMPiResponse *response = [self.piClient loginWithUsername:@"group12user"
                                                      password:@"P@ssword1"
                                                       options:nil
                                                    onComplete:loginCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestPending, @"Pi Login Request should be Pending because no environment was set so Staging should be set by default.");
}

- (void) testLoginWithStagingEnvironment
{
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    [self.piClient setEnvironment:environment];
    
    PiRequestComplete loginCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"testLoginWithWithStagingEnvironemnt: %@", response.error);
    };
    
    PGMPiResponse *response = [self.piClient loginWithUsername:@"group12user"
                                                      password:@"P@ssword1"
                                                       options:nil
                                                    onComplete:loginCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestPending, @"Pi Login Request should have been pending because environment was set to Staging.");
}

- (void) testLoginWithProductionEnvironment
{
    PGMPiEnvironment *environment = [PGMPiEnvironment productionEnvironment];
    [self.piClient setEnvironment:environment];
    
    PiRequestComplete loginCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"testLoginWithWithProductionEnvironemnt: %@", response.error);
    };
    
    PGMPiResponse *response = [self.piClient loginWithUsername:@"group12user"
                                                      password:@"P@ssword1"
                                                       options:nil
                                                    onComplete:loginCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestPending, @"Pi Login Request should have been pending because environment was set to Production.");
}

- (void) testValidAccessTokenAndOnCompleteNoTokenFailure
{
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"ValidAccessTokenCompletionHandler");
    };
    
    PGMPiResponse *response = [self.piClient validAccessTokenAndOnComplete:validTokenCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestFailure, @"Pi valid access token Request should have been failure because there's no token stored in the PiCLient.");
}

- (void) testValidAccessTokenAndOnCompleteTokenSuccess
{
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"ValidAccessTokenCompletionHandler");
    };
    
    [self.piClient tokenOpCompleteWithToken:[self getValidPiToken]
                                      error:nil
                                 responseId:@(1)
                                requestType:@(PiLoginRequest)];
    
    PGMPiResponse *response = [self.piClient validAccessTokenAndOnComplete:validTokenCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestSuccess, @"Pi valid access token Request should have been success because pi token should have been valid.");
}

- (void) testValidAccessTokenAndOnCompleteTokenFailure
{
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"ValidAccessTokenCompletionHandler");
    };
    
    [self.piClient tokenOpCompleteWithToken:[self getInvalidPiToken]
                                      error:nil
                                 responseId:@(1)
                                requestType:@(PiLoginRequest)];
    
    PGMPiResponse *response = [self.piClient validAccessTokenAndOnComplete:validTokenCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestFailure, @"Pi valid access token Request should have been failure because pi token should have been invalid.");
}

- (void) testValidAccessTokenNoTokenFailure
{
    PGMPiResponse *response = [self.piClient validAccessToken];
    
    XCTAssertEqual(response.requestStatus, PiRequestFailure, @"Pi valid access token Request should have been failure because there's no token stored in the PiCLient.");
}

- (void) testValidAccessTokenWithUserIdAndOnCompleteSuccess
{
    [self.piClient storeTokenObj:[self getValidPiToken]
                  withIdentifier:@"userId"];
    
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"ValidAccessTokenCompletionHandler");
    };
    
    PGMPiResponse *response = [self.piClient validAccessTokenWithUserId:@"userId" onComplete:validTokenCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestSuccess, @"Pi valid access token Request should have been success because pi token was valid.");
}

- (void) testValidAccessTokenWithUserIdAndOnCompleteFailure
{
    self.piClient.userId = @"userId";
    
    [self.piClient storeTokenObj:[self getInvalidPiToken]
                  withIdentifier:self.piClient.piUserId];
    
    PiRequestComplete validTokenCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"ValidAccessTokenCompletionHandler");
    };
    
    PGMPiResponse *response = [self.piClient validAccessTokenWithUserId:@"userId" onComplete:validTokenCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestPending, @"Pi valid access token Request should have been a pending because pi token was invalid and client is suppsoed to automatically get another one.");
}

- (void) testrefreshAccessTokenAndOnCompletePending
{
    self.piClient.userId = @"userId";
    
    [self.piClient storeTokenObj:[self getInvalidPiToken]
                  withIdentifier:self.piClient.piUserId];
    
    PiRequestComplete tokenRefreshCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"TokenRefreshCompletionHandler");
    };
    
    PGMPiResponse *response = [self.piClient refreshAccessTokenAndOnComplete:tokenRefreshCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestPending, @"Pi refresh token Request should have been Pending because a user id was supplied and client could attempt to get a new one.");
}

- (void) testrefreshAccessTokenAndOnCompleteFailure
{
    PiRequestComplete tokenRefreshCompletionHandler = ^(PGMPiResponse *response)
    {
        NSLog(@"TokenRefreshCompletionHandler");
    };
    
    PGMPiResponse *response = [self.piClient refreshAccessTokenAndOnComplete:tokenRefreshCompletionHandler];
    
    XCTAssertEqual(response.requestStatus, PiRequestFailure, @"Pi refresh token Request should have been a Failure because a user id was not supplied to client.");
}

- (void) testCurrentAccessTokenAfterLogout
{
    [self addUserIdCredsAndTokenToPiClient];
    
    [self.piClient logout];
    
    XCTAssertEqualObjects([self.piClient currentAccessToken], @"Bearer (null)", @"Current AccessToken should be Bearer (null) after a logout");
}

- (void) testTokenRemovedFormKeychainAfterLogout
{
    [self addUserIdCredsAndTokenToPiClient];
    
    NSString *userId = [self.piClient piUserId];
    
    [self.piClient logout];
    
    PGMPiCredentials *creds = [self.piClient retrieveCredentialsWithIdentifier:userId];
    
    XCTAssertNil(creds, @"Credentials from Keychain should be nil after logout");
}

- (void) testCredentialsRemovedFromKeychainAfterLogout
{
    [self addUserIdCredsAndTokenToPiClient];
    
    NSString *userId = [self.piClient piUserId];
    
    [self.piClient logout];
    
    PGMPiCredentials *creds = [self.piClient retrieveCredentialsWithIdentifier:userId];
    
    XCTAssertNil(creds, @"Credentials from Keychain should be nil after logout");
}

- (void) testTokenRemovedFromKeychainAfterLogout
{
    [self addUserIdCredsAndTokenToPiClient];
    
    NSString *userId = [self.piClient piUserId];
    
    [self.piClient logout];
    
    PGMPiToken *token = [self.piClient retrieveTokenObjWithIdentifier:userId];
    
    XCTAssertNil(token, @"Token Object from Keychain should be nil after logout");
}

- (void) testIsLoggedOut
{
    [self addUserIdCredsAndTokenToPiClient];
    
    [self.piClient logout];
    
    BOOL isLoggedOut = [self.piClient isLoggedOut];
    
    XCTAssertTrue(isLoggedOut, @"Expected to be logged out");
}

- (void) testIsLoggedOut_noPiUserID
{
    BOOL isLoggedOut = [self.piClient isLoggedOut];
    
    XCTAssertTrue(isLoggedOut, @"Expected to be logged out");
}

- (void) testNotIsLoggedOut
{
    [self addUserIdCredsAndTokenToPiClient];

    BOOL isLoggedOut = [self.piClient isLoggedOut];
    
    XCTAssertFalse(isLoggedOut, @"Expected to still be logged in");
}

- (PGMPiToken*) getValidPiToken
{
    PGMPiToken *token = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                   refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                      expiresIn:1799];
    return token;
}

- (PGMPiToken *) getInvalidPiToken
{
    PGMPiToken *oldToken = [[PGMPiToken alloc] initWithAccessToken:@"IfpP3bjVoL4jnGFvreprBGSHdGlv"
                                                      refreshToken:@"I7Zs1VuDExurRXB5zHgdnjGUANP1BLHN"
                                                         expiresIn:-1];
    return oldToken;
}

- (void) addUserIdCredsAndTokenToPiClient
{
    self.piClient.userId = @"123456";
    
    [self.piClient tokenOpCompleteWithToken:[self getValidPiToken]
                                      error:nil
                                 responseId:@(1)
                                requestType:@(PiLoginRequest)];
    
    [self.piClient storeTokenObj:[self getValidPiToken]
                  withIdentifier:self.piClient.piUserId];
    
    PGMPiCredentials *creds = [PGMPiCredentials credentialsWithUsername:@"UserName" password:@"Password1"];
    
    [self.piClient storeCredentials:creds withIdentifier:@"123456"];
}

@end

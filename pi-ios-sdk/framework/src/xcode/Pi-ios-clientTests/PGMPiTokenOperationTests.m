//
//  PGMPiTokenOperationTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiTokenOperation.h"
#import "PGMPiEnvironment.h"

@interface PGMPiTokenOperationTests : XCTestCase

@property (nonatomic, strong) NSOperationQueue * testOpQueue;
@property (nonatomic, strong) PGMPiTokenOperation *tokenOp;

@property (nonatomic, strong) NSString *clientId;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *redirectUrl;

@end

@implementation PGMPiTokenOperationTests

- (void)setUp
{
    [super setUp];
    self.testOpQueue = [[NSOperationQueue alloc] init];
    [self.testOpQueue setMaxConcurrentOperationCount:1];
    
    self.clientId = @"xfTw8bxn6Cjzl3jDBX8PbOymE8jmWd4w";
    self.clientSecret = @"XOryHWW1K1z9DqfV";
    self.redirectUrl = @"http://catchthis.com";
    
    self.tokenOp = [[PGMPiTokenOperation alloc] initWithClientId:self.clientId
                                                     redirectUrl:self.redirectUrl
                                                        username:@"group12user"
                                                        password:@"P@ssword1"
                                                     environment:[PGMPiEnvironment stagingEnvironment]
                                                      responseId:@(1)
                                                     requestType:@(PiLoginRequest)];
}

- (void)tearDown
{
    self.testOpQueue = nil;
    self.tokenOp = nil;
    [super tearDown];
}

- (void)testTokenOpInit
{
    XCTAssertNotNil(self.tokenOp, @"Error intializing PGMPiTokenOperation");
}

@end

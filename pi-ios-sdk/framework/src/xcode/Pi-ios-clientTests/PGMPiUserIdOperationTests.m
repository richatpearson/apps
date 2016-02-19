//
//  PGMPiUserIdOperationTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiUserIdOperation.h"
#import "PGMPiCredentials.h"
#import "PGMPiEnvironment.h"

@interface PGMPiUserIdOperationTests : XCTestCase

@property (nonatomic, strong) PGMPiUserIdOperation *userIdOp;

@end

@implementation PGMPiUserIdOperationTests

- (void)setUp
{
    [super setUp];
    PGMPiCredentials *credentials = [PGMPiCredentials credentialsWithUsername:@"group12user"
                                                                     password:@"P@ssword"];
    PGMPiEnvironment *environment = [PGMPiEnvironment stagingEnvironment];
    
    self.userIdOp = [[PGMPiUserIdOperation alloc] initWithCredentials:credentials
                                                          environment:environment
                                                           responseId:@(1)
                                                          requestType:@(PiLoginRequest)];
}

- (void)tearDown
{
    self.userIdOp = nil;
    [super tearDown];
}

- (void)testUserIdOpInit
{
    XCTAssertNotNil(self.userIdOp, @"Error intializing PGMPiUserIdOperation");
}

@end

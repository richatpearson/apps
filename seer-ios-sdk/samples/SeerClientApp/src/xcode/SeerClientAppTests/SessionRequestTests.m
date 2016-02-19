//
//  SeerClientAppTests.m
//  SeerClientAppTests
//
//  Created by Tomack, Barry on 1/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "SessionRequest.h"
#import <Seer-ios-client/SeerClient.h>

@interface SessionRequestTests : XCTestCase

@property (nonatomic, strong) SessionRequest* sessionRequest;

@end

@implementation SessionRequestTests

- (void)setUp
{
    [super setUp];
    self.sessionRequest = [SessionRequest new];
}

- (void)tearDown
{
    self.sessionRequest = nil;
    [super tearDown];
}

- (void)testSeerRequestStatusToString
{
    XCTAssertEqualObjects(@"pending", [self.sessionRequest seerRequestStatusToString:kRequestStatusPending], @"SessionRequest not converting Seer Request statuses to string properly");
    XCTAssertEqualObjects(@"failure", [self.sessionRequest seerRequestStatusToString:kRequestStatusFailure], @"SessionRequest not converting Seer Request statuses to string properly");
    XCTAssertEqualObjects(@"error", [self.sessionRequest seerRequestStatusToString:kRequestStatusError], @"SessionRequest not converting Seer Request statuses to string properly");
    XCTAssertEqualObjects(@"success", [self.sessionRequest seerRequestStatusToString:kRequestStatusSuccess], @"SessionRequest not converting Seer Request statuses to string properly");
}

- (void)testSeerRequestStatusStringToEnum
{
    XCTAssertEqual(kRequestStatusPending, [self.sessionRequest seerRequestStatusStringToEnum:@"pending"], @"SessionRequest not converting Seer Request string 'pending' to enum properly");
    XCTAssertEqual(kRequestStatusFailure, [self.sessionRequest seerRequestStatusStringToEnum:@"failure"], @"SessionRequest not converting Seer Request string 'failure' to enum properly");
    XCTAssertEqual(kRequestStatusError, [self.sessionRequest seerRequestStatusStringToEnum:@"error"], @"SessionRequest not converting Seer Request string 'error' to enum properly");
    XCTAssertEqual(kRequestStatusSuccess, [self.sessionRequest seerRequestStatusStringToEnum:@"success"], @"SessionRequest not converting Seer Request string 'success' to enum properly");
}

- (void) testGetRequestTypeAbbreviation
{
    self.sessionRequest.requestType = kSEER_ActivityStreamReport;
    XCTAssertEqualObjects(@"AS", [self.sessionRequest getRequestTypeAbbreviation], @"SessionRequest not return correct abbreviation for Activity Stream");
    
    self.sessionRequest.requestType = kSEER_TincanReport;
    XCTAssertEqualObjects(@"TC", [self.sessionRequest getRequestTypeAbbreviation], @"SessionRequest not return correct abbreviation for Tincan");
}



@end

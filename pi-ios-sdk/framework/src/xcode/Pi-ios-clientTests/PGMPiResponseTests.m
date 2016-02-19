//
//  PGMPiResponseTests.m
//  Pi-ios-client
//
//  Created by Tomack, Barry on 7/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMPiResponse.h"

@interface PGMPiResponseTests : XCTestCase

@end

@implementation PGMPiResponseTests

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

- (void)testResponseInit
{
    PGMPiResponse *response =[self createNewResponseForRequest:PiLoginRequest];
    XCTAssertNotNil(response, @"Error intializing PiResponse");
}

- (void) testResponseIdIncrement
{
    PGMPiResponse *response1 =[self createNewResponseForRequest:PiLoginRequest];
    
    NSInteger id1 = [response1.piResponseId integerValue];
    
    PGMPiResponse *response2 =[self createNewResponseForRequest:PiLoginRequest];
    
    NSInteger id2 = [response2.piResponseId integerValue];
    
    XCTAssertTrue((id2 > id1), @"Error with Response id being incremented");
}

- (void) testSettingAnObjectForOperation
{
    PGMPiResponse *response = [self createNewResponseForRequest:PiLoginRequest];
    
    NSDictionary *opResponseObj = @{@"id":@"123456789",@"uri":@"http://pi.com/identities/123456789"};
    
    NSUInteger preDictCount = response.count;
    
    [response setObject:opResponseObj forOperationType:PiTokenOp];
    
    NSUInteger postDictCount = response.count;
    
    XCTAssertTrue(postDictCount = preDictCount + 1, @"Error setting objects in response dictionary");
}

- (void) testGettingAnObjectForOperation
{
    PGMPiResponse *response = [self createNewResponseForRequest:PiLoginRequest];
    
    NSDictionary *setResponseObj = @{@"id":@"123456789",@"uri":@"http://pi.com/identities/123456789"};
    
    [response setObject:setResponseObj forOperationType:PiTokenOp];
    
    NSDictionary *getResponseObj = [response getObjectForOperationType:PiTokenOp];
    
    XCTAssertEqualObjects(setResponseObj, getResponseObj, @"Error retrieving object from response dictionary");
}

- (PGMPiResponse*) createNewResponseForRequest:(PGMPiRequestType)requestType
{
    PGMPiResponse* response = [PGMPiResponse new];
    response.requestType = requestType;
    response.requestStatus = PiRequestPending;
    
    response.accessToken = @"0987654321";
    response.userId = @"1234567890";
    
    return response;
}

@end

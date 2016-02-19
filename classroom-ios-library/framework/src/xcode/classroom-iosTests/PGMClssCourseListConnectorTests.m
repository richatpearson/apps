//
//  PGMClssCourseListConnectorTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseListConnector.h"
#import "PGMClssEnvironment.h"
#import "PGMClssCourseStructureConnector.h"
#import <OCMock/OCMock.h>

@interface PGMClssCourseListConnectorTests : XCTestCase

@property (nonatomic, strong) NSString *userIdentityId;
@property (nonatomic, strong) NSString *userToken;

@property (nonatomic, strong) CourseListNetworkRequestComplete courseListNetworkCompletionHandler;

@end

@implementation PGMClssCourseListConnectorTests

//static const NSTimeInterval kRunLoopSamplingInterval = 0.01;

- (void)setUp
{
    [super setUp];
    self.userIdentityId = @"ffffffff5364096be4b06dc3168baa33";
    self.userToken = @"dummyToken123";
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testRunCourseListRequestForUser_MissingEnvironment_Error
{
    __block BOOL responseArrived = NO;
    
    self.courseListNetworkCompletionHandler = ^(PGMClssCourseListResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
        responseArrived = YES;
    };
    
    PGMClssCourseListConnector *courseListConnector = [PGMClssCourseListConnector new];
    PGMClssCourseListResponse *response = [PGMClssCourseListResponse new];
    
    [courseListConnector runCourseListRequestForUser:self.userIdentityId
                                            andToken:self.userToken
                                      forEnvironment:nil
                                        withResponse:response
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    XCTAssert(responseArrived);
    XCTAssertNotNil(response.error);
    XCTAssertEqual(4, response.error.code);
    XCTAssertNil(response.courseListArray);
    
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssNoEnvironment];
    
    response = [PGMClssCourseListResponse new];
    
    [courseListConnector runCourseListRequestForUser:self.userIdentityId
                                            andToken:self.userToken
                                      forEnvironment:env
                                        withResponse:response
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    XCTAssert(responseArrived);
    XCTAssertNotNil(response.error);
    XCTAssertEqual(4, response.error.code);
    XCTAssertNil(response.courseListArray);
    
    env.baseRequestCourseListUrl = @"";
    response = [PGMClssCourseListResponse new];
    [courseListConnector runCourseListRequestForUser:self.userIdentityId
                                            andToken:self.userToken
                                      forEnvironment:env
                                        withResponse:response
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    XCTAssert(responseArrived);
    XCTAssertNotNil(response.error);
    XCTAssertEqual(4, response.error.code);
    XCTAssertNil(response.courseListArray);
}

- (void)testRunCourseListRequestForUser_WithMock_Error
{
    __block BOOL responseArrived = NO;
    __block PGMClssCourseListResponse *responseInBlock;
    
    self.courseListNetworkCompletionHandler = ^(PGMClssCourseListResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
        responseArrived = YES;
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    id mockCoreSessionManager = OCMClassMock([PGMCoreSessionManager class]);
    
    OCMStub([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                             progressHandler:[OCMArg any]
                                           completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, nil, [[NSError alloc] initWithDomain:@"testClssDomain" code:99 userInfo:nil]);
    })
    .andReturn(operation);
    
    OCMExpect([mockCoreSessionManager addOperationToQueue:operation]);
    
    PGMClssCourseListConnector *courseListConnector = [PGMClssCourseListConnector new];
    PGMClssCourseListResponse *response = [PGMClssCourseListResponse new];
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    
    courseListConnector.coreSessionManager = mockCoreSessionManager;
    
    [courseListConnector runCourseListRequestForUser:self.userIdentityId
                                            andToken:self.userToken
                                      forEnvironment:env
                                        withResponse:response
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(3, responseInBlock.error.code);
    
    XCTAssert(responseArrived);
    XCTAssertNotNil(response.error);
    XCTAssertEqual(0, [response.courseListArray count]);
    
    OCMVerify([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                               progressHandler:[OCMArg any]
                                             completionHandler:[OCMArg any]]);
    
    OCMVerify([mockCoreSessionManager addOperationToQueue:operation]);
}

- (void)testRunCourseListRequestForUser_WithMock_Success
{
    __block PGMClssCourseListResponse *responseInBlock;
    
    self.courseListNetworkCompletionHandler = ^(PGMClssCourseListResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete for course list response - error");
        } else {
            NSLog(@"OnComplete for course list response - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    id mockCoreSessionManager = OCMClassMock([PGMCoreSessionManager class]);
    
    OCMStub([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                            progressHandler:[OCMArg any]
                                           completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, [self createReturnedDataForCourseListOperation], nil);
    })
    .andReturn(operation);
    
    OCMExpect([mockCoreSessionManager addOperationToQueue:operation]);
    
    PGMClssCourseListConnector *courseListConnector = [PGMClssCourseListConnector new];
    PGMClssCourseListResponse *response = [PGMClssCourseListResponse new];
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    
    courseListConnector.coreSessionManager = mockCoreSessionManager;
    
    [courseListConnector runCourseListRequestForUser:self.userIdentityId
                                            andToken:self.userToken
                                      forEnvironment:env
                                        withResponse:response
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    NSLog(@"In block course list response has %ld items", (long)[responseInBlock.courseListArray count]);
    NSLog(@"Ref param course list response has %ld items", (long)[response.courseListArray count]);
    
    XCTAssertNotNil(responseInBlock.courseListArray);
    XCTAssertEqual(2, [responseInBlock.courseListArray count]);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertNotNil(response.courseListArray);
    XCTAssertNil(response.error);
    XCTAssertEqual(2, [response.courseListArray count]);
    
    OCMVerify([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                               progressHandler:[OCMArg any]
                                             completionHandler:[OCMArg any]]);
    
    OCMVerify([mockCoreSessionManager addOperationToQueue:operation]);
}

- (NSData*) createReturnedDataForCourseListOperation
{
    NSString *itemId1       = @"abc123";
    NSString *status        = @"active";
    NSString *sectionId1    = @"section11";
    NSString *sectionTitle1 = @"My Fine Arts course";
    NSString *sectionCode1  = @"Code 1";
    NSString *startDate1    = @"2014-09-03T07:00:00.000Z";
    NSString *endDate1      = @"2014-11-25T07:00:00.000Z";
    NSString *courseId1     = @"course123";
    NSString *courseType    = @"gridmobile";
    NSString *avatarUrl1    = @"http://avatar1.com";
    
    NSString *itemId2       = @"def456";
    NSString *sectionId2    = @"section22";
    NSString *sectionTitle2 = @"Algebra 100";
    NSString *sectionCode2  = @"Code 2";
    NSString *startDate2    = @"2014-09-17T09:00:00.000Z";
    NSString *endDate2      = @"2014-12-11T09:30:00.000Z";
    NSString *courseId2     = @"course456";
    NSString *avatarUrl2    = @"http://avatar2.com";
    
    NSString *jsonString = [NSString stringWithFormat:@"[{\"id\": \"%@\", \"status\": \"%@\", \"section\": {\"sectionId\": \"%@\",\"sectionTitle\": \"%@\",\"sectionCode\": \"%@\",\"startDate\": \"%@\",\"endDate\": \"%@\",\"courseId\": \"%@\",\"courseType\": \"%@\",\"avatarUrl\": \"%@\"}},{\"id\": \"%@\", \"status\": \"%@\", \"section\": {\"sectionId\": \"%@\",\"sectionTitle\": \"%@\", \"sectionCode\": \"%@\",\"startDate\": \"%@\",\"endDate\": \"%@\",\"courseId\": \"%@\",\"courseType\": \"%@\",\"avatarUrl\": \"%@\"}}]", itemId1, status, sectionId1, sectionTitle1, sectionCode1, startDate1, endDate1, courseId1, courseType, avatarUrl1, itemId2, status, sectionId2, sectionTitle2, sectionCode2, startDate2, endDate2, courseId2, courseType, avatarUrl2];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

@end

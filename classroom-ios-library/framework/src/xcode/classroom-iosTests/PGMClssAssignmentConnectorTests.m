//
//  PGMClssAssignmentConnectorTests.m
//  classroom-ios
//
//  Created by Joe Miller on 10/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "PGMClssAssignmentConnector.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssAssignmentResponse.h"

@interface PGMClssAssignmentConnectorTests : XCTestCase

@property (strong, nonatomic) NSString *token;
@property (strong, nonatomic) PGMClssEnvironment *environment;
@property (strong, nonatomic) AssignmentNetworkRequestComplete assignmentRequestCompletionHandler;

@end

@implementation PGMClssAssignmentConnectorTests

- (void)setUp
{
    [super setUp];
    self.token = @"dummyToken123";
    
    self.environment = [PGMClssEnvironment new];
    self.environment.baseRequestCourseStructUrl = @"baseRequestCourseStructUrl";
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testRunAssignmentsWithActivitiesRequestWithToken
{
    __block PGMClssAssignmentResponse *responseBlock;
    PGMClssAssignmentConnector *sut = [PGMClssAssignmentConnector new];
    PGMClssAssignmentResponse *response = [PGMClssAssignmentResponse new];
    
    id mockCourseListItem = OCMClassMock([PGMClssCourseListItem class]);
    OCMStub([mockCourseListItem sectionId]).andReturn(@"123");
    
    self.assignmentRequestCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        responseBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [NSOperation new];
    
    id mockCoreSessionManager = OCMClassMock([PGMCoreSessionManager class]);
    
    OCMStub([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                             progressHandler:[OCMArg any]
                                           completionHandler:[OCMArg any]])
        .andDo(^(NSInvocation *invocation) {
            void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                               NSData *data,
                                               NSError *error);
            [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
            DidCompleteWithErrorHandler(nil, [self responseData], nil);
        })
        .andReturn(operation);
    OCMExpect([mockCoreSessionManager addOperationToQueue:operation]);
    
    sut.coreSessionManager = mockCoreSessionManager;
    [sut runAssignmentsWithActivitiesRequestWithToken:self.token
                                            forCourse:mockCourseListItem
                                       andEnvironment:self.environment
                                         withResponse:response
                                           onComplete:self.assignmentRequestCompletionHandler];

    OCMVerify([mockCourseListItem sectionId]);
    XCTAssertNotNil(responseBlock, @"Expected response.");
    XCTAssertNotNil(responseBlock.assignmentsArray, @"Expected returned assignments.");
    XCTAssertTrue(responseBlock.assignmentsArray.count == 2, @"Expected 2 assignments.");
    OCMVerify([mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                               progressHandler:[OCMArg any]
                                             completionHandler:[OCMArg any]]);
    OCMVerify([mockCoreSessionManager addOperationToQueue:operation]);
}

- (void)testRunAssignmentsWithActivitiesRequestWithToken_invalidEnvironment_error
{
    __block NSError *responseError;
    PGMClssAssignmentConnector *sut = [PGMClssAssignmentConnector new];
    PGMClssAssignmentResponse *response = [PGMClssAssignmentResponse new];
    
    id mockCourseListItem = OCMClassMock([PGMClssCourseListItem class]);
    OCMStub([mockCourseListItem sectionId]).andReturn(@"123");
    
    self.assignmentRequestCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
            responseError = response.error;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [NSOperation new];
    
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
    
    sut.coreSessionManager = mockCoreSessionManager;
    [sut runAssignmentsWithActivitiesRequestWithToken:self.token
                                            forCourse:mockCourseListItem
                                       andEnvironment:nil
                                         withResponse:response
                                           onComplete:self.assignmentRequestCompletionHandler];

    XCTAssertNotNil(responseError, @"Expected not nil error.");
}

- (NSData *)responseData
{
    NSString *aID1 = @"assignmentID1";
    NSString *aTitle1 = @"aTitle1";
    NSString *aTemplateID1 = @"aTemplateID1";
    NSString *aDescription1 = @"aDescription1";
    NSString *aLastModified1 = @"2014-01-01T23:59:59.000Z";
    
    NSString *aID2 = @"assignmentID2";
    NSString *aTitle2 = @"aTitle2";
    NSString *aTemplateID2 = @"aTemplateID2";
    NSString *aDescription2 = @"aDescription2";
    NSString *aLastModified2 = @"2014-02-02T23:59:59.000Z";
    
    NSString *aaID1 = @"aaID1";
    NSString *aaTitle1 = @"aaTitle1";
    NSString *aaDueDate1 = @"2014-01-01T23:59:59.000Z";
    NSString *aaThumbnailURL1 = @"aaThumbnailURL1";
    NSString *aaDescription1 = @"aaDescription1";
    NSString *aaLastModifiedDate1 = @"2014-01-01T23:59:59.000Z";
    
    NSString *aaID2 = @"aaID2";
    NSString *aaTitle2 = @"aaTitle2";
    NSString *aaDueDate2 = @"2014-02-02T23:59:59.000Z";
    NSString *aaThumbnailURL2 = @"aaThumbnailURL2";
    NSString *aaDescription2 = @"aaDescription2";
    NSString *aaLastModifiedDate2 = @"2014-02-02T23:59:59.000Z";
    
    NSString *json = [NSString stringWithFormat:@"{ \"_embedded\": { \"assignments\": [ { \"id\": \"%@\", \"title\": \"%@\", \"templateId\": \"%@\", \"description\": \"%@\", \"context\": [ { \"type\": \"ignored\", \"id\": \"ignored\" } ], \"lastModified\": \"%@\", \"_embedded\": { \"activities\": [ { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } } ] }, \"_links\": { \"self\": { \"href\": \"ignored\" }, \"activities\": { \"href\": \"ignored\" } } }, { \"id\": \"%@\", \"title\": \"%@\", \"templateId\": \"%@\", \"description\": \"%@\", \"context\": [ { \"type\": \"ignored\", \"id\": \"ignored\" } ], \"lastModified\": \"%@\", \"_embedded\": { \"activities\": [ { \"id\": \"%@\", \"title\": \"%@\", \"content\": { \"type\": \"ignored\", \"id\": \"ignored\", \"href\": \"ignored\" }, \"dueDate\": \"%@\", \"thumbnailUrl\": \"%@\", \"description\": \"%@\", \"lastModifiedDate\": \"%@\", \"_links\": { \"self\": { \"href\": \"ignored\" } } } ] }, \"_links\": { \"self\": { \"href\": \"ignored\" }, \"activities\": { \"href\": \"ignored\" } } } ] } }",
                      aID1,
                      aTitle1,
                      aTemplateID1,
                      aDescription1,
                      aLastModified1,
                      aaID1,
                      aaTitle1,
                      aaDueDate1,
                      aaThumbnailURL1,
                      aaDescription1,
                      aaLastModifiedDate1,
                      aID2,
                      aTitle2,
                      aTemplateID2,
                      aDescription2,
                      aLastModified2,
                      aaID2,
                      aaTitle2,
                      aaDueDate2,
                      aaThumbnailURL2,
                      aaDescription2,
                      aaLastModifiedDate2
      ];
    
    return [json dataUsingEncoding:NSUTF8StringEncoding];
}

@end

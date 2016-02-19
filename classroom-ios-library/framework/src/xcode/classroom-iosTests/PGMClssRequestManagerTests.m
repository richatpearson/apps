//
//  PGMClssRequestManagerTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssRequestManager.h"
#import "PGMClssCustomEnvironment.h"
#import "PGMClssCourseStructureItem.h"
#import <OCMock/OCMock.h>
#import "PGMClssCourseLIstConnector.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssCourseStructureConnector.h"
#import "PGMClssAssignmentResponse.h"
#import "PGMClssAssignmentConnector.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssAssignment.h"

@interface PGMClssRequestManagerTests : XCTestCase

@property (nonatomic, strong) NSString *userIdentityId;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *sectionId;
@property (nonatomic, strong) NSString *itemId;

@property (nonatomic, strong) CourseListRequestComplete courseListCompletionHandler;
@property (nonatomic, strong) CourseStructRequestComplete courseStructCompletionHandler;
@property (nonatomic, strong) AssignmentRequestComplete assignmentCompletionHandler;
@property (nonatomic, strong) PGMClssRequestManager *requestManager;
@property (nonatomic, strong) PGMClssEnvironment *environment;

@end

@implementation PGMClssRequestManagerTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.userIdentityId = @"ffffffff5364096be4b06dc3168baa33";
    self.userToken      = @"abc123";
    self.sectionId      = @"53d7d05ae4b0ac0197a2ced2";
    self.itemId         = @"a4750f50-17fc-11e4-a475-83b611b71aae";
    
    
    self.requestManager = [[PGMClssRequestManager alloc] initWithFetchPolicy:PGMClssNetworkFirst];
    self.environment = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    [self.requestManager setEnvironment:self.environment];

}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testInitManager
{
    XCTAssertNotNil(self.requestManager.clssEnvironment);
    XCTAssertEqualObjects(PGMClssDefaultBaseCourseList_Staging, self.requestManager.clssEnvironment.baseRequestCourseListUrl);
    
    PGMClssCustomEnvironment *customEnv = [PGMClssCustomEnvironment new];
    NSString *customBaseUrl = @"http://myOwnBaseUrl";
    customEnv.customBaseRequestCourseListUrl = customBaseUrl;
    
    self.environment = [[PGMClssEnvironment alloc] initWithCustomEnvironment:customEnv];
    
    [self.requestManager setEnvironment:self.environment];
    
    XCTAssertNotNil(self.requestManager.clssEnvironment);
    XCTAssertEqualObjects(customBaseUrl, self.requestManager.clssEnvironment.baseRequestCourseListUrl);
}

#pragma mark - Course List Tests

- (void)testGetCourseListForUser_EmptyToken_Error
{
    self.courseListCompletionHandler = ^(PGMClssCourseListResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    self.userToken = nil;
    
    PGMClssCourseListResponse *courseListResponse =
        [self.requestManager getCourseListForUser:self.userIdentityId
                                        withToken:self.userToken
                                       onComplete:self.courseListCompletionHandler];

    XCTAssertNotNil(courseListResponse.error);
    XCTAssertEqual(1, courseListResponse.error.code);
    
    self.userToken = @"";
    
    courseListResponse = [self.requestManager getCourseListForUser:self.userIdentityId
                                                         withToken:self.userToken
                                                        onComplete:self.courseListCompletionHandler];
    
    XCTAssertNotNil(courseListResponse.error);
    XCTAssertEqual(1, courseListResponse.error.code);
}

- (void) testGetCourseListForUser_EmptyUserId_Error
{
    self.courseListCompletionHandler = ^(PGMClssCourseListResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    self.userIdentityId = nil;
    
    PGMClssCourseListResponse *courseListResponse =
        [self.requestManager getCourseListForUser:self.userIdentityId
                                        withToken:self.userToken
                                       onComplete:self.courseListCompletionHandler];
    
    XCTAssertNotNil(courseListResponse.error);
    XCTAssertEqual(0, courseListResponse.error.code);
    
    self.userIdentityId = @"";
    
    courseListResponse = [self.requestManager getCourseListForUser:self.userIdentityId
                                                         withToken:self.userToken
                                                        onComplete:self.courseListCompletionHandler];
    
    XCTAssertNotNil(courseListResponse.error);
    XCTAssertEqual(0, courseListResponse.error.code);

}

- (void) testGetCourseListForUser_WithMock_Success
{
    __block PGMClssCourseListResponse *responseInBlock;
    
    self.courseListCompletionHandler = ^(PGMClssCourseListResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete from mock - error");
        } else {
            NSLog(@"OnComplete from mock - success!");
            NSLog(@"The repsponse returned via blocks has %ld item(s)", (long)[response.courseListArray count]);
        }
    };
    
    id mockCourseListConnector = OCMClassMock([PGMClssCourseListConnector class]);
    
    OCMStub([mockCourseListConnector runCourseListRequestForUser:self.userIdentityId
                                                        andToken:self.userToken
                                                  forEnvironment:[OCMArg any]
                                                    withResponse:[OCMArg any]
                                                      onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
            PGMClssCourseListResponse *mockResponse;
            [invocation getArgument:&mockResponse atIndex:5];
            [self createItemsForCourseListMockResponseParam:&mockResponse];
            void (^CourseListNetworkRequestComplete)(PGMClssCourseListResponse*);
            [invocation getArgument:&CourseListNetworkRequestComplete atIndex:6];
            CourseListNetworkRequestComplete(mockResponse);
    });
    
    
    
    self.requestManager.courseListConnector = mockCourseListConnector;
    
    PGMClssCourseListResponse *courseListResponse =
    [self.requestManager getCourseListForUser:self.userIdentityId
                                    withToken:self.userToken
                                   onComplete:self.courseListCompletionHandler];
    
    NSLog(@"Returned obj courseListResponse has %ld items.", (long)[courseListResponse.courseListArray count]);
    
    XCTAssertNotNil(responseInBlock.courseListArray);
    XCTAssertEqual(2, [responseInBlock.courseListArray count]);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertNotNil(courseListResponse.courseListArray);
    XCTAssertEqual(2, [courseListResponse.courseListArray count]);
    XCTAssertNil(courseListResponse.error);
    
    OCMVerify([mockCourseListConnector runCourseListRequestForUser:self.userIdentityId
                                                          andToken:self.userToken
                                                    forEnvironment:[OCMArg any]
                                                      withResponse:[OCMArg any]
                                                        onComplete:[OCMArg any]]);
}

- (void) createItemsForCourseListMockResponseParam:(PGMClssCourseListResponse**)response
{
    PGMClssCourseListItem *firstItem = [PGMClssCourseListItem new];
    firstItem.itemId = @"1234";
    firstItem.sectionId = @"section1122";
    firstItem.sectionTitle = @"mySection1";
    
    PGMClssCourseListItem *secondItem = [PGMClssCourseListItem new];
    secondItem.itemId = @"5678";
    secondItem.sectionId = @"section3344";
    secondItem.sectionTitle = @"mySection2";
    
    NSMutableArray *itemArray = [[NSMutableArray alloc] init];
    [itemArray addObject:firstItem];
    [itemArray addObject:secondItem];
    
    [*response setCourseListArray:itemArray];
}

- (void) testGetCourseListForUser_WithMock_Error
{
    __block PGMClssCourseListResponse *responseInBlock;
    
    self.courseListCompletionHandler = ^(PGMClssCourseListResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete from mock - error");
        } else {
            NSLog(@"OnComplete from mock - success!");
        }
    };
    
    id mockCourseListConnector = OCMClassMock([PGMClssCourseListConnector class]);
    
    OCMStub([mockCourseListConnector runCourseListRequestForUser:self.userIdentityId
                                                        andToken:self.userToken
                                                  forEnvironment:[OCMArg any]
                                                    withResponse:[OCMArg any]
                                                      onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseListResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:5];
        [self createErrorForCourseListMockResponseParam:&mockResponse];
        void (^CourseListNetworkRequestComplete)(PGMClssCourseListResponse*);
        [invocation getArgument:&CourseListNetworkRequestComplete atIndex:6];
        CourseListNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseListConnector = mockCourseListConnector;
    
    PGMClssCourseListResponse *courseListResponse =
    [self.requestManager getCourseListForUser:self.userIdentityId
                                    withToken:self.userToken
                                   onComplete:self.courseListCompletionHandler];
    
    NSLog(@"The error code in response is %ld", (long)courseListResponse.error.code);
    
    XCTAssertNil(responseInBlock.courseListArray);
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
    
    XCTAssertNil(courseListResponse.courseListArray);
    XCTAssertNotNil(courseListResponse.error);
    XCTAssertEqual(1, courseListResponse.error.code);

    
    OCMVerify([mockCourseListConnector runCourseListRequestForUser:self.userIdentityId
                                                          andToken:self.userToken
                                                    forEnvironment:[OCMArg any]
                                                      withResponse:[OCMArg any]
                                                        onComplete:[OCMArg any]]);
}

- (void) createErrorForCourseListMockResponseParam:(PGMClssCourseListResponse**)response
{
    NSError *error = [[NSError alloc] initWithDomain:@"testClssDomain" code:1 userInfo:nil];
    [*response setError:error];
}

#pragma mark - Course Structure Tests

- (void) testGetCourseStructureWithToken_missingToken_Error
{
    __block BOOL responseError = NO;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
            responseError = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    self.userToken = nil;
    
    PGMClssCourseStructureResponse *courseStructResponse =
        [self.requestManager getCourseStructureWithToken:self.userToken
                                              forSection:self.sectionId
                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    self.userToken = @"";
    
    courseStructResponse = [self.requestManager getCourseStructureWithToken:self.userToken
                                                                 forSection:self.sectionId
                                                                 onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssert(responseError);
}

- (void) testGetCourseStructureWithToken_missingSectionId_Error
{
    __block BOOL responseError = NO;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
            responseError = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    self.sectionId = nil;
    
    PGMClssCourseStructureResponse *courseStructResponse =
    [self.requestManager getCourseStructureWithToken:self.userToken
                                          forSection:self.sectionId
                                          onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    self.sectionId = @"";
    
    courseStructResponse = [self.requestManager getCourseStructureWithToken:self.userToken
                                                                 forSection:self.sectionId
                                                                 onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssert(responseError);
}

- (void) testGetCourseStructureWithToken_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runCourseStructRequestWithToken:self.userToken
                                                            forSection:self.sectionId
                                                        andEnvironment:[OCMArg any]
                                                          withResponse:[OCMArg any]
                                                            onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:5];
        [self createItemsForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:6];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *courseStructResponse =
        [self.requestManager getCourseStructureWithToken:self.userToken
                                              forSection:self.sectionId
                                              onComplete:self.courseStructCompletionHandler];
    
    NSLog(@"The returned resposne has %ld items", (long)[courseStructResponse.courseStructureArray count]);
    NSLog(@"The resposne in block has %ld items", (long)[responseInBlock.courseStructureArray count]);
    
    XCTAssertEqual(2, [responseInBlock.courseStructureArray count]);
    XCTAssertEqual(PGMClssParentItems, responseInBlock.responseType);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertEqual(2, [courseStructResponse.courseStructureArray count]);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssertNil(courseStructResponse.error);
    
    OCMVerify([mockCourseStructConnector runCourseStructRequestWithToken:self.userToken
                                                              forSection:self.sectionId
                                                          andEnvironment:[OCMArg any]
                                                            withResponse:[OCMArg any]
                                                              onComplete:[OCMArg any]]);
}

- (void) createItemsForCourseStructMockResponseParam:(PGMClssCourseStructureResponse**)response
{
    PGMClssCourseStructureItem *firstItem = [PGMClssCourseStructureItem new];
    firstItem.courseStructureItemId = @"12345";
    firstItem.title = @"My first course struct item title";
    
    PGMClssCourseStructureItem *secondItem = [PGMClssCourseStructureItem new];
    secondItem.courseStructureItemId = @"6789";
    secondItem.title = @"My second course struct item title";
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:firstItem];
    [items addObject:secondItem];
    
    [*response setCourseStructureArray:items];
}

- (void) testGetCourseStructureWithToken_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runCourseStructRequestWithToken:self.userToken
                                                            forSection:self.sectionId
                                                        andEnvironment:[OCMArg any]
                                                          withResponse:[OCMArg any]
                                                            onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:5];
        [self createErrorForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:6];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *courseStructResponse =
    [self.requestManager getCourseStructureWithToken:self.userToken
                                          forSection:self.sectionId
                                          onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNil(responseInBlock.courseStructureArray);
    XCTAssertEqual(PGMClssParentItems, responseInBlock.responseType);
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
    
    XCTAssertNil(courseStructResponse.courseStructureArray);
    XCTAssertEqual(PGMClssParentItems, courseStructResponse.responseType);
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    
    OCMVerify([mockCourseStructConnector runCourseStructRequestWithToken:self.userToken
                                                               forSection:self.sectionId
                                                           andEnvironment:[OCMArg any]
                                                             withResponse:[OCMArg any]
                                                               onComplete:[OCMArg any]]);
}

- (void) createErrorForCourseStructMockResponseParam:(PGMClssCourseStructureResponse**)response
{
    NSError *error = [[NSError alloc] initWithDomain:@"testClssDomain" code:1 userInfo:nil];
    [*response setError:error];
}

- (void) testGetCourseStructureItemWithId_MissingParams_Error
{
    __block BOOL responseError = NO;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
            responseError = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    //Missing user token:
    
    PGMClssCourseStructureResponse *courseStructResponse =
    [self.requestManager getCourseStructureItemWithId:self.itemId
                                             andToken:nil
                                           forSection:self.sectionId
                                           onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureItemWithId:self.itemId
                                                                    andToken:@""
                                                                  forSection:self.sectionId
                                                                  onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    //Missing section id:
    
    courseStructResponse = [self.requestManager getCourseStructureItemWithId:self.itemId
                                                                    andToken:self.userToken
                                                                  forSection:nil
                                                                  onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureItemWithId:self.itemId
                                                                    andToken:self.userToken
                                                                  forSection:@""
                                                                  onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    //Missing item id:
    
    courseStructResponse = [self.requestManager getCourseStructureItemWithId:nil
                                                                    andToken:self.userToken
                                                                  forSection:self.self.sectionId
                                                                  onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(6, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureItemWithId:@""
                                                                    andToken:self.userToken
                                                                  forSection:self.self.sectionId
                                                                  onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(6, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssSingleItem, courseStructResponse.responseType);
    XCTAssert(responseError);

}

- (void) testGetCourseStructureItemWithId_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runCourseStructRequestForItem:self.itemId
                                                           withToken:self.userToken
                                                          forSection:self.sectionId
                                                      andEnvironment:[OCMArg any]
                                                        withResponse:[OCMArg any]
                                                          onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:6];
        [self createSingleItemForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:7];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *courseStructItemResponse =
    [self.requestManager getCourseStructureItemWithId:self.itemId
                                             andToken:self.userToken
                                           forSection:self.sectionId
                                           onComplete:self.courseStructCompletionHandler];
    
    NSLog(@"The returned resposne has %ld items", (long)[courseStructItemResponse.courseStructureArray count]);
    NSLog(@"The resposne in block has %ld items", (long)[responseInBlock.courseStructureArray count]);
    
    XCTAssertEqual(1, [responseInBlock.courseStructureArray count]);
    XCTAssertEqualObjects(self.itemId, ((PGMClssCourseStructureItem*)[responseInBlock.courseStructureArray objectAtIndex:0]).courseStructureItemId);
    XCTAssertEqual(PGMClssSingleItem, responseInBlock.responseType);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertEqual(1, [courseStructItemResponse.courseStructureArray count]);
    XCTAssertEqualObjects(self.itemId, ((PGMClssCourseStructureItem*)[courseStructItemResponse.courseStructureArray objectAtIndex:0]).courseStructureItemId);
    XCTAssertEqual(PGMClssSingleItem, courseStructItemResponse.responseType);
    XCTAssertNil(courseStructItemResponse.error);
    
    OCMVerify([mockCourseStructConnector runCourseStructRequestForItem:self.itemId
                                                             withToken:self.userToken
                                                            forSection:self.sectionId
                                                        andEnvironment:[OCMArg any]
                                                          withResponse:[OCMArg any]
                                                            onComplete:[OCMArg any]]);
}

- (void) createSingleItemForCourseStructMockResponseParam:(PGMClssCourseStructureResponse**)response
{
    PGMClssCourseStructureItem *firstItem = [PGMClssCourseStructureItem new];
    firstItem.courseStructureItemId = self.itemId;
    firstItem.title = @"My first course struct item title";
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:firstItem];
    
    [*response setCourseStructureArray:items];
}

- (void) testGetCourseStructureItemWithId_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runCourseStructRequestForItem:self.itemId
                                                           withToken:self.userToken
                                                          forSection:self.sectionId
                                                      andEnvironment:[OCMArg any]
                                                        withResponse:[OCMArg any]
                                                          onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:6];
        [self createErrorForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:7];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *courseStructItemResponse =
    [self.requestManager getCourseStructureItemWithId:self.itemId
                                             andToken:self.userToken
                                           forSection:self.sectionId
                                           onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNil(responseInBlock.courseStructureArray);
    XCTAssertEqual(PGMClssSingleItem, responseInBlock.responseType);
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
    
    XCTAssertNil(courseStructItemResponse.courseStructureArray);
    XCTAssertEqual(PGMClssSingleItem, courseStructItemResponse.responseType);
    XCTAssertNotNil(courseStructItemResponse.error);
    XCTAssertEqual(1, courseStructItemResponse.error.code);
    
    OCMVerify([mockCourseStructConnector runCourseStructRequestForItem:self.itemId
                                                             withToken:self.userToken
                                                            forSection:self.sectionId
                                                        andEnvironment:[OCMArg any]
                                                          withResponse:[OCMArg any]
                                                            onComplete:[OCMArg any]]);
}

- (void) testGetCourseStructureChildItemsWithParentId_MissingParams_Error
{
    __block BOOL responseError = NO;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error");
            responseError = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    //Missing user token:
    
    PGMClssCourseStructureResponse *courseStructResponse =
    [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                         andToken:nil
                                                       forSection:self.sectionId
                                                       onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                                                andToken:@""
                                                                              forSection:self.sectionId
                                                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(1, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    //Missing section id:
    
    courseStructResponse = [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                                                andToken:self.userToken
                                                                              forSection:nil
                                                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                                                andToken:self.userToken
                                                                              forSection:@""
                                                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(5, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    //Missing item id:
    
    courseStructResponse = [self.requestManager getCourseStructureChildItemsWithParentId:nil
                                                                                andToken:self.userToken
                                                                              forSection:self.self.sectionId
                                                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(6, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
    
    courseStructResponse = [self.requestManager getCourseStructureChildItemsWithParentId:@""
                                                                                andToken:self.userToken
                                                                              forSection:self.self.sectionId
                                                                              onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNotNil(courseStructResponse.error);
    XCTAssertEqual(6, courseStructResponse.error.code);
    XCTAssertEqual(PGMClssChildItems, courseStructResponse.responseType);
    XCTAssert(responseError);
}

- (void) testGetCourseStructureChildItemsWithParentId_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                                withToken:self.userToken
                                                               forSection:self.sectionId
                                                           andEnvironment:[OCMArg any]
                                                             withResponse:[OCMArg any]
                                                               onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:6];
        [self createItemsForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:7];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *childCourseStructItemResponse =
        [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                             andToken:self.userToken
                                                           forSection:self.sectionId
                                                           onComplete:self.courseStructCompletionHandler];
    
    XCTAssertEqual(2, [responseInBlock.courseStructureArray count]);
    XCTAssertEqual(PGMClssChildItems, responseInBlock.responseType);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertEqual(2, [childCourseStructItemResponse.courseStructureArray count]);
    XCTAssertEqual(PGMClssChildItems, childCourseStructItemResponse.responseType);
    XCTAssertNil(childCourseStructItemResponse.error);
    
    OCMVerify([mockCourseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                                  withToken:self.userToken
                                                                 forSection:self.sectionId
                                                             andEnvironment:[OCMArg any]
                                                               withResponse:[OCMArg any]
                                                                 onComplete:[OCMArg any]]);

}

- (void) testGetCourseStructureChildItemsWithParentId_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    self.courseStructCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error");
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    id mockCourseStructConnector = OCMClassMock([PGMClssCourseStructureConnector class]);
    
    OCMStub([mockCourseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                                withToken:self.userToken
                                                               forSection:self.sectionId
                                                           andEnvironment:[OCMArg any]
                                                             withResponse:[OCMArg any]
                                                               onComplete:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        PGMClssCourseStructureResponse *mockResponse;
        [invocation getArgument:&mockResponse atIndex:6];
        [self createErrorForCourseStructMockResponseParam:&mockResponse];
        void (^CourseStructureNetworkRequestComplete)(PGMClssCourseStructureResponse*);
        [invocation getArgument:&CourseStructureNetworkRequestComplete atIndex:7];
        CourseStructureNetworkRequestComplete(mockResponse);
    });
    
    self.requestManager.courseStructConnector = mockCourseStructConnector;
    
    PGMClssCourseStructureResponse *childCourseStructItemResponse =
    [self.requestManager getCourseStructureChildItemsWithParentId:self.itemId
                                                         andToken:self.userToken
                                                       forSection:self.sectionId
                                                       onComplete:self.courseStructCompletionHandler];
    
    XCTAssertNil(responseInBlock.courseStructureArray);
    XCTAssertEqual(PGMClssChildItems, responseInBlock.responseType);
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
    
    XCTAssertNil(childCourseStructItemResponse.courseStructureArray);
    XCTAssertEqual(PGMClssChildItems, childCourseStructItemResponse.responseType);
    XCTAssertNotNil(childCourseStructItemResponse.error);
    XCTAssertEqual(1, childCourseStructItemResponse.error.code);
    
    OCMVerify([mockCourseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                                  withToken:self.userToken
                                                                 forSection:self.sectionId
                                                             andEnvironment:[OCMArg any]
                                                               withResponse:[OCMArg any]
                                                                 onComplete:[OCMArg any]]);
}

- (void)testGetAssignmentsForCourse
{
    __block PGMClssAssignmentResponse *responseInBlock;
    self.assignmentCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        responseInBlock = response;
        if (response.error)
        {
            NSLog(@"Assignment response error");
        }
        else
        {
            NSLog(@"Assignment response success");
        }
    };
    
    PGMClssCourseListItem *courseListItem = [PGMClssCourseListItem new];
    
    id mockAssignmentConnector = OCMClassMock([PGMClssAssignmentConnector class]);
    OCMStub([mockAssignmentConnector runAssignmentsWithActivitiesRequestWithToken:self.userToken
                                                                        forCourse:courseListItem
                                                                   andEnvironment:[OCMArg any]
                                                                     withResponse:[OCMArg any]
                                                                       onComplete:[OCMArg any]])
        .andDo(^(NSInvocation *invocation) {
            PGMClssAssignmentResponse *mockResponse;
            [invocation getArgument:&mockResponse atIndex:5];
            [self addAssignmentsTo:&mockResponse];
            void (^AssignmentNetworkRequestComplete)(PGMClssAssignmentResponse *);
            [invocation getArgument:&AssignmentNetworkRequestComplete atIndex:6];
            AssignmentNetworkRequestComplete(mockResponse);
        });
    self.requestManager.assignmentConnector = mockAssignmentConnector;
    
    PGMClssAssignmentResponse *result = [self.requestManager getAssignmentsForCourse:courseListItem
                                                                            andToken:self.userToken
                                                                          onComplete:self.assignmentCompletionHandler];
    
    XCTAssertNotNil(result.assignmentsArray, @"Expected not nil assignments in response");
    XCTAssertTrue(result.assignmentsArray.count == 1, @"Expected 1 returned item");
    
    OCMVerify([mockAssignmentConnector runAssignmentsWithActivitiesRequestWithToken:self.userToken
                                                                          forCourse:courseListItem
                                                                     andEnvironment:[OCMArg any]
                                                                       withResponse:[OCMArg any]
                                                                         onComplete:[OCMArg any]]);
}

- (void)testGetAssignmentsForCourse_connectorFailure_error
{
    __block PGMClssAssignmentResponse *responseInBlock;
    self.assignmentCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        responseInBlock = response;
        if (response.error)
        {
            NSLog(@"Assignment response error");
        }
        else
        {
            NSLog(@"Assignment response success");
        }
    };
    
    PGMClssCourseListItem *courseListItem = [PGMClssCourseListItem new];
    
    id mockAssignmentConnector = OCMClassMock([PGMClssAssignmentConnector class]);
    OCMStub([mockAssignmentConnector runAssignmentsWithActivitiesRequestWithToken:self.userToken
                                                                        forCourse:courseListItem
                                                                   andEnvironment:[OCMArg any]
                                                                     withResponse:[OCMArg any]
                                                                       onComplete:[OCMArg any]])
        .andDo(^(NSInvocation *invocation) {
            PGMClssAssignmentResponse *mockResponse;
            [invocation getArgument:&mockResponse atIndex:5];
            [self addErrorTo:&mockResponse];
            void (^AssignmentNetworkRequestComplete)(PGMClssAssignmentResponse *);
            [invocation getArgument:&AssignmentNetworkRequestComplete atIndex:6];
            AssignmentNetworkRequestComplete(mockResponse);
        });
    self.requestManager.assignmentConnector = mockAssignmentConnector;
    
    PGMClssAssignmentResponse *result = [self.requestManager getAssignmentsForCourse:courseListItem
                                                                            andToken:self.userToken
                                                                          onComplete:self.assignmentCompletionHandler];

    XCTAssertNil(result.assignmentsArray, @"Expected nil returned assignments");
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
    
    OCMVerify([mockAssignmentConnector runAssignmentsWithActivitiesRequestWithToken:self.userToken
                                                                          forCourse:courseListItem
                                                                     andEnvironment:[OCMArg any]
                                                                       withResponse:[OCMArg any]
                                                                         onComplete:[OCMArg any]]);
}

- (void)testGetAssignmentsForCourse_nilToken_error
{
    __block PGMClssAssignmentResponse *responseInBlock;
    self.assignmentCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        responseInBlock = response;
        if (response.error)
        {
            NSLog(@"Assignment response error");
        }
        else
        {
            NSLog(@"Assignment response success");
        }
    };
    
    PGMClssCourseListItem *courseListItem = [PGMClssCourseListItem new];
    
    PGMClssAssignmentResponse *result = [self.requestManager getAssignmentsForCourse:courseListItem
                                                                            andToken:nil
                                                                          onComplete:self.assignmentCompletionHandler];
    
    XCTAssertNil(result.assignmentsArray, @"Expected nil returned assignments");
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(1, responseInBlock.error.code);
}

- (void)testGetAssignmentsForCourse_nilCourseListItem_error
{
    __block PGMClssAssignmentResponse *responseInBlock;
    self.assignmentCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        responseInBlock = response;
        if (response.error)
        {
            NSLog(@"Assignment response error");
        }
        else
        {
            NSLog(@"Assignment response success");
        }
    };
    
    PGMClssAssignmentResponse *result = [self.requestManager getAssignmentsForCourse:nil
                                                                            andToken:self.userToken
                                                                          onComplete:self.assignmentCompletionHandler];
    
    XCTAssertNil(result.assignmentsArray, @"Expected nil returned assignments");
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(8, responseInBlock.error.code);
}

- (void)addAssignmentsTo:(PGMClssAssignmentResponse **)response
{
    [*response setAssignmentsArray:[NSArray arrayWithObjects:[PGMClssAssignment new], nil]];
}

- (void)addErrorTo:(PGMClssAssignmentResponse **)response
{
    [*response setError:[[NSError alloc] initWithDomain:@"testClssDomain" code:1 userInfo:nil]];
}

@end

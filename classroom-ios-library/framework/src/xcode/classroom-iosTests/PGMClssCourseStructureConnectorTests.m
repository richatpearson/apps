//
//  PGMClssCourseStructureConnectorTests.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PGMClssCourseStructureConnector.h"
#import "PGMClssEnvironment.h"
#import <OCMock/OCMock.h>

@interface PGMClssCourseStructureConnectorTests : XCTestCase

@property (nonatomic, strong) NSString *sectionId;
@property (nonatomic, strong) NSString *userToken;
@property (nonatomic, strong) NSString *itemId;
@property (nonatomic, strong) PGMClssCourseStructureConnector *courseStructConnector;
@property (nonatomic, strong) PGMClssCourseStructureResponse *response;
@property (nonatomic, strong) PGMClssEnvironment *env;
@property (nonatomic, strong) id mockCoreSessionManager;

@property (nonatomic, strong) CourseStructNetworkRequestComplete courseStructNetworkCompletionHandler;

@end

@implementation PGMClssCourseStructureConnectorTests

//static const NSTimeInterval kRunLoopSamplingInterval = 0.01;

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.courseStructConnector = [PGMClssCourseStructureConnector new];
    self.response = [PGMClssCourseStructureResponse new];
    self.env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    
    self.userToken = @"userToken12345";
    self.sectionId = @"53d7d05ae4b0ac0197a2ced2";
    self.itemId = @"a4750f50-17fc-11e4-a475-83b611b71aae";
    
    self.mockCoreSessionManager = OCMClassMock([PGMCoreSessionManager class]);
    self.courseStructConnector.coreSessionManager = self.mockCoreSessionManager;
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testRunCourseStructRequestWithToken_MissingEnvironment_Error
{
    __block BOOL errorReceived = NO;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
            errorReceived = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    [self.courseStructConnector runCourseStructRequestWithToken:self.userToken
                                                     forSection:self.sectionId
                                                 andEnvironment:nil
                                                   withResponse:self.response
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssNoEnvironment];
    
    self.response = [PGMClssCourseStructureResponse new];
    
    [self.courseStructConnector runCourseStructRequestWithToken:self.userToken
                                                     forSection:self.sectionId
                                                 andEnvironment:env
                                                   withResponse:self.response
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    env.baseRequestCourseStructUrl = @"";
    self.response = [PGMClssCourseStructureResponse new];
    [self.courseStructConnector runCourseStructRequestWithToken:self.userToken
                                                     forSection:self.sectionId
                                                 andEnvironment:env
                                                   withResponse:self.response
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
}

- (void)testRunCourseStructRequestWithToken_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, nil, [[NSError alloc] initWithDomain:@"testClssDomain" code:99 userInfo:nil]);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runCourseStructRequestWithToken:self.userToken
                                                     forSection:self.sectionId
                                                 andEnvironment:self.env
                                                   withResponse:self.response
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertNil(responseInBlock.courseStructureArray);
    XCTAssertEqual(7, responseInBlock.error.code);
    
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(0, [self.response.courseStructureArray count]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

- (void)testRunCourseStructRequestWithToken_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, [self createReturnDataForCourseStructOperation], nil);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runCourseStructRequestWithToken:self.userToken
                                                     forSection:self.sectionId
                                                 andEnvironment:self.env
                                                   withResponse:self.response
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertEqual(2, [responseInBlock.courseStructureArray count]);
    XCTAssertNil(responseInBlock.error);
    
    XCTAssertNil(self.response.error);
    XCTAssertEqual(2, [self.response.courseStructureArray count]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

- (NSData*) createReturnDataForCourseStructOperation
{
    NSString *courseStructId1    = @"abc123";
    NSString *title1             = @"title1";
    NSString *thumbnail1         = @"http://mythumbnail1.com";
    NSString *contentLink1       = @"http://myresource1";
    
    NSString *courseStructId2    = @"def456";
    NSString *title2             = @"title2";
    NSString *thumbnail2         = @"http://mythumbnail2.com";
    NSString *contentLink2       = @"http://myresource2";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"_embedded\": {\"items\": [{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"thumbnailUrl\": \"%@\",\"lastModifiedDate\": \"Tue, 01 Jul 2014 14:32:15 GMT\",\"isLocked\": false},{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"lastModifiedDate\": \"Tue, 15 Jul 2014 20:37:08 GMT\",\"thumbnailUrl\": \"%@\",\"isLocked\": false}]}}", courseStructId1, courseStructId1, title1, contentLink1, thumbnail1, courseStructId2, courseStructId2, title2, contentLink2, thumbnail2];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) testRunCourseStructRequestForItem_MissingEnvironment_Error
{
    __block BOOL errorReceived = NO;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
            errorReceived = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    [self.courseStructConnector runCourseStructRequestForItem:self.itemId
                                                    withToken:self.userToken
                                                   forSection:self.sectionId
                                               andEnvironment:nil
                                                 withResponse:self.response
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    PGMClssEnvironment *environment = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssNoEnvironment];
    
    self.response = [PGMClssCourseStructureResponse new];
    
    [self.courseStructConnector runCourseStructRequestForItem:self.itemId
                                                    withToken:self.userToken
                                                   forSection:self.sectionId
                                               andEnvironment:environment
                                                 withResponse:self.response
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    environment.baseRequestCourseStructUrl = @"";
    self.response = [PGMClssCourseStructureResponse new];
    [self.courseStructConnector runCourseStructRequestForItem:self.itemId
                                                    withToken:self.userToken
                                                   forSection:self.sectionId
                                               andEnvironment:environment
                                                 withResponse:self.response
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
}

- (void) testRunCourseStructRequestForItem_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, nil, [[NSError alloc] initWithDomain:@"testClssDomain" code:99 userInfo:nil]);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runCourseStructRequestForItem:self.itemId
                                                    withToken:self.userToken
                                                   forSection:self.sectionId
                                               andEnvironment:self.env
                                                 withResponse:self.response
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertNil(responseInBlock.courseStructureArray);
    XCTAssertEqual(7, responseInBlock.error.code);
    
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(7, self.response.error.code);
    XCTAssertEqual(0, [self.response.courseStructureArray count]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

- (void) testRunCourseStructRequestForItem_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, [self createReturnDataForCourseStructItemOperation], nil);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runCourseStructRequestForItem:self.itemId
                                                    withToken:self.userToken
                                                   forSection:self.sectionId
                                               andEnvironment:self.env
                                                 withResponse:self.response
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertNil(responseInBlock.error);
    XCTAssertEqual(1, [responseInBlock.courseStructureArray count]);
    
    XCTAssertNil(self.response.error);
    XCTAssertEqual(1, [self.response.courseStructureArray count]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

- (NSData*) createReturnDataForCourseStructItemOperation
{
    NSString *courseStructId    = @"abc123";
    NSString *title             = @"title1";
    NSString *thumbnail         = @"http://mythumbnail1.com";
    NSString *contentLink       = @"http://myresource1";
    NSString *itemsDesc         = @"this item's description";
    
    NSString *jsonString = [NSString stringWithFormat:@"{\"links\": [{\"href\": \"http://pearsonbuild-staging.apigee.net/coursestructure/courses/5245999eb8ab8b46dfc8e9dd/items/%@\",\"rel\": \"mydomain.com/courses/items/self\"}],\"id\": \"%@\",\"title\": \"%@\",\"href\": \"%@\",\"thumbnailUrl\": \"%@\",\"lastModifiedDate\": \"Tue, 01 Jul 2014 14:32:15 GMT\",\"description\":\"%@\" ,\"isLocked\": false}", courseStructId, courseStructId, title, contentLink, thumbnail, itemsDesc];
    
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void) testRunChildCourseStructRequestForItem_MissingEnvironment_Error
{
    __block BOOL errorReceived = NO;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
            errorReceived = YES;
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    [self.courseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                         withToken:self.userToken
                                                        forSection:self.sectionId
                                                    andEnvironment:nil
                                                      withResponse:self.response
                                                        onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    PGMClssEnvironment *environment = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssNoEnvironment];
    
    self.response = [PGMClssCourseStructureResponse new];
    
    [self.courseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                         withToken:self.userToken
                                                        forSection:self.sectionId
                                                    andEnvironment:environment
                                                      withResponse:self.response
                                                        onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    environment.baseRequestCourseStructUrl = @"";
    self.response = [PGMClssCourseStructureResponse new];
    [self.courseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                         withToken:self.userToken
                                                        forSection:self.sectionId
                                                    andEnvironment:environment
                                                      withResponse:self.response
                                                        onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssert(errorReceived);
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(4, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
}

- (void) testRunChildCourseStructRequestForItem_WithMock_Error
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, nil, [[NSError alloc] initWithDomain:@"testClssDomain" code:99 userInfo:nil]);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                         withToken:self.userToken
                                                        forSection:self.sectionId
                                                    andEnvironment:self.env
                                                      withResponse:self.response
                                                        onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertNotNil(responseInBlock.error);
    XCTAssertEqual(7, responseInBlock.error.code);
    XCTAssertNil(responseInBlock.courseStructureArray);
    
    XCTAssertNotNil(self.response.error);
    XCTAssertEqual(7, self.response.error.code);
    XCTAssertNil(self.response.courseStructureArray);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

- (void) testRunChildCourseStructRequestForItem_WithMock_Success
{
    __block PGMClssCourseStructureResponse *responseInBlock;
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response) {
        responseInBlock = response;
        if (response.error) {
            NSLog(@"On complete - error: %@", response.error);
        } else {
            NSLog(@"OnComplete - success!");
        }
    };
    
    NSOperation *operation = [[NSOperation alloc] init];
    
    OCMStub([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                  progressHandler:[OCMArg any]
                                                completionHandler:[OCMArg any]])
    .andDo(^(NSInvocation *invocation) {
        void(^DidCompleteWithErrorHandler)(PGMCoreSessionTaskOperation *operation,
                                           NSData *data,
                                           NSError *error);
        [invocation getArgument:&DidCompleteWithErrorHandler atIndex:4];
        DidCompleteWithErrorHandler(nil, [self createReturnDataForCourseStructOperation], nil);
    }).andReturn(operation);
    
    OCMExpect([self.mockCoreSessionManager addOperationToQueue:operation]);
    
    [self.courseStructConnector runChildCourseStructRequestForItem:self.itemId
                                                         withToken:self.userToken
                                                        forSection:self.sectionId
                                                    andEnvironment:self.env
                                                      withResponse:self.response
                                                        onComplete:self.courseStructNetworkCompletionHandler];
    
    XCTAssertNil(responseInBlock.error);
    XCTAssertEqual(2, [responseInBlock.courseStructureArray count]);
    
    XCTAssertNil(self.response.error);
    XCTAssertEqual(2, [self.response.courseStructureArray count]);
    
    OCMVerify([self.mockCoreSessionManager dataOperationWithRequest:[OCMArg any]
                                                    progressHandler:[OCMArg any]
                                                  completionHandler:[OCMArg any]]);
    
    OCMVerify([self.mockCoreSessionManager addOperationToQueue:operation]);
}

@end

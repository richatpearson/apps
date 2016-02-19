//
//  PGMClssCourseListConnector.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseListConnector.h"
#import "PGMClssCourseListSerializer.h"
#import "PGMClssError.h"

@interface PGMClssCourseListConnector()

@property (nonatomic, strong) PGMClssCourseListResponse *courseListResponse;
@property (nonatomic, strong) PGMClssEnvironment *environment;
@end

NSTimeInterval const PGMClssTimeout = 10.0;

@implementation PGMClssCourseListConnector

- (void) setCoreSessionManager
{
    if (!self.coreSessionManager)
    {
        self.coreSessionManager = [[PGMCoreSessionManager alloc] init];
    }
}

- (void) runCourseListRequestForUser:(NSString*)userIdentityId
                            andToken:(NSString*)userToken
                      forEnvironment:(PGMClssEnvironment*)env
                        withResponse:(PGMClssCourseListResponse*)response
                          onComplete:(CourseListNetworkRequestComplete)onComplete
{
    self.environment = env;
    self.courseListResponse = response;
    
    if (!self.environment || !self.environment.baseRequestCourseListUrl || [self.environment.baseRequestCourseListUrl isEqualToString:@""])
    {
        NSString *noEnvErrorDescription = @"Environment is not defined";
        self.courseListResponse.error = [PGMClssError createClssErrorForErrorCode:PGMClssEnvironmentNotDefinedError andDescription:noEnvErrorDescription];
        onComplete(self.courseListResponse);
        return;
    }
    
    NSURLRequest *request = [self buildCourseListRequestForUser:userIdentityId andToken:userToken];
    
    DidCompleteWithErrorHandler taskOperationCompletionHandler = ^(PGMCoreSessionTaskOperation *operation,
                                                                                        NSData *data,
                                                                                       NSError *error)
    {
        if (error)
        {
            NSLog(@"Error getting course list: %@", error.description);
            self.courseListResponse.error = [PGMClssError createClssErrorForErrorCode:PGMClssCourseListNetworkCallError
                                                                       andDescription:error.description];
            onComplete(self.courseListResponse);
        }
        else
        {
            [self parseCourseListForData:data];
            onComplete(self.courseListResponse);
        }
    };
    
    [self executeNetworkOperationForRequest:request
                       andCompletionHandler:taskOperationCompletionHandler];
}

- (void) parseCourseListForData:(NSData*)data
{
    PGMClssCourseListSerializer *deserializer = [PGMClssCourseListSerializer new];
    NSArray *parsedCourseList = [deserializer deserializeCourseListItems:data];
    
    if (!parsedCourseList) {
        NSString *errorDesc = @"Error while trying to deserialize course list data from network call.";
        self.courseListResponse.error = [PGMClssError createClssErrorForErrorCode:PGMClssUnableToDeserializeError andDescription:errorDesc];
    } else {
        self.courseListResponse.courseListArray = parsedCourseList;
    }
}

- (NSURLRequest*) buildCourseListRequestForUser:(NSString*)userIdentityId
                                       andToken:(NSString*)userToken
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@registrar/user-association/userassociations/%@/sections", self.environment.baseRequestCourseListUrl, userIdentityId];
    NSLog(@"Course list url for user is: %@", stringUrl);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:PGMClssTimeout];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

- (void) executeNetworkOperationForRequest:(NSURLRequest*)request
                      andCompletionHandler:(DidCompleteWithErrorHandler)completionHandler
{
    [self setCoreSessionManager];
    NSOperation *courseListOperation =[self.coreSessionManager dataOperationWithRequest:request
                                                                        progressHandler:nil
                                                                      completionHandler:completionHandler];
    
    [self.coreSessionManager addOperationToQueue:courseListOperation];
}

@end

//
//  PGMClssAssignmentConnector.m
//  classroom-ios
//
//  Created by Joe Miller on 10/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssAssignmentConnector.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssError.h"
#import "PGMClssAssignmentSerializer.h"
#import "PGMClssValidator.h"

@interface PGMClssAssignmentConnector()

@property (nonatomic, strong) PGMClssEnvironment *environment;
@property (nonatomic, strong) PGMClssAssignmentResponse *response;

@end

NSTimeInterval const URLRequestTimeout = 10.0;

@implementation PGMClssAssignmentConnector

- (void)runAssignmentsWithActivitiesRequestWithToken:(NSString *)userToken
                                           forCourse:(PGMClssCourseListItem *)courseListItem
                                      andEnvironment:(PGMClssEnvironment *)env
                                        withResponse:(PGMClssAssignmentResponse *)response
                                          onComplete:(AssignmentNetworkRequestComplete)onComplete
{
    self.environment = env;
    self.response = response;
    
    NSError *error = [PGMClssValidator validateCourseStructureEnvironment:self.environment];
    if (error)
    {
        self.response.error = error;
        onComplete(self.response);
        return;
    }
    
    NSURLRequest *request = [self buildAssignmentsWithActivitiesRequestForSection:courseListItem.sectionId andToken:userToken];
    
    DidCompleteWithErrorHandler taskOperationCompletionHandler = ^(PGMCoreSessionTaskOperation *operation,
                                                                   NSData *data,
                                                                   NSError *error)
    {
        if (error)
        {
            NSLog(@"Error getting assignments with activities: %@", error.description);
            self.response.error = [PGMClssError createClssErrorForErrorCode:PgMClssCourseStructNetworkCallError
                                                             andDescription:error.description];
            onComplete(self.response);
        }
        else
        {
            [self parseAssignmentData:data withCourseListItem:courseListItem];
            onComplete(self.response);
        }
    };
    
    [self executeNetworkOperationForRequest:request
                       andCompletionHandler:taskOperationCompletionHandler];
}

- (NSURLRequest *)buildAssignmentsWithActivitiesRequestForSection:(NSString *)sectionId
                                                         andToken:(NSString *)userToken
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@coursestructure/courses/%@/assignments?expand=activities",
                           self.environment.baseRequestCourseStructUrl, sectionId];
    NSLog(@"Assignments url for user is: %@", stringUrl);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:URLRequestTimeout];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

- (void)parseAssignmentData:(NSData *)data withCourseListItem:(PGMClssCourseListItem *)courseListItem
{
    PGMClssAssignmentSerializer *deserializer = [PGMClssAssignmentSerializer new];
    NSArray *parsedAssignments = [deserializer deserializeAssignments:data withCourseListItem:courseListItem];
    
    if (!parsedAssignments)
    {
        NSString *errorDesc = @"Error while trying to deserialize assignment data from network call.";
        self.response.error = [PGMClssError createClssErrorForErrorCode:PGMClssUnableToDeserializeError andDescription:errorDesc];
    }
    else
    {
        self.response.assignmentsArray = parsedAssignments;
    }
}

- (void)executeNetworkOperationForRequest:(NSURLRequest *)request
                     andCompletionHandler:(DidCompleteWithErrorHandler)completionHandler
{
    NSOperation *operation =[self.coreSessionManager dataOperationWithRequest:request
                                                              progressHandler:nil
                                                            completionHandler:completionHandler];
    [self.coreSessionManager addOperationToQueue:operation];
}

- (PGMCoreSessionManager *)coreSessionManager
{
    if (!_coreSessionManager)
    {
        _coreSessionManager = [PGMCoreSessionManager new];
    }
    return _coreSessionManager;
}

@end

//
//  PGMClssCourseStructureConnector.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseStructureConnector.h"
#import "PGMClssCourseStructureSerializer.h"
#import "PGMClssError.h"
#import "PGMClssValidator.h"

@interface PGMClssCourseStructureConnector()

@property (nonatomic, strong) PGMClssCourseStructureResponse *courseStructResponse;
@property (nonatomic, strong) PGMClssEnvironment *environment;

@end

NSTimeInterval const PGMClssCourseStructTimeout = 10.0;

@implementation PGMClssCourseStructureConnector

- (void) setCoreSessionManager
{
    if (!self.coreSessionManager)
    {
        self.coreSessionManager = [[PGMCoreSessionManager alloc] init];
    }
}

- (void) runCourseStructRequestWithToken:(NSString*)userToken
                              forSection:(NSString*)sectionId
                          andEnvironment:(PGMClssEnvironment*)env
                            withResponse:(PGMClssCourseStructureResponse*)response
                              onComplete:(CourseStructNetworkRequestComplete)onComplete
{
    self.environment = env;
    self.courseStructResponse = response;
    
    NSError *error = [PGMClssValidator validateCourseStructureEnvironment:self.environment];
    if (error)
    {
        self.courseStructResponse.error = error;
        onComplete(self.courseStructResponse);
        return;
    }
    
    NSURLRequest *request = [self buildCourseStructRequestForSection:sectionId andToken:userToken];
    
    DidCompleteWithErrorHandler taskOperationCompletionHandler = ^(PGMCoreSessionTaskOperation *operation,
                                                                   NSData *data,
                                                                   NSError *error)
    {
        if (error)
        {
            NSLog(@"Error getting course structure: %@", error.description);
            self.courseStructResponse.error = [PGMClssError createClssErrorForErrorCode:PgMClssCourseStructNetworkCallError
                                                                         andDescription:error.description];
            onComplete(self.courseStructResponse);
        }
        else
        {
            [self parseCourseStructureForData:data];
            onComplete(self.courseStructResponse);
        }
    };
    
    [self executeNetworkOperationForRequest:request
                       andCompletionHandler:taskOperationCompletionHandler];
}

- (void) parseCourseStructureForData:(NSData*)data
{
    PGMClssCourseStructureSerializer *deserializer = [PGMClssCourseStructureSerializer new];
    NSArray *parsedCourseStructure = [deserializer deserializeCourseStructureItems:data];
    
    if (!parsedCourseStructure) {
        NSString *errorDesc = @"Error while trying to deserialize course structure data from network call.";
        self.courseStructResponse.error = [PGMClssError createClssErrorForErrorCode:PGMClssUnableToDeserializeError andDescription:errorDesc];
    } else {
        self.courseStructResponse.courseStructureArray = parsedCourseStructure;
    }
}

- (NSURLRequest*) buildCourseStructRequestForSection:(NSString*)sectionId
                                            andToken:(NSString*)userToken
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@coursestructure/courses/%@/items", self.environment.baseRequestCourseStructUrl, sectionId];
    NSLog(@"Course structure url for user is: %@", stringUrl);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:PGMClssCourseStructTimeout];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

- (void) executeNetworkOperationForRequest:(NSURLRequest*)request
                      andCompletionHandler:(DidCompleteWithErrorHandler)completionHandler
{
    [self setCoreSessionManager];
    NSOperation *courseStructureOperation =[self.coreSessionManager dataOperationWithRequest:request
                                                                             progressHandler:nil
                                                                           completionHandler:completionHandler];
    
    [self.coreSessionManager addOperationToQueue:courseStructureOperation];
}

- (void) runCourseStructRequestForItem:(NSString*)itemId
                             withToken:(NSString*)userToken
                            forSection:(NSString*)sectionId
                        andEnvironment:(PGMClssEnvironment*)env
                          withResponse:(PGMClssCourseStructureResponse*)response
                            onComplete:(CourseStructNetworkRequestComplete)onComplete
{
    self.environment = env;
    self.courseStructResponse = response;
    
    NSError *error = [PGMClssValidator validateCourseStructureEnvironment:self.environment];
    if (error)
    {
        self.courseStructResponse.error = error;
        onComplete(self.courseStructResponse);
        return;
    }
    
    NSURLRequest *request = [self buildCourseStructRequestForSection:sectionId
                                                            andToken:userToken
                                                             andItem:itemId];
    
    DidCompleteWithErrorHandler taskOperationCompletionHandler = ^(PGMCoreSessionTaskOperation *operation,
                                                                   NSData *data,
                                                                   NSError *error)
    {
        if (error)
        {
            NSLog(@"Error getting course structure for item: %@", error.description);
            self.courseStructResponse.error = [PGMClssError createClssErrorForErrorCode:PgMClssCourseStructNetworkCallError
                                                                         andDescription:error.description];
            onComplete(self.courseStructResponse);
        }
        else
        {
            [self parseCourseStructureForItemData:data];
            onComplete(self.courseStructResponse);
        }
    };
    
    [self executeNetworkOperationForRequest:request
                       andCompletionHandler:taskOperationCompletionHandler];
}

- (NSURLRequest*) buildCourseStructRequestForSection:(NSString*)sectionId
                                            andToken:(NSString*)userToken
                                             andItem:(NSString*)itemId
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@coursestructure/courses/%@/items/%@", self.environment.baseRequestCourseStructUrl, sectionId, itemId];
    NSLog(@"Course structure url for itemId for user is: %@", stringUrl);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:PGMClssCourseStructTimeout];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

- (void) parseCourseStructureForItemData:(NSData*)data
{
    PGMClssCourseStructureSerializer *deserializer = [PGMClssCourseStructureSerializer new];
    NSArray *parsedCourseStructure = [deserializer deserializeCourseStructureForSingleItem:data];
    
    if (!parsedCourseStructure) {
        NSString *errorDesc = @"Error while trying to deserialize course structure data from network call.";
        self.courseStructResponse.error = [PGMClssError createClssErrorForErrorCode:PGMClssUnableToDeserializeError andDescription:errorDesc];
    } else {
        self.courseStructResponse.courseStructureArray = parsedCourseStructure;
    }
}

- (void) runChildCourseStructRequestForItem:(NSString*)itemId
                                  withToken:(NSString*)userToken
                                 forSection:(NSString*)sectionId
                             andEnvironment:(PGMClssEnvironment*)env
                               withResponse:(PGMClssCourseStructureResponse*)response
                                 onComplete:(CourseStructNetworkRequestComplete)onComplete
{
    self.environment = env;
    self.courseStructResponse = response;
    
    NSError *error = [PGMClssValidator validateCourseStructureEnvironment:self.environment];
    if (error)
    {
        self.courseStructResponse.error = error;
        onComplete(self.courseStructResponse);
        return;
    }
    
    NSURLRequest *request = [self buildChildCourseStructRequestForSection:sectionId
                                                                 andToken:userToken
                                                                  andItem:itemId];
    
    DidCompleteWithErrorHandler taskOperationCompletionHandler = ^(PGMCoreSessionTaskOperation *operation,
                                                                   NSData *data,
                                                                   NSError *error)
    {
        if (error)
        {
            NSLog(@"Error getting children course structure for item: %@", error.description);
            self.courseStructResponse.error = [PGMClssError createClssErrorForErrorCode:PgMClssCourseStructNetworkCallError
                                                                         andDescription:error.description];
            onComplete(self.courseStructResponse);
        }
        else
        {
            [self parseCourseStructureForData:data];
            onComplete(self.courseStructResponse);
        }
    };
    
    [self executeNetworkOperationForRequest:request
                       andCompletionHandler:taskOperationCompletionHandler];

}

- (NSURLRequest*) buildChildCourseStructRequestForSection:(NSString*)sectionId
                                                 andToken:(NSString*)userToken
                                                  andItem:(NSString*)itemId
{
    NSString *stringUrl = [NSString stringWithFormat:@"%@coursestructure/courses/%@/items/%@/items", self.environment.baseRequestCourseStructUrl, sectionId, itemId];
    NSLog(@"Course structure url for itemId for user is: %@", stringUrl);
    
    NSURL *url = [NSURL URLWithString:stringUrl];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:PGMClssCourseStructTimeout];
    [request setHTTPMethod:@"GET"];
    [request setValue:[NSString stringWithFormat:@"Bearer %@", userToken] forHTTPHeaderField:@"Authorization"];
    
    return request;
}

@end

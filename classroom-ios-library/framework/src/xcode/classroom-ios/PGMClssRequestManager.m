//
//  PGMClssRequestManager.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssRequestManager.h"
#import "PGMClssError.h"
#import "PGMClssAssignment.h"
#import "PGMClssAssignmentActivity.h"

@interface PGMClssRequestManager()

//TODO: property for onComplete for connector - CourseListNetworkRequestComplete
@property (nonatomic, strong) CourseListNetworkRequestComplete courseListNetworkCompletionHandler;
@property (nonatomic, strong) CourseStructNetworkRequestComplete courseStructNetworkCompletionHandler;
@property (nonatomic, strong) AssignmentRequestComplete assignmentsNetworkCompletionHandler;
@property (nonatomic, strong) PGMClssCourseListResponse *courseListResponse;
@property (nonatomic, strong) PGMClssCourseStructureResponse *courseStructureResponse;
@property (nonatomic, strong) PGMClssAssignmentResponse *assignmentResponse;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, readwrite) PGMClssEnvironment *clssEnvironment;

@end

@implementation PGMClssRequestManager

@synthesize assignmentConnector = _assignmentConnector;

- (id) initWithFetchPolicy:(PGMClssFetchPolicy)fetchPolicy
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.clssEnvironment = [[PGMClssEnvironment alloc] init];
    
    return self;
}

- (BOOL) setEnvironment:(PGMClssEnvironment*)environment
{
    if (environment)
    {
        self.clssEnvironment = environment;
        return YES;
    }
    else
    {
        assert(0);
    }
    return NO;
}

- (void) setCourseListConnector
{
    if (!self.courseListConnector)
    {
        self.courseListConnector = [[PGMClssCourseListConnector alloc] init];
    }
}

- (void) setCourseStructConnector
{
    if (!self.courseStructConnector)
    {
        self.courseStructConnector = [[PGMClssCourseStructureConnector alloc] init];
    }
}

- (PGMClssAssignmentConnector *)assignmentConnector
{
    if (!_assignmentConnector)
    {
        _assignmentConnector = [PGMClssAssignmentConnector new];
    }
    return _assignmentConnector;
}

- (PGMClssCourseListResponse*) getCourseListForUser:(NSString*)userIdentityId
                                          withToken:(NSString*)userToken
                                         onComplete:(CourseListRequestComplete)onComplete
{
    self.courseListResponse = [PGMClssCourseListResponse new];
    
    if (![self validateCourseListParametersUserId:userIdentityId andToken:userToken]) {
        self.courseListResponse.error = self.error;
        onComplete(self.courseListResponse);
        return self.courseListResponse;
    }
    
    self.courseListNetworkCompletionHandler = ^(PGMClssCourseListResponse *response)
    {
        if (response.error) {
            NSLog(@"Error returning from course list network response");
            onComplete(response);
        }
        else {
            NSLog(@"Successful response from course list network call");
            onComplete(response);
        }
    };
    
    [self setCourseListConnector];
    [self.courseListConnector runCourseListRequestForUser:userIdentityId
                                            andToken:userToken
                                      forEnvironment:self.clssEnvironment
                                        withResponse:self.courseListResponse
                                          onComplete:self.courseListNetworkCompletionHandler];
    
    return self.courseListResponse;
}

- (BOOL) validateCourseListParametersUserId:(NSString*)identityId
                                   andToken:(NSString*)userToken
{
    if ((!identityId) || [identityId isEqualToString:@""])
    {
        self.error = [[NSError alloc] init];
        NSString *errorDesc = @"Missing user identity id.";
        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingUserIdentityError
                                                andDescription:errorDesc];
        return NO;
    }
    
    if ((!userToken) || [userToken isEqualToString:@""])
    {
        self.error = [[NSError alloc] init];
        NSString *errorDesc = @"Missing user token.";
        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingTokenError
                                                andDescription:errorDesc];
        return NO;
    }
    
    return YES;
}

- (PGMClssCourseStructureResponse*) getCourseStructureWithToken:(NSString*)token
                                                     forSection:(NSString*)sectionId
                                                     onComplete:(CourseStructRequestComplete)onComplete
{
    self.courseStructureResponse = [PGMClssCourseStructureResponse new];
    self.courseStructureResponse.responseType = PGMClssParentItems;
    
    if (![self validateCourseStructureParameters:sectionId token:token item:@"dummy"]) {
        self.courseStructureResponse.error = self.error;
        onComplete(self.courseStructureResponse);
        return self.courseStructureResponse;
    }
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response)
    {
        if (response.error) {
            NSLog(@"Error returning from course struct network response");
            onComplete(response);
        }
        else {
            NSLog(@"Successful response from course struct network call");
            onComplete(response);
        }
    };
    
    [self setCourseStructConnector];
    [self.courseStructConnector runCourseStructRequestWithToken:token
                                                     forSection:sectionId
                                                 andEnvironment:self.clssEnvironment
                                                   withResponse:self.courseStructureResponse
                                                     onComplete:self.courseStructNetworkCompletionHandler];
    
    return self.courseStructureResponse;
}

- (BOOL) validateCourseStructureParameters:(NSString*)sectionId
                                     token:(NSString*)userToken
                                      item:(NSString*)itemId
{
    NSLog(@"token is: %@ and section id is: %@", userToken, sectionId);
    if ((!sectionId) || [sectionId isEqualToString:@""])
    {
        self.error = [[NSError alloc] init];
        NSString *errorDesc = @"Missing section id.";
        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingSectionIdError
                                                andDescription:errorDesc];
        return NO;
    }
    
    if ((!userToken) || [userToken isEqualToString:@""])
    {
        self.error = [[NSError alloc] init];
        NSString *errorDesc = @"Missing user token.";
        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingTokenError
                                                andDescription:errorDesc];
        return NO;
    }
    
    if ((!itemId) || [itemId isEqualToString:@""])
    {
        self.error = [[NSError alloc] init];
        NSString *errorDesc = @"Missing item Id.";
        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingCourseStructItemIdError
                                                andDescription:errorDesc];
        return NO;
    }
    
    return YES;
}

- (PGMClssCourseStructureResponse*) getCourseStructureItemWithId:(NSString*)itemId
                                                        andToken:(NSString*)token
                                                      forSection:(NSString*)sectionId
                                                      onComplete:(CourseStructRequestComplete)onComplete
{
    self.courseStructureResponse = [PGMClssCourseStructureResponse new];
    self.courseStructureResponse.responseType = PGMClssSingleItem;
    
    if (![self validateCourseStructureParameters:sectionId token:token item:itemId]) {
        self.courseStructureResponse.error = self.error;
        onComplete(self.courseStructureResponse);
        return self.courseStructureResponse;
    }
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response)
    {
        if (response.error) {
            NSLog(@"Error returning from course struct item network response");
            onComplete(response);
        }
        else {
            NSLog(@"Successful response from course struct item network call");
            onComplete(response);
        }
    };
    
    [self setCourseStructConnector];
    [self.courseStructConnector runCourseStructRequestForItem:itemId
                                               withToken:token
                                              forSection:sectionId
                                          andEnvironment:self.clssEnvironment
                                            withResponse:self.courseStructureResponse
                                              onComplete:self.courseStructNetworkCompletionHandler];
    
    return self.courseStructureResponse;
}

- (PGMClssCourseStructureResponse*) getCourseStructureChildItemsWithParentId:(NSString*)itemId
                                                                    andToken:(NSString*)token
                                                                  forSection:(NSString*)sectionId
                                                                  onComplete:(CourseStructRequestComplete)onComplete
{
    self.courseStructureResponse = [PGMClssCourseStructureResponse new];
    self.courseStructureResponse.responseType = PGMClssChildItems;
    
    if (![self validateCourseStructureParameters:sectionId token:token item:itemId]) {
        self.courseStructureResponse.error = self.error;
        onComplete(self.courseStructureResponse);
        return self.courseStructureResponse;
    }
    
    self.courseStructNetworkCompletionHandler = ^(PGMClssCourseStructureResponse *response)
    {
        if (response.error) {
            NSLog(@"Error returning from child course struct item network response");
            onComplete(response);
        }
        else {
            NSLog(@"Successful response from child course struct item network call");
            onComplete(response);
        }
    };
    
    [self setCourseStructConnector];
    [self.courseStructConnector runChildCourseStructRequestForItem:itemId
                                                    withToken:token forSection:sectionId
                                               andEnvironment:self.clssEnvironment
                                                 withResponse:self.courseStructureResponse
                                                   onComplete:self.courseStructNetworkCompletionHandler];
    
    return self.courseStructureResponse;
}

- (PGMClssAssignmentResponse *)getAssignmentsForCourse:(PGMClssCourseListItem *)courseListItem
                                              andToken:(NSString *)token
                                            onComplete:(AssignmentRequestComplete)onComplete
{
    self.assignmentResponse = [PGMClssAssignmentResponse new];
    
    if (![self validateAssignmentParameters:token andCourseListItem:courseListItem])
    {
        self.assignmentResponse.error = self.error;
        onComplete(self.assignmentResponse);
        return self.assignmentResponse;
    }
    
    self.assignmentsNetworkCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        if (response.error)
        {
            NSLog(@"Error returning from assignments network response");
            onComplete(response);
        }
        else
        {
            NSLog(@"Successful response from assignments network call");
            onComplete(response);
        }
    };
    
    [self.assignmentConnector runAssignmentsWithActivitiesRequestWithToken:token
                                                                 forCourse:courseListItem
                                                            andEnvironment:self.clssEnvironment
                                                              withResponse:self.assignmentResponse
                                                                onComplete:self.assignmentsNetworkCompletionHandler];
    return self.assignmentResponse;
}

- (PGMClssAssignmentResponse *)getAssignmentsForCourses:(NSArray *)courseListItems
                                               andToken:(NSString *)token
                                             onComplete:(AssignmentRequestComplete)onComplete
{
    self.assignmentResponse = [PGMClssAssignmentResponse new];
    
    self.assignmentResponse.assignmentsArray = [self assignments:courseListItems];
    
    onComplete(self.assignmentResponse);
    
    return self.assignmentResponse;
}

- (BOOL) validateAssignmentParameters:(NSString *)userToken andCourseListItem:(PGMClssCourseListItem *)courseListItem
{
    if ((!userToken) || [userToken isEqualToString:@""])
    {
        self.error = [NSError new];
        NSString *errorDesc = @"Missing user token.";
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingTokenError andDescription:errorDesc];
        return NO;
    }
    if (!courseListItem)
    {
        self.error = [NSError new];
        NSString *errorDesc = @"Missing course list item.";        
        self.error = [PGMClssError createClssErrorForErrorCode:PGMClssMissingCourseListItemError andDescription:errorDesc];
        return NO;
    }
    return YES;
}

- (NSArray *)assignments:(NSArray *)courseListItems
{
    NSDate *date = [NSDate new];
    NSMutableArray *assignments = [[NSMutableArray alloc] initWithCapacity:courseListItems.count];
    int cnt = 0;
    for (PGMClssCourseListItem *item in courseListItems)
    {
        cnt++;
        
        PGMClssAssignment *assignment = [PGMClssAssignment new];
        assignment.assignmentId = [NSString stringWithFormat:@"%d", cnt];
        assignment.title = [NSString stringWithFormat:@"Assignment %d", cnt];
        assignment.assignmentDescription = [NSString stringWithFormat:@"Assignment %d Description", cnt];
        assignment.assignmentTemplateId = [NSString stringWithFormat:@"template%d", cnt];
        assignment.lastModified = date;
        
        PGMClssAssignmentActivity *activity1 = [PGMClssAssignmentActivity new];
        activity1.activityId = [NSString stringWithFormat:@"%d", cnt];
        activity1.title = [NSString stringWithFormat:@"Assignment %d Activity %d", cnt, cnt];
        activity1.activityDescription = [NSString stringWithFormat:@"Activity %d Description", cnt];
        activity1.thumbnailURL = @"http://someurl";
        activity1.dueDate = date;
        activity1.lastModified = date;
        
        PGMClssAssignmentActivity *activity2 = [PGMClssAssignmentActivity new];
        activity2.activityId = [NSString stringWithFormat:@"%d", cnt+1];
        activity2.title = [NSString stringWithFormat:@"Assignment %d Activity %d", cnt+1, cnt+1];
        activity2.activityDescription = [NSString stringWithFormat:@"Activity %d Description", cnt+1];
        activity2.thumbnailURL = @"http://someurl";
        activity2.dueDate = date;
        activity2.lastModified = date;
        
        NSArray *activities = [NSArray arrayWithObjects:activity1, activity2, nil];
        assignment.assignmentActivities = activities;
        
        [assignments addObject:assignment];
    }
    return assignments;
}

@end

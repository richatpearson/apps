//
//  PGMAssignmentsProvider.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMAssignmentsProvider.h"
#import "PGMClassroomManagerFactory.h"
#import "PGMAppDelegate.h"

@interface PGMAssignmentsProvider()

@property (nonatomic, strong) AssignmentRequestComplete assignmentRequestCompletionHandler;

@end

@implementation PGMAssignmentsProvider

- (instancetype) initWithEnvironmentType:(PGMClssEnvironmentType)environmentType {
    if (self = [super init])
    {
        self.requestManager = [PGMClassroomManagerFactory createManagerForEnv:environmentType];
    }
    
    self.assignmentRequestCompletionHandler = ^(PGMClssAssignmentResponse *response) {
        
        if (response.error) {
            NSLog(@"Course Assignments error is %@ with code of %lu", response.error.description, (long)response.error.code);
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseAssignmentsError" object:response];
            });
        }
        else {
            NSLog(@"Course Assignments success!");
            dispatch_async(dispatch_get_main_queue(), ^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"CourseAssignmentsComplete" object:response];
            });
        }
    };
    
    return self;
}

- (void) getAssignmentsForSection:(PGMClssCourseListItem*)section {
    
    PGMAppDelegate *appDelegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.requestManager getAssignmentsForCourse:section andToken:appDelegate.credentials.getAccessToken onComplete:self.assignmentRequestCompletionHandler];
}

- (void) getAssignmentsForSections:(NSArray*)sections {
    
    PGMAppDelegate *appDelegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.requestManager getAssignmentsForCourses:sections andToken:appDelegate.credentials.getAccessToken onComplete:self.assignmentRequestCompletionHandler];
}

@end

//
//  PGMClssAssignmentSerializer.m
//  classroom-ios
//
//  Created by Joe Miller on 10/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssAssignmentSerializer.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssAssignment.h"
#import "PGMClssAssignmentActivity.h"

@implementation PGMClssAssignmentSerializer

- (NSArray *)deserializeAssignments:(NSData *)data withCourseListItem:(PGMClssCourseListItem *)courseListItem
{
    if (!data)
    {
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSLog(@"JSON from assignment data is: %@:::error: %@", jsonDict, jsonError);
    
    if (jsonError)
    {
        return nil;
    }
    
    NSDictionary *embeddedAssignmentsDict = [jsonDict objectForKey:@"_embedded"];
    NSArray *assignmentDictionaries = [embeddedAssignmentsDict objectForKey:@"assignments"];
    NSMutableArray *assignments = [[NSMutableArray alloc] initWithCapacity:assignmentDictionaries.count];
    for (NSDictionary *assignmentDict in assignmentDictionaries)
    {
        PGMClssAssignment *assignment = [[PGMClssAssignment alloc] initWithDictionary:assignmentDict withCourseListItem:courseListItem];
        assignment.assignmentActivities = [self getEmbeddedAssignmentActivities:assignmentDict withAssignment:assignment];
        [assignments addObject:assignment];
    }
    return assignments;
}

- (NSArray *)deserializeAssignmentActivities:(NSData *)data withAssignment:(PGMClssAssignment *)assignment
{
    if (!data)
    {
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary* jsonDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSLog(@"JSON from assignment activity data is: %@:::error: %@", jsonDict, jsonError);
    
    if (jsonError)
    {
        return nil;
    }
    
    return [self getEmbeddedAssignmentActivities:jsonDict withAssignment:assignment];
}

- (NSArray *)getEmbeddedAssignmentActivities:(NSDictionary *)embeddedDataDict withAssignment:(PGMClssAssignment *)assignment
{
    NSDictionary *embeddedActivities = [embeddedDataDict objectForKey:@"_embedded"];
    NSMutableArray *activityDictionaries = [embeddedActivities objectForKey:@"activities"];
    NSMutableArray *activities = [[NSMutableArray alloc] initWithCapacity:activityDictionaries.count];
    for (NSDictionary *activityDict in activityDictionaries)
    {
        PGMClssAssignmentActivity *activity = [[PGMClssAssignmentActivity alloc] initWithDictionary:activityDict withAssignment:assignment];
        [activities addObject:activity];
    }
    return activities;
}

@end

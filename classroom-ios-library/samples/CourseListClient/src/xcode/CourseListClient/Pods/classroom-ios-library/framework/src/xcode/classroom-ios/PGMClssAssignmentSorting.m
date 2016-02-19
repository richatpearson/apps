//
//  PGMClssAssignmentSorting.m
//  classroom-ios
//
//  Created by Joe Miller on 10/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssAssignmentSorting.h"

@implementation PGMClssAssignmentSorting

+ (NSArray *)sortAssignmentActivities:(NSArray *)assignments
                                   by:(PGMClssAssignmentSortAttribute)attribute
                            ascending:(BOOL)ascending
{
    NSSortDescriptor *sortDescriptor;
    switch (attribute) {
        case PGMClssCourseTitle:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"sectionTitle" ascending:ascending];
            break;
            
        case PGMClssDueDate:
            sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"dueDate" ascending:ascending];
            break;
            
        default:
            break;
    }
    NSArray *descriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    NSArray *activities = [self flattenAssignmentActivites:assignments];
    
    return [activities sortedArrayUsingDescriptors:descriptors];
}

+ (NSArray *)flattenAssignmentActivites:(NSArray *)assignments
{
    NSMutableArray *activities = [NSMutableArray new];
    for (PGMClssAssignment *assignment in assignments)
    {
        [activities addObjectsFromArray:assignment.assignmentActivities];
    }
    return activities;
}

@end

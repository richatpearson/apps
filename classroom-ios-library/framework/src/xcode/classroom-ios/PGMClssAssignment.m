//
//  PGMClssAssignment.m
//  classroom-ios
//
//  Created by Joe Miller on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssAssignment.h"
#import "PGMClssDateUtil.h"
#import "PGMClssAssignmentActivity.h"

@implementation PGMClssAssignment

- (instancetype)initWithDictionary:(NSDictionary *)jsonData withCourseListItem:(PGMClssCourseListItem *)courseListItem
{
    self = [super init];
    if (!self)
    {
        return nil;
    }

    self.assignmentId = [jsonData objectForKey:@"id"];
    self.title = [jsonData objectForKey:@"title"];
    self.assignmentTemplateId = [jsonData objectForKey:@"templateId"];
    self.assignmentDescription = [jsonData objectForKey:@"description"];
    self.lastModified = [PGMClssDateUtil parseDateFromString:[jsonData objectForKey:@"lastModified"]];
    self.sectionId = courseListItem.sectionId;
    self.sectionTitle = courseListItem.sectionTitle;
    
    NSMutableArray *assignmentActivities = [[NSMutableArray alloc] init];
    NSArray *activityData = [jsonData objectForKey:@"activities"];
    if (activityData)
    {
        for (NSDictionary *dict in activityData)
        {
            PGMClssAssignmentActivity *activity = [[PGMClssAssignmentActivity alloc] initWithDictionary:dict withAssignment:self];
            [assignmentActivities addObject:activity];
        }
    }
    self.assignmentActivities = assignmentActivities;
    
    return self;
}

@end

//
//  PGMClssAssignmentActivity.m
//  classroom-ios
//
//  Created by Joe Miller on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssAssignmentActivity.h"
#import "PGMClssDateUtil.h"

@implementation PGMClssAssignmentActivity

- (instancetype)initWithDictionary:(NSDictionary *)jsonData withAssignment:(PGMClssAssignment *)assignment
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.activityId = [jsonData objectForKey:@"id"];
    self.title = [jsonData objectForKey:@"title"];
    self.dueDate = [PGMClssDateUtil parseDateFromString:[jsonData objectForKey:@"dueDate"]];
    self.thumbnailURL = [jsonData objectForKey:@"thumbnailUrl"];
    self.activityDescription = [jsonData objectForKey:@"description"];;
    self.lastModified = [PGMClssDateUtil parseDateFromString:[jsonData objectForKey:@"lastModifiedDate"]];
    self.assignmentId = assignment.assignmentId;
    self.assignmentTitle = assignment.title;
    self.sectionId = assignment.sectionId;
    self.sectionTitle = assignment.sectionTitle;
    
    return self;
}

@end

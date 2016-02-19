//
//  PGMClssCourseListItem.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseListItem.h"
#import "PGMClssDateUtil.h"

@implementation PGMClssCourseListItem

- (instancetype) initWithDictionary:(NSDictionary*)courseItemDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.itemId = [courseItemDict objectForKey:@"id"];
    self.itemStatus = [self convertStatus:[courseItemDict objectForKey:@"status"]];
    self.sectionId = [[courseItemDict objectForKey:@"section"] objectForKey:@"sectionId"];
    self.sectionTitle = [[courseItemDict objectForKey:@"section"] objectForKey:@"sectionTitle"];
    self.sectionCode = [[courseItemDict objectForKey:@"section"] objectForKey:@"sectionCode"];
    self.sectionStartDate = [PGMClssDateUtil parseDateFromString:[[courseItemDict objectForKey:@"section"] objectForKey:@"startDate"]];
    self.sectionEndDate = [PGMClssDateUtil parseDateFromString:[[courseItemDict objectForKey:@"section"] objectForKey:@"endDate"]];
    self.courseId = [[courseItemDict objectForKey:@"section"] objectForKey:@"courseId"];
    self.courseType = [[courseItemDict objectForKey:@"section"] objectForKey:@"courseType"];
    self.avatarUrl = [[courseItemDict objectForKey:@"section"] objectForKey:@"avatarUrl"];
    
    return self;
}

- (PGMClssCourseItemStatus) convertStatus:(NSString*)itemStatusString
{
    if ([itemStatusString isEqualToString:@"pending"]) {
        return 0;
    } else if ([itemStatusString isEqualToString:@"active"]) {
        return 1;
    } else {
        return -1;
    }
}

@end

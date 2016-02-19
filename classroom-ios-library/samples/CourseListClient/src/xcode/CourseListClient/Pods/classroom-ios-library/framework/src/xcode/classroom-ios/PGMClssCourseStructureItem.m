//
//  PGMClssCourseStructureItem.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseStructureItem.h"

@implementation PGMClssCourseStructureItem

@synthesize description;

- (instancetype) initWithDictionary:(NSDictionary*)courseStructDict
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    self.courseStructureItemId = [courseStructDict objectForKey:@"id"];
    self.title = [courseStructDict objectForKey:@"title"];
    self.thumbnailUrl = [courseStructDict objectForKey:@"thumbnailUrl"];
    self.contentUrl = [courseStructDict objectForKey:@"href"];
    self.description = [courseStructDict objectForKey:@"description"];
    
    
    return self;
}

@end

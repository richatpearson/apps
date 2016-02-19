//
//  PGMClssCourseListSerializer.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseListSerializer.h"

@implementation PGMClssCourseListSerializer

- (NSArray*) deserializeCourseListItems:(NSData*)data
{
    if (!data)
    {
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary* jsonCourseIListDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSLog(@"JSON from course list is: %@:::error: %@", jsonCourseIListDict, jsonError);
    
    if (jsonError) {
        return nil;
    }
    
    NSMutableArray *courseList = [[NSMutableArray alloc] init];
    
    for (NSDictionary *courseItemDict in jsonCourseIListDict)
    {
        PGMClssCourseListItem *courseItem = [[PGMClssCourseListItem alloc] initWithDictionary:courseItemDict];
        
        [courseList addObject:courseItem];
    }
    
    return courseList;
}

@end

//
//  PGMClssCourseStructureSerializer.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseStructureSerializer.h"
#import "PGMClssCourseStructureItem.h"

@implementation PGMClssCourseStructureSerializer

- (NSArray*) deserializeCourseStructureItems:(NSData*)data
{
    if (!data)
    {
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary* jsonCourseStructDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSLog(@"JSON from course structure is: %@:::error: %@", jsonCourseStructDict, jsonError);
    
    if (jsonError) {
        return nil;
    }
    
    NSMutableArray *courseStructure = [[NSMutableArray alloc] init];
    NSDictionary *embeddedCourseStructureDict = [jsonCourseStructDict objectForKey:@"_embedded"];
    
    for (NSDictionary *courseStructItemDict in [embeddedCourseStructureDict objectForKey:@"items"])
    {
        PGMClssCourseStructureItem *courseItem = [[PGMClssCourseStructureItem alloc] initWithDictionary:courseStructItemDict];
        
        [courseStructure addObject:courseItem];
    }
    
    return courseStructure;
}

- (NSArray*) deserializeCourseStructureForSingleItem:(NSData*)data
{
    if (!data)
    {
        return nil;
    }
    
    NSError *jsonError = nil;
    NSDictionary* jsonCourseStructItemDict = (NSDictionary*)[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&jsonError];
    NSLog(@"JSON from course structure is: %@:::error: %@", jsonCourseStructItemDict, jsonError);
    
    if (jsonError) {
        return nil;
    }
    
    NSMutableArray *courseStructure = [[NSMutableArray alloc] init];
    
    PGMClssCourseStructureItem *courseItem = [[PGMClssCourseStructureItem alloc] initWithDictionary:jsonCourseStructItemDict];
    [courseStructure addObject:courseItem];
    
    return courseStructure;
}

@end

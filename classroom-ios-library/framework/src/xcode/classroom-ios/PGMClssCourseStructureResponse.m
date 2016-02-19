//
//  PGMClssCourseStructureResponse.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseStructureResponse.h"

@implementation PGMClssCourseStructureResponse

- (void) setError:(NSError *)error
{
    _error = error;
}

- (void) setCourseStructureArray:(NSArray *)array
{
    _courseStructureArray = array;
}

@end

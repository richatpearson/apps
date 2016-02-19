//
//  PGMClssCourseListResponse.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssCourseListResponse.h"

@implementation PGMClssCourseListResponse

- (void) setError:(NSError *)error
{
    _error = error;
}

- (void) setCourseListArray:(NSArray *)array
{
    _courseListArray = array;
}

@end

//
//  PGMClssCourseListResponse.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Response to a course list network request
 */
@interface PGMClssCourseListResponse : NSObject

/** Error, in case the course list network request encounter any problems*/
@property (nonatomic, strong) NSError *error;

/** An array of course list items. For more information on course item item model see PGMClssCourseListItem*/
@property (nonatomic, strong) NSArray *courseListArray;

- (void) setError:(NSError *)error;
- (void) setCourseListArray:(NSArray *)array;

@end

//
//  PGMClssAssignmentSerializer.h
//  classroom-ios
//
//  Created by Joe Miller on 10/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseListItem.h"
#import "PGMClssAssignment.h"

@interface PGMClssAssignmentSerializer : NSObject

- (NSArray *)deserializeAssignments:(NSData *)data withCourseListItem:(PGMClssCourseListItem *)courseListItem;

- (NSArray *)deserializeAssignmentActivities:(NSData *)data withAssignment:(PGMClssAssignment *)assignment;

@end

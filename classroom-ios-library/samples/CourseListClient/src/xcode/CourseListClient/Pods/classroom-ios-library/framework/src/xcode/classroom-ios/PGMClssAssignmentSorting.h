//
//  PGMClssAssignmentSorting.h
//  classroom-ios
//
//  Created by Joe Miller on 10/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssAssignment.h"

/**
 A sorting utility class for assignments and activities.
 */
@interface PGMClssAssignmentSorting : NSObject

+ (NSArray *)sortAssignmentActivities:(NSArray *)assignments
                                  by:(PGMClssAssignmentSortAttribute)attribute
                           ascending:(BOOL)ascending;

@end

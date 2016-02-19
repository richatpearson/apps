//
//  PGMAssignmentsProvider.h
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <classroom-ios/PGMClssRequestManager.h>
#import "PGMClassroomManagerFactory.h"

@interface PGMAssignmentsProvider : NSObject

@property (nonatomic, strong) PGMClssRequestManager *requestManager;

- (instancetype) initWithEnvironmentType:(PGMClssEnvironmentType)environmentType;

- (void) getAssignmentsForSection:(PGMClssCourseListItem*)section;

- (void) getAssignmentsForSections:(NSArray*)sections;

@end

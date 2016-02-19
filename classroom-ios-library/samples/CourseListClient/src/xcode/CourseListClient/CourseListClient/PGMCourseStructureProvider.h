//
//  PGMCourseStructureProvider.h
//  CourseListClient
//
//  Created by Joe Miller on 8/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMCredentials.h"

@interface PGMCourseStructureProvider : NSObject

- (instancetype)initWithCredentials:(PGMCredentials *) credentials;

- (void)courseStructureForSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete;

- (void)courseStructureForItem:(PGMClssCourseStructureItem *)item forSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete;

- (void)childCourseStructureForItem:(PGMClssCourseStructureItem *)item forSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete;

@end

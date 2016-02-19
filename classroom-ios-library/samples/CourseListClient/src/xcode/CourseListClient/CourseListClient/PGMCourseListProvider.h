//
//  PGMCourseListProvider.h
//  CourseListClient
//
//  Created by Joe Miller on 8/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMCredentials.h"

@interface PGMCourseListProvider : NSObject

- (instancetype)initWithCredentials:(PGMCredentials *) credentials;

- (void)populateCourseList:(void (^)(NSArray *))onComplete;

@end

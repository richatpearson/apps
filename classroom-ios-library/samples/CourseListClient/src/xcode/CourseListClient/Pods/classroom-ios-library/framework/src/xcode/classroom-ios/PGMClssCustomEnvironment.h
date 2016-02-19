//
//  PGMClssCustomEnvironment.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Class where developer can define custom environment to use for network requests, which includes some specific URL domains.
 */
@interface PGMClssCustomEnvironment : NSObject

/**
 Property where ustom URL domain for course list can be defined.
 */
@property (nonatomic, strong) NSString *customBaseRequestCourseListUrl;

/**
  Property where ustom URL domain for course structure can be defined.
 */
@property (nonatomic, strong) NSString *customBaseRequestCourseStructUrl;

@end

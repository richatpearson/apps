//
//  PGMClassroomManagerFactory.h
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <classroom-ios/PGMClssRequestManager.h>

@interface PGMClassroomManagerFactory : NSObject

+(PGMClssRequestManager*) createManagerForEnv:(PGMClssEnvironmentType)environmentType;

@end

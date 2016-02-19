//
//  PGMClassroomManagerFactory.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/10/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClassroomManagerFactory.h"

static PGMClssRequestManager *requestManager = nil;

@implementation PGMClassroomManagerFactory

+(PGMClssRequestManager*) createManagerForEnv:(PGMClssEnvironmentType)environmentType {
    if (!requestManager) {
        requestManager = [[PGMClssRequestManager alloc] initWithFetchPolicy:PGMClssNetworkFirst];
        PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:environmentType];
        [requestManager setEnvironment:env];
    }
    
    return requestManager;
}

@end

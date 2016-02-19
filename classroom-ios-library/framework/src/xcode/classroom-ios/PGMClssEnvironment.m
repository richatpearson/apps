//
//  PGMClssEnfironment.m
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssEnvironment.h"

NSString* const PGMClssDefaultBaseCourseList_Staging    = @"http://pearsonbuild-staging.apigee.net/";
NSString* const PGMClssDefaultBaseCourseStruct_Staging  = @"http://pearsonbuild-staging.apigee.net/";

@implementation PGMClssEnvironment

- (instancetype) initEnvironmentWithType:(PGMClssEnvironmentType)envType
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    switch (envType) {
        case PGMClssStaging:
            [self setEnvironmentToStaging];
            break;
        case PGMClssProduction:
            [self setEnvironmentToProd];
            break;
        default:
            break;
    }
    
    return self;
}

- (instancetype) initWithCustomEnvironment:(PGMClssCustomEnvironment*)customEnv
{
    self = [super init];
    if (!self)
    {
        return nil;
    }
    
    [self setEnvironmentToCustom:customEnv];
    
    return self;
}

- (void) setEnvironmentToStaging
{
    self.baseRequestCourseListUrl = PGMClssDefaultBaseCourseList_Staging;
    self.baseRequestCourseStructUrl = PGMClssDefaultBaseCourseStruct_Staging;
}

- (void) setEnvironmentToProd
{
    self.baseRequestCourseListUrl = @"";
    self.baseRequestCourseStructUrl = @"";
}

- (void) setEnvironmentToCustom:(PGMClssCustomEnvironment*)customEnv
{
    if (customEnv)
    {
        self.baseRequestCourseListUrl = customEnv.customBaseRequestCourseListUrl;
        self.baseRequestCourseStructUrl = customEnv.customBaseRequestCourseStructUrl;
    }
}

@end

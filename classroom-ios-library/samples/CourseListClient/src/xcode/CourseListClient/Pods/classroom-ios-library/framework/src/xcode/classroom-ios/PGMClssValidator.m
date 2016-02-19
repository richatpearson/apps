//
//  PGMClssValidator.m
//  classroom-ios
//
//  Created by Joe Miller on 10/20/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMClssValidator.h"
#import "PGMClssError.h"

@implementation PGMClssValidator

+ (NSError *)validateCourseStructureEnvironment:(PGMClssEnvironment *)environment
{
    NSError *envError;
    if (!environment || !environment.baseRequestCourseStructUrl || [environment.baseRequestCourseStructUrl isEqualToString:@""])
    {
        NSString *noEnvErrorDescription = @"Environment is not defined";
        envError = [PGMClssError createClssErrorForErrorCode:PGMClssEnvironmentNotDefinedError andDescription:noEnvErrorDescription];
    }
    return envError;
}

@end

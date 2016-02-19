//
//  PGMClssEnfironment.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCustomEnvironment.h"

/**
 Envrionment type enumeration
 */
typedef NS_ENUM(NSInteger,PGMClssEnvironmentType) {
    /** No environment*/
    PGMClssNoEnvironment  = -1,
    /** Staging environment*/
    PGMClssStaging        = 0,
    /** Production environment*/
    PGMClssProduction     = 1,
    /** Custom environment*/
    PGMClssCustom         = 2
};
/** PGMClssDefaultBaseCourseList_Staging constant defining url domain for Course List request in Staging env*/
extern NSString* const PGMClssDefaultBaseCourseList_Staging;

/** PGMClssDefaultBaseCourseStruct_Staging constant defining url domain for Course Structure request in Staging env*/
extern NSString* const PGMClssDefaultBaseCourseStruct_Staging;

/**
 Class where developer can define the environment to use for network calls, which includes some specific URL domains.
 */
@interface PGMClssEnvironment : NSObject

/**
 Domain portion of URL for Course List request
 */
@property (nonatomic, strong) NSString *baseRequestCourseListUrl;

/**
 Domain portion of URL for Course Structure request
 */
@property (nonatomic, strong) NSString *baseRequestCourseStructUrl;

/**
 Initialization call that creates an instance of this class (PGMClssEnvironment)
 
 @param envType environment type. For all possbile values see PGMClssEnvironmentType enumeration
 */
- (instancetype) initEnvironmentWithType:(PGMClssEnvironmentType)envType;

/**
 Initialization call that creates an instance of this class (PGMClssEnvironment)
 
 @param customEnv Instannce of custom environment (PGMClssCustomEnvironment) object.
 */
- (instancetype) initWithCustomEnvironment:(PGMClssCustomEnvironment*)customEnv;

@end

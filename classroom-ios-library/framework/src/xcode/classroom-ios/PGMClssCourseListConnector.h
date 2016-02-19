//
//  PGMClssCourseListConnector.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseListResponse.h"
#import "PGMClssEnvironment.h"
#import <Core-ios-sdk/PGMCoreSessionManager.h>

/**
 Block used for handling the completion of course list request.
 
 typedef void (^CourseListNetworkRequestComplete)(PGMClssCourseListResponse*);
 */
typedef void (^CourseListNetworkRequestComplete)(PGMClssCourseListResponse*);
//typedef void (^DummyType);

@interface PGMClssCourseListConnector : NSObject

@property (nonatomic, strong) PGMCoreSessionManager *coreSessionManager;

- (void) runCourseListRequestForUser:(NSString*)userIdentityId
                            andToken:(NSString*)userToken
                      forEnvironment:(PGMClssEnvironment*)env
                        withResponse:(PGMClssCourseListResponse*)response
                          onComplete:(CourseListNetworkRequestComplete)onComplete;
@end

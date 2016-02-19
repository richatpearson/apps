//
//  PGMClssAssignmentConnector.h
//  classroom-ios
//
//  Created by Joe Miller on 10/9/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMCoreSessionManager.h"
#import "PGMClssEnvironment.h"
#import "PGMClssCourseListItem.h"
#import "PGMClssAssignmentResponse.h"

// Block used for completion of assignments request
typedef void (^AssignmentNetworkRequestComplete)(PGMClssAssignmentResponse *);

@interface PGMClssAssignmentConnector : NSObject

@property (nonatomic, strong) PGMCoreSessionManager *coreSessionManager;

- (void)runAssignmentsWithActivitiesRequestWithToken:(NSString *)userToken
                                           forCourse:(PGMClssCourseListItem *)courseListItem
                                      andEnvironment:(PGMClssEnvironment *)env
                                        withResponse:(PGMClssAssignmentResponse *)response
                                          onComplete:(AssignmentNetworkRequestComplete)onComplete;

@end

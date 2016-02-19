//
//  PGMClssCourseStructureConnector.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseStructureResponse.h"
#import "PGMClssEnvironment.h"
#import <Core-ios-sdk/PGMCoreSessionManager.h>

/**
 Block used for handling the completion of course structure request.
 
 typedef void (^CourseStructNetworkRequestComplete)(PGMClssCourseStructureResponse*);
 */
typedef void (^CourseStructNetworkRequestComplete)(PGMClssCourseStructureResponse*);

@interface PGMClssCourseStructureConnector : NSObject

@property (nonatomic, strong) PGMCoreSessionManager *coreSessionManager;

- (void) runCourseStructRequestWithToken:(NSString*)userToken
                              forSection:(NSString*)sectionId
                          andEnvironment:(PGMClssEnvironment*)env
                            withResponse:(PGMClssCourseStructureResponse*)response
                              onComplete:(CourseStructNetworkRequestComplete)onComplete;

- (void) runCourseStructRequestForItem:(NSString*)itemId
                             withToken:(NSString*)userToken
                            forSection:(NSString*)sectionId
                        andEnvironment:(PGMClssEnvironment*)env
                          withResponse:(PGMClssCourseStructureResponse*)response
                            onComplete:(CourseStructNetworkRequestComplete)onComplete;

- (void) runChildCourseStructRequestForItem:(NSString*)itemId
                                  withToken:(NSString*)userToken
                                 forSection:(NSString*)sectionId
                             andEnvironment:(PGMClssEnvironment*)env
                               withResponse:(PGMClssCourseStructureResponse*)response
                                 onComplete:(CourseStructNetworkRequestComplete)onComplete;


@end

//
//  PGMCourseListProvider.m
//  CourseListClient
//
//  Created by Joe Miller on 8/18/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <classroom-ios/PGMClssRequestManager.h>
#import <classroom-ios/PGMClssEnvironment.h>
#import "PGMCourseListProvider.h"
#import "PGMCredentials.h"

@interface PGMCourseListProvider ()

@property (nonatomic, strong) PGMCredentials *credentials;

@end

@implementation PGMCourseListProvider

- (instancetype)initWithCredentials:(PGMCredentials *) credentials
{
    if (self = [super init])
    {
        self.credentials = credentials;
    }
    return self;
}

- (void)populateCourseList:(void (^)(NSArray *))onComplete
{
    PGMClssRequestManager *clssRequestManager = [[PGMClssRequestManager alloc] initWithFetchPolicy:PGMClssNetworkFirst];
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    [clssRequestManager setEnvironment:env];
    
    NSLog(@"Calling getCourseListForUser userIdentity=%@, accessToken=%@", [self.credentials getUserIdentity], [self.credentials getAccessToken]);
    [clssRequestManager getCourseListForUser:[self.credentials getUserIdentity]
                                   withToken:[self.credentials getAccessToken]
                                  onComplete:^(PGMClssCourseListResponse *response) {
                                      if (response.error)
                                      {
                                          NSLog(@"Error getting course list for user");
                                      }
                                      else
                                      {
                                          onComplete([[NSMutableArray alloc] initWithArray:response.courseListArray]);
                                      }
                                  }];
}

@end

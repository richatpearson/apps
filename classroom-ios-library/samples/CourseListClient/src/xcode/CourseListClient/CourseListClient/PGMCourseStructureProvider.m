//
//  PGMCourseStructureProvider.m
//  CourseListClient
//
//  Created by Joe Miller on 8/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <classroom-ios/PGMClssRequestManager.h>
#import <classroom-ios/PGMClssEnvironment.h>
#import <classroom-ios/PGMClssCourseStructureItem.h>
#import "PGMCourseStructureProvider.h"

@interface PGMCourseStructureProvider ()

@property (nonatomic, strong) PGMCredentials *credentials;

@end

@implementation PGMCourseStructureProvider

- (instancetype)initWithCredentials:(PGMCredentials *) credentials
{
    if (self = [super init])
    {
        self.credentials = credentials;
    }
    return self;
}

- (void)courseStructureForSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete
{
    PGMClssRequestManager *clssRequestManager = [self getRequestManager];
    [clssRequestManager getCourseStructureWithToken:[self.credentials getAccessToken]
                                         forSection:sectionID
                                         onComplete:^(PGMClssCourseStructureResponse *response) {
                                             if (response.error)
                                             {
                                                 NSLog(@"Error getting course structure for user");
                                             }
                                             else
                                             {
                                                 onComplete([[NSMutableArray alloc] initWithArray:response.courseStructureArray]);
                                             }
                                         }];
}

- (void)courseStructureForItem:(PGMClssCourseStructureItem *)item forSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete
{
    PGMClssRequestManager *clssRequestManager = [self getRequestManager];
    NSLog(@"Course structure item id is: %@", item.courseStructureItemId);
    [clssRequestManager getCourseStructureItemWithId:item.courseStructureItemId
                                            andToken:[self.credentials getAccessToken]
                                          forSection:sectionID
                                          onComplete:^(PGMClssCourseStructureResponse *response) {
                                           if (response.error)
                                           {
                                               NSLog(@"Error getting course list for user");
                                           }
                                           else
                                           {
                                               onComplete([[NSMutableArray alloc] initWithArray:response.courseStructureArray]);
                                           }
                                       }];
}

- (void)childCourseStructureForItem:(PGMClssCourseStructureItem *)item forSection:(NSString *)sectionID onComplete:(void (^)(NSArray *))onComplete
{
    PGMClssRequestManager *clssRequestManager = [self getRequestManager];
    NSLog(@"Course structure Parent item is %@", item.courseStructureItemId);
    [clssRequestManager getCourseStructureChildItemsWithParentId:item.courseStructureItemId
                                                        andToken:[self.credentials getAccessToken]
                                                      forSection:sectionID
                                                      onComplete:^(PGMClssCourseStructureResponse *response) {
                                                if (response.error)
                                                {
                                                    NSLog(@"Error getting course list for user");
                                                }
                                                else
                                                {
                                                    onComplete([[NSMutableArray alloc] initWithArray:response.courseStructureArray]);
                                                }
                                            }];
}

- (PGMClssRequestManager *)getRequestManager
{
    PGMClssRequestManager *clssRequestManager = [[PGMClssRequestManager alloc] initWithFetchPolicy:PGMClssNetworkFirst];
    PGMClssEnvironment *env = [[PGMClssEnvironment alloc] initEnvironmentWithType:PGMClssStaging];
    [clssRequestManager setEnvironment:env];
    return clssRequestManager;
}

@end

//
//  PGMClssRequestManager.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseListItem.h"
#import "PGMClssCourseListResponse.h"
#import "PGMClssEnvironment.h"
#import "PGMClssCustomEnvironment.h"
#import "PGMClssCourseStructureResponse.h"
#import "PGMClssCourseListConnector.h"
#import "PGMClssCourseStructureConnector.h"
#import "PGMClssAssignmentResponse.h"
#import "PGMClssAssignmentConnector.h"

/*!
 Block used for handling the completion of course structure request.
 
 typedef void (^CourseStructRequestComplete)(PGMClssCourseStructureResponse*);
 */
typedef void (^CourseStructRequestComplete)(PGMClssCourseStructureResponse*);
//typedef void (^DummyType);

/*!
 Block used for handling the completion of course list request.
 
 typedef void (^CourseListRequestComplete)(PGMClssCourseListResponse*);
 */
typedef void (^CourseListRequestComplete)(PGMClssCourseListResponse*);

/*!
 Block used for handling the completion of an assignments request.
 
 typedef void (^AssignmentRequestComplete)(PGMClssAssignmentResponse *);
 */
typedef void (^AssignmentRequestComplete)(PGMClssAssignmentResponse *);

/**
 Data fetch modes enumeration
*/
typedef NS_ENUM(NSInteger, PGMClssFetchPolicy)
{
    /**  Network first*/
    PGMClssNetworkFirst = 0,
    /**  Only network*/
    PGMClssNetworkOnly  = 1,
    /**  Local storage first*/
    PGMClssLocalFirst   = 2,
    /**  Only local storage*/
    PGMClssLocalOnly    = 3,
};

/**
 This is top level class which clients use to send classroom-related requests.
*/
@interface PGMClssRequestManager : NSObject

/**
 Environment object set by user when calling setEnvironment. It has url base paths which are used when making network calls
*/
@property (nonatomic, readonly) PGMClssEnvironment *clssEnvironment;

@property (nonatomic, strong) PGMClssCourseListConnector *courseListConnector;

@property (nonatomic, strong) PGMClssCourseStructureConnector *courseStructConnector;

@property (nonatomic, strong) PGMClssAssignmentConnector *assignmentConnector;

/**
 Initialization call that creates an instance of this class (PGMClssRequestManager)
 
 @param fetchPolicy Specifies manager's behavior with respect to off-line storage. eg: if PGMClssLocalFirst is passed,
 then the manager retrieves the needed data from local storage first before making the network call.
 
 For all possible values of fetchPolicy parameter see PGMClssFetchPolicy data fetch modes enumeration.
*/
- (instancetype) initWithFetchPolicy:(PGMClssFetchPolicy)fetchPolicy;

/**
 Defines which environment should be used for network calls.
 
 @param environment The environment the request manager needs to use for netowrk calls.
 
 For more information see documentation for PGMClssEnvironment.
*/
- (BOOL) setEnvironment:(PGMClssEnvironment*)environment;

/**
 Obtains all courses associated to user.
 
 @param userIdentityId Pi identity id for this user
 @param userToken access token for this user
 @param onComplete completion handler
 
 @return object of PGMClssCourseListResponse type
 */
- (PGMClssCourseListResponse*) getCourseListForUser:(NSString*)userIdentityId
                                          withToken:(NSString*)userToken
                                         onComplete:(CourseListRequestComplete)onComplete;

/**
 Obtains course structure items for a specific section (occurrence of a course) which is associated to the user.
 
 @param token Access token for this user
 @param sectionId Unique identifier for this section (occurrence of a course)
 @param onComplete completion handler
 
 @return object of PGMClssCourseStructureResponse type
 */
- (PGMClssCourseStructureResponse*) getCourseStructureWithToken:(NSString*)token
                                                     forSection:(NSString*)sectionId
                                                     onComplete:(CourseStructRequestComplete)onComplete;

/**
 Obtains a specific item from course structure for a specific section (occurrence of a course) which is associated to the user.
 
 @param itemId Unique identifier for the pecific item for this course structure
 @param token Access token for this user
 @param sectionId Unique identifier for this section (occurrence of a course)
 @param onComplete completion handler
 
 @return object of PGMClssCourseStructureResponse type
 */
- (PGMClssCourseStructureResponse*) getCourseStructureItemWithId:(NSString*)itemId
                                                        andToken:(NSString*)token
                                                      forSection:(NSString*)sectionId
                                                      onComplete:(CourseStructRequestComplete)onComplete;

/**
 Obtains child items for a specific item from course structure for a specific section (occurrence of a course) which is associated to the user.
 
 @param itemId Unique identifier for the pecific item for which child items are returned
 @param token Access token for this user
 @param sectionId Unique identifier for this section (occurrence of a course)
 @param onComplete completion handler
 
 @return object of PGMClssCourseStructureResponse type
 */
- (PGMClssCourseStructureResponse*) getCourseStructureChildItemsWithParentId:(NSString*)itemId
                                                                    andToken:(NSString*)token
                                                                  forSection:(NSString*)sectionId
                                                                  onComplete:(CourseStructRequestComplete)onComplete;

/**
 Obtains assignments for a specific section (occurrence of a course) represented by a course list item.
 
 @param courseListItem A course list item containing a section to get assignments for
 @param token Access token for this user
 @param onComplete Completion handler that accepts NSArray of PGMClssAssignment
 */
- (PGMClssAssignmentResponse *)getAssignmentsForCourse:(PGMClssCourseListItem *)courseListItem
                                              andToken:(NSString *)token
                                            onComplete:(AssignmentRequestComplete)onComplete;

/**
 Obtains assignments for all sections provided in the course list items array. The returned array of assignments is
 unsorted. See also PGMClssAssignmentSorting.
 
 @param courseListItems NSArray of PGMClssCourseListItem
 @param token Access token for this user
 @param onComplete Completion handler that accepts NSArray of PGMClssAssignment
 */
- (PGMClssAssignmentResponse *)getAssignmentsForCourses:(NSArray *)courseListItems
                                               andToken:(NSString *)token
                                             onComplete:(AssignmentRequestComplete)onComplete;

@end

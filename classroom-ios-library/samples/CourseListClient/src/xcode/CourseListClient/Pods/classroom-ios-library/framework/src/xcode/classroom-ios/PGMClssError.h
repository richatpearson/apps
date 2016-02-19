//
//  PGMClssError.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/12/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* const PGMClssErrorDomain;

/**
 Error codes returned with an error
 */
typedef NS_ENUM(NSInteger, PGMClssClientErrorCode)
{
    /** Error is unknown */
    PGMClssUnknownError                   = -1,
    /** Pi user identity id is missig in request*/
    PGMClssMissingUserIdentityError       = 0,
    /** User token is missing from request*/
    PGMClssMissingTokenError              = 1,
    /** Not able to deserialize the response body from back-end service*/
    PGMClssUnableToDeserializeError       = 2,
    /** Unable to make Course List network call*/
    PGMClssCourseListNetworkCallError     = 3,
    /** No environment defined - required to make network calls*/
    PGMClssEnvironmentNotDefinedError     = 4,
    /** Section Id is missing in request*/
    PGMClssMissingSectionIdError          = 5,
    /** Course structure item id is missing in request*/
    PGMClssMissingCourseStructItemIdError = 6,
    /** Unable to make Course Structure network call*/
    PgMClssCourseStructNetworkCallError   = 7,
    /** Course list item is missing from request */
    PGMClssMissingCourseListItemError     = 8,
};

/*!
 Class to report any errors in the response object.
*/
@interface PGMClssError : NSObject

/**
 Class method to create an instance of an error.
 
 @param errorCode Error code denoting the problem. See PGMClssClientErrorCode enumeration for more information.
 @param errorDescription Description for this error.
 
 @return Instance of NSError class.
 */
+ (NSError*) createClssErrorForErrorCode:(PGMClssClientErrorCode)errorCode
                          andDescription:(NSString*)errorDescription;

@end

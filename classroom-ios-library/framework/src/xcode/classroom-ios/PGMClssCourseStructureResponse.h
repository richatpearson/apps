//
//  PGMClssCourseStructureResponse.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Response type for course structure request
 */
typedef NS_ENUM(NSInteger, PGMClssCourseStructureResponseType)
{
    /** Entire course structure for a given section*/
    PGMClssParentItems  = 1,
    /** A single course structure item for a given section*/
    PGMClssSingleItem   = 2,
    /** Child items for a single course structure item for a given section*/
    PGMClssChildItems   = 3,
};

/**
 Response to a course structure network request
 */
@interface PGMClssCourseStructureResponse : NSObject

/** Error, in case the course structure network request encounter any problems*/
@property (nonatomic, strong) NSError *error;

/** An array of course structure items. For more information on course structure item model see PGMClssCourseStructureItem*/
@property (nonatomic, strong) NSArray *courseStructureArray;

/** Type of a Course Structure response. More list of valid values see PGMClssCourseStructureResponseType*/
@property (nonatomic, assign) PGMClssCourseStructureResponseType responseType;

- (void) setError:(NSError *)error;
- (void) setCourseStructureArray:(NSArray *)array;
- (void) setResponseType:(PGMClssCourseStructureResponseType)type;

@end

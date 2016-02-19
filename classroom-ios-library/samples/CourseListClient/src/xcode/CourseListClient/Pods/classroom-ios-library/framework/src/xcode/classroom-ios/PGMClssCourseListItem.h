//
//  PGMClssCourseListItem.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Status for course item
 */
typedef NS_ENUM(NSInteger, PGMClssCourseItemStatus) {
    unknown = -1,
    pending = 0,
    active = 1
};

/**
 Model class to represent an item from course list
 */
@interface PGMClssCourseListItem : NSObject

/** A unique identifier for course list item*/
@property (nonatomic, strong) NSString *itemId;
/** Status of course list item. For more information see PGMClssCourseItemStatus*/
@property (nonatomic, assign) PGMClssCourseItemStatus itemStatus;
/** A unique identifier for section - an occurrence of a course*/
@property (nonatomic, strong) NSString *sectionId;
/** Title of the section*/
@property (nonatomic, strong) NSString *sectionTitle;
/** Code for the section*/
@property (nonatomic, strong) NSString *sectionCode;
/** Start date for the section*/
@property (nonatomic, strong) NSDate *sectionStartDate;
/** End date for the section*/
@property (nonatomic, strong) NSDate *sectionEndDate;
/** A unique identifier for the course*/
@property (nonatomic, strong) NSString *courseId;
/** Type of the course*/
@property (nonatomic, strong) NSString *courseType;
/** URL to the avatar for this course list item*/
@property (nonatomic, strong) NSString *avatarUrl;

/**
 Initialization call that creates an instance of this class (PGMClssCourseListItem)
 
 @param jsonData JSON data - response from a network call - that needs to be deserialized to this object.
 */
- (instancetype) initWithDictionary:(NSDictionary*)jsonData;

@end

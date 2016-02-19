//
//  PGMClssAssignment.h
//  classroom-ios
//
//  Created by Joe Miller on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseListItem.h"

// Sorting attributes
typedef NS_ENUM(NSInteger, PGMClssAssignmentSortAttribute) {
    PGMClssCourseTitle,
    PGMClssDueDate
};

/**
 Represents an assignment. An assignment does not have a due date. Rather, an assignment has activities that each have
 a due date. An assignment also has information about the section (course) that it belongs to.
 */
@interface PGMClssAssignment : NSObject
// The internal ID of the assignment
@property (nonatomic, strong) NSString *assignmentId;
// Assignment title
@property (nonatomic, strong) NSString *title;
// If a template ID exists, this instance is an assignment template
@property (nonatomic, strong) NSString *assignmentTemplateId;
// Assignment description
@property (nonatomic, strong) NSString *assignmentDescription;
// Date this assignment was last modified
@property (nonatomic, strong) NSDate *lastModified;
// This assignment's activities. Unsorted.
@property (nonatomic, strong) NSArray *assignmentActivities;
// The ID of the section this assignment belongs to
@property (nonatomic, strong) NSString *sectionId;
// The title of the section this assignment belongs to
@property (nonatomic, strong) NSString *sectionTitle;

// Initialize this assignment instance with data returned from a JSON payload for a course list item
- (instancetype)initWithDictionary:(NSDictionary *)jsonData withCourseListItem:(PGMClssCourseListItem *)courseListItem;

@end

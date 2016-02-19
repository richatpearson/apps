//
//  PGMClssAssignmentActivity.h
//  classroom-ios
//
//  Created by Joe Miller on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssAssignment.h"

/**
 Represents an activity that's related to an assignment. For example, an assignment may be "Complete Module 1", with
 activities "Read Chapter 1", "Write Chapter 1 Summary", "Complete Chapter 1 Exercises". Assignment activities have
 due dates. An assignment activity also has information about the assignment and section (course) that it belongs to.
 */
@interface PGMClssAssignmentActivity : NSObject
// The internal ID of this activity
@property (nonatomic, strong) NSString *activityId;
// Activity title
@property (nonatomic, strong) NSString *title;
// Activity due date
@property (nonatomic, strong) NSDate *dueDate;
// URL for the activity thumbnail
@property (nonatomic, strong) NSString *thumbnailURL;
// Activity description
@property (nonatomic, strong) NSString *activityDescription;
// The date this activity was last modified
@property (nonatomic, strong) NSDate *lastModified;
// The internal ID of the assignment this activity belongs to
@property (nonatomic, strong) NSString *assignmentId;
// The title of the assignment this activity belongs to
@property (nonatomic, strong) NSString *assignmentTitle;
// The internal ID of the section this activity belongs to
@property (nonatomic, strong) NSString *sectionId;
// The title of the section this activity belongs to
@property (nonatomic, strong) NSString *sectionTitle;

// Initialize this assignment activity instance with data returned from a JSON payload for an assignment
- (instancetype)initWithDictionary:(NSDictionary *)jsonData withAssignment:(PGMClssAssignment *)assignment;

@end

//
//  PGMClssCourseStructureItem.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Model class to represent an item from course structure
 */
@interface PGMClssCourseStructureItem : NSObject

/** A unique identifier for course structure item*/
@property (nonatomic, strong) NSString *courseStructureItemId;
/** Title for course structure item*/
@property (nonatomic, strong) NSString *title;
/** URL to thumbnail for course structure item*/
@property (nonatomic, strong) NSString *thumbnailUrl;
/** Content, such as a document, video, etc. for this course structure item*/
@property (nonatomic, strong) NSString *contentUrl;
/** Description for this course structure item*/
@property (nonatomic, strong) NSString *description;

/**
 Initialization call that creates an instance of this class (PGMClssCourseStructureItem)
 
 @param jsonData JSON data - response from a network call - that needs to be deserialized to this object.
 */
- (instancetype) initWithDictionary:(NSDictionary*)jsonData;

@end

//
//  PGMClssCourseListSerializer.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssCourseListItem.h"

@interface PGMClssCourseListSerializer : NSObject

- (NSArray*) deserializeCourseListItems:(NSData*)data;

@end

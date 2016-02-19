//
//  PGMClssCourseStructureSerializer.h
//  classroom-ios
//
//  Created by Richard Rosiak on 8/28/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGMClssCourseStructureSerializer : NSObject

- (NSArray*) deserializeCourseStructureItems:(NSData*)data;

- (NSArray*) deserializeCourseStructureForSingleItem:(NSData*)data;

@end

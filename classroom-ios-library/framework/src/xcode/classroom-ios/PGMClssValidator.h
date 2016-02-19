//
//  PGMClssValidator.h
//  classroom-ios
//
//  Created by Joe Miller on 10/20/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGMClssEnvironment.h"

@interface PGMClssValidator : NSObject

+ (NSError *)validateCourseStructureEnvironment:(PGMClssEnvironment *)environment;

@end

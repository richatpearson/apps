//
//  PGMClssAssignmentResponse.h
//  classroom-ios
//
//  Created by Joe Miller on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Represents a response from an assignments request.
 */
@interface PGMClssAssignmentResponse : NSObject

@property (nonatomic, strong) NSError *error;
// NSArray of PGMClssAssignment
@property (nonatomic, strong) NSArray *assignmentsArray;

@end

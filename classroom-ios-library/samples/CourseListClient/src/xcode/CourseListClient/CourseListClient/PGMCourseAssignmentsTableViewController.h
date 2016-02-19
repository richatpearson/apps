//
//  PGMCourseAssignmentsTableViewController.h
//  CourseListClient
//
//  Created by Richard Rosiak on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMClssCourseListItem.h"

@interface PGMCourseAssignmentsTableViewController : UITableViewController

@property (strong, nonatomic) IBOutlet UINavigationItem *courseAssignmentsNavigationItem;
@property (nonatomic, strong) PGMClssCourseListItem *courseListItem;

@end

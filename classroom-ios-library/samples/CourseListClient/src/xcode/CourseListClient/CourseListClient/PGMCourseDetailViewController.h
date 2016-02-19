//
//  PGMCourseDetailViewController.h
//  CourseListClient
//
//  Created by Joe Miller on 8/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <classroom-ios/PGMClssCourseListItem.h>

@interface PGMCourseDetailViewController : UIViewController

@property (nonatomic, strong) PGMClssCourseListItem *courseListItem;

- (IBAction)showCourseAssignments:(id)sender;

@end

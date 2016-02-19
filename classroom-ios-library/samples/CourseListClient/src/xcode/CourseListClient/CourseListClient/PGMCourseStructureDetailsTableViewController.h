//
//  PGMCourseStructureDetailsTableViewController.h
//  CourseListClient
//
//  Created by Joe Miller on 9/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <classroom-ios/PGMClssCourseStructureItem.h>

@interface PGMCourseStructureDetailsTableViewController : UITableViewController

@property (nonatomic, strong) NSString *sectionID;
@property (nonatomic, strong) PGMClssCourseStructureItem *courseStructureItem;

@end

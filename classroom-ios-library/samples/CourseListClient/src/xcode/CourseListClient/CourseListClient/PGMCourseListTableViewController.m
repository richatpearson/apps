//
//  PGMCourseListTableViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 8/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCourseListTableViewController.h"
#import <classroom-ios/PGMClssRequestManager.h>
#import <classroom-ios/PGMClssEnvironment.h>
#import <classroom-ios/PGMClssCourseListItem.h>
#import <classroom-ios/PGMClssEnvironment.h>
#import "PGMAppDelegate.h"
#import "PGMCourseDetailViewController.h"
#import "PGMCourseListProvider.h"
#import "PGMAssignmentsAllCoursesTableViewController.h"

@interface PGMCourseListTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *courseListTableView;
@property (strong, nonatomic) NSMutableArray *courseListItems;

@property (nonatomic, strong) UIBarButtonItem *assignmentsButton;

@end

@implementation PGMCourseListTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.assignmentsButton = [[UIBarButtonItem alloc] initWithTitle:@"Assignments"
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(showAssignmentsAllCourses:)];
    
    NSArray *buttonItems = @[self.assignmentsButton];
    self.navigationItem.rightBarButtonItems = buttonItems;
    
    [self loadCourseList];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.courseListTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadCourseList
{
    self.courseListItems = [[NSMutableArray alloc] init];
    PGMAppDelegate *delegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    PGMCourseListProvider *courseListProvider = [[PGMCourseListProvider alloc] initWithCredentials:delegate.credentials];
    [courseListProvider populateCourseList:^(NSArray *courseListItems) {
        [self.courseListItems addObjectsFromArray:courseListItems];
        [self.courseListTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.courseListItems ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseListItems ? self.courseListItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseTitleCell" forIndexPath:indexPath];
    PGMClssCourseListItem *courseListItem = [self.courseListItems objectAtIndex:indexPath.row];
    cell.textLabel.text = courseListItem.sectionTitle;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"CourseDetailSegue"])
    {
        // Get reference to the destination view controller
        PGMCourseDetailViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.courseListTableView indexPathForCell:cell];        
        vc.courseListItem = [self.courseListItems objectAtIndex:indexPath.row];
    }
    if ([[segue identifier] isEqualToString:@"AssignmentsAllCoursesSegue"])
    {
        PGMAssignmentsAllCoursesTableViewController *vc = [segue destinationViewController];
        vc.courseListItems = self.courseListItems;
    }
}

- (void) showAssignmentsAllCourses: (id)sender
{
    NSLog(@"Show assignments pressed");
    
    [self segueToAllAssignments];
}

- (void)segueToAllAssignments
{
    [UIView animateWithDuration:0.5
                     animations:nil
                     completion:^(BOOL finished){
                         [self performSegueWithIdentifier: @"AssignmentsAllCoursesSegue" sender: self];
                     }];
}

@end

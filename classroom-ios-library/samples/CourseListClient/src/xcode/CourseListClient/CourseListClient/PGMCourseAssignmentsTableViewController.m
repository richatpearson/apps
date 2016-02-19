//
//  PGMCourseAssignmentsTableViewController.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCourseAssignmentsTableViewController.h"
#import "PGMAppDelegate.h"
#import "PGMAssignmentsProvider.h"
#import "PGMClssAssignmentSorting.h"
#import "PGMClssAssignmentActivity.h"

@interface PGMCourseAssignmentsTableViewController ()

@property (nonatomic, strong) PGMClssAssignmentResponse *assignmentResponse;
@property (nonatomic, strong) NSArray *assignmentActivitySorted;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation PGMCourseAssignmentsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMM dd, YYYY HH:mm"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.courseAssignmentsNavigationItem.title = [NSString stringWithFormat:@"%@ Assignments", self.courseListItem.sectionTitle];
    
    PGMAssignmentsProvider *assignmentProvider = [[PGMAssignmentsProvider alloc] initWithEnvironmentType:PGMClssStaging];
    [self addCourseAssignmentObservers];
    [assignmentProvider getAssignmentsForSection:self.courseListItem];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Assignment notification

- (void) addCourseAssignmentObservers {

    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(courseAssignmentsError:)
                                                 name: @"CourseAssignmentsError"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                         selector: @selector(courseAssignmentsComplete:)
                                             name: @"CourseAssignmentsComplete"
                                           object: nil];
}

- (void) courseAssignmentsError:(NSNotification*)notification {
    
    [self removeCourseAssignmentObservers];
    self.assignmentResponse = (PGMClssAssignmentResponse*)notification.object;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:self.assignmentResponse.error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) courseAssignmentsComplete:(NSNotification*)notification {
    
    [self removeCourseAssignmentObservers];
    self.assignmentResponse = (PGMClssAssignmentResponse*)notification.object;
    NSLog(@"Got assignments back and the array has: %lu assignments.", (long)[self.assignmentResponse.assignmentsArray count]);
    
    _assignmentActivitySorted = [PGMClssAssignmentSorting sortAssignmentActivities:self.assignmentResponse.assignmentsArray by:PGMClssDueDate ascending:YES];
    
    [self.tableView reloadData];
}

- (void) removeCourseAssignmentObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"CourseAssignmentsError" object:nil];
    [center removeObserver:self name:@"CourseAssignmentsComplete" object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return ([_assignmentActivitySorted count] > 0) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [_assignmentActivitySorted count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"assignmentActivityCell" forIndexPath:indexPath];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"assignmentActivityCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    PGMClssAssignmentActivity *assignmentActivity = [_assignmentActivitySorted objectAtIndex:indexPath.row];
    cell.textLabel.text = [self formatDateAsString:assignmentActivity.dueDate];
    cell.textLabel.font = [UIFont  boldSystemFontOfSize:12];
    
    cell.detailTextLabel.text = assignmentActivity.title;
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    
    return cell;
}

- (NSString*) formatDateAsString:(NSDate*)date {
    return [self.dateFormatter stringFromDate:date];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

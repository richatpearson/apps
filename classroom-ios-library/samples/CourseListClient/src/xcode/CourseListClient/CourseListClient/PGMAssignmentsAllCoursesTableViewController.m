//
//  PGMClassroomDashboardViewController.m
//  CourseListClient
//
//  Created by Richard Rosiak on 10/7/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMAssignmentsAllCoursesTableViewController.h"
#import "PGMAssignmentsProvider.h"
#import "PGMClssAssignmentSorting.h"
#import "PGMClssAssignmentActivity.h"

@interface PGMAssignmentsAllCoursesTableViewController ()

@property (nonatomic, strong) UIBarButtonItem *sortButton;
@property (nonatomic, strong) PGMClssAssignmentResponse *assignmentResponse;
@property (nonatomic, strong) NSArray *assignmentActivityAllCoursesSorted;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSString *cellLabel;
@property (nonatomic, strong) NSString *cellDetailLabel;
@property (nonatomic, strong) NSString *currentSortBy;


@end

static NSString * const SORT_BY_COURSE_LABEL = @"Sort by Course";
static NSString * const SORT_BY_DUE_DATE_LABEL = @"Sort by Due Date";

@implementation PGMAssignmentsAllCoursesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMM dd, YYYY HH:mm"];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.sortButton = [[UIBarButtonItem alloc] initWithTitle:SORT_BY_COURSE_LABEL
                                                              style:UIBarButtonItemStyleBordered
                                                             target:self
                                                             action:@selector(sortAssignments:)];
    
    NSArray *buttonItems = @[self.sortButton];
    self.navigationItem.rightBarButtonItems = buttonItems;
    
    PGMAssignmentsProvider *assignmentProvider = [[PGMAssignmentsProvider alloc] initWithEnvironmentType:PGMClssStaging];
    [self addAssignmentsAllCoursesObservers];
    [assignmentProvider getAssignmentsForSections:self.courseListItems];
    self.currentSortBy = SORT_BY_DUE_DATE_LABEL;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Assignment notification

- (void) addAssignmentsAllCoursesObservers {
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(assignmentsAllCoursesError:)
                                                 name: @"CourseAssignmentsError"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(assignmentsAllCoursesComplete:)
                                                 name: @"CourseAssignmentsComplete"
                                               object: nil];
}

- (void) assignmentsAllCoursesError:(NSNotification*)notification {
    
    [self removeAssignmentsAllCoursesObservers];
    self.assignmentResponse = (PGMClssAssignmentResponse*)notification.object;
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:self.assignmentResponse.error.description
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) assignmentsAllCoursesComplete:(NSNotification*)notification {
    
    [self removeAssignmentsAllCoursesObservers];
    self.assignmentResponse = (PGMClssAssignmentResponse*)notification.object;
    
    self.assignmentActivityAllCoursesSorted =
        [PGMClssAssignmentSorting sortAssignmentActivities:self.assignmentResponse.assignmentsArray
                                                        by:PGMClssDueDate
                                                 ascending:YES];
    
    [self.tableView reloadData];
}

- (void) removeAssignmentsAllCoursesObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"CourseAssignmentsError" object:nil];
    [center removeObserver:self name:@"CourseAssignmentsComplete" object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return (self.assignmentActivityAllCoursesSorted > 0) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.assignmentActivityAllCoursesSorted count];
}

- (void) sortAssignments: (id)sender
{
    if (self.sortButton.title == SORT_BY_COURSE_LABEL) {
        self.currentSortBy = SORT_BY_COURSE_LABEL;
        [self doSort];
    }
    else if (self.sortButton.title == SORT_BY_DUE_DATE_LABEL) {
        self.currentSortBy = SORT_BY_DUE_DATE_LABEL;
        [self doSort];
    }
    
    self.sortButton.title =
        (self.sortButton.title == SORT_BY_COURSE_LABEL) ? SORT_BY_DUE_DATE_LABEL : SORT_BY_COURSE_LABEL;
    
    [self.tableView reloadData];
}

- (void) doSort {
    
    if (self.currentSortBy == SORT_BY_COURSE_LABEL) {
        self.assignmentActivityAllCoursesSorted =
            [PGMClssAssignmentSorting sortAssignmentActivities:self.assignmentResponse.assignmentsArray
                                                            by:PGMClssCourseTitle
                                                     ascending:YES];
        
    } else if (self.currentSortBy == SORT_BY_DUE_DATE_LABEL) {
        self.assignmentActivityAllCoursesSorted =
            [PGMClssAssignmentSorting sortAssignmentActivities:self.assignmentResponse.assignmentsArray
                                                            by:PGMClssDueDate
                                                     ascending:YES];
    }
    
}

 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
     UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:@"assignmentActivityAllCoursesCell" forIndexPath:indexPath];
     
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"assignmentActivityAllCoursesCell"];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
     }
 
     PGMClssAssignmentActivity *assignmentActivity = [_assignmentActivityAllCoursesSorted objectAtIndex:indexPath.row];
     [self setTextLabelsForActivity:assignmentActivity];
     cell.textLabel.text = self.cellLabel;
     cell.textLabel.font = [UIFont  boldSystemFontOfSize:12];
     
     cell.detailTextLabel.text = self.cellDetailLabel;
     cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
 
     return cell;
 }

- (NSString*) formatDateAsString:(NSDate*)date {
    return [self.dateFormatter stringFromDate:date];
}

- (void) setTextLabelsForActivity:(PGMClssAssignmentActivity*)activity {
    if (self.currentSortBy == SORT_BY_DUE_DATE_LABEL) {
        self.cellLabel = [self formatDateAsString:activity.dueDate];
        self.cellDetailLabel = [NSString stringWithFormat:@"%@, %@", activity.sectionTitle, activity.title];
    } else if (self.currentSortBy == SORT_BY_COURSE_LABEL) {
        self.cellLabel = activity.sectionTitle;
        self.cellDetailLabel = [NSString stringWithFormat:@"%@, %@", activity.title, [self formatDateAsString:activity.dueDate]];
    }
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

//
//  PGMCourseDetailViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 8/17/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMCourseDetailViewController.h"
#import "PGMCourseStructureTableViewController.h"
#import "PGMCourseAssignmentsTableViewController.h"

@interface PGMCourseDetailViewController ()

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *sectionCode;
@property (weak, nonatomic) IBOutlet UILabel *sectionStartDate;
@property (weak, nonatomic) IBOutlet UILabel *sectionEndDate;
@property (weak, nonatomic) IBOutlet UILabel *courseType;
@property (weak, nonatomic) IBOutlet UIButton *viewCourseStructureButton;

@end

@implementation PGMCourseDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sectionTitleLabel.text = self.courseListItem.sectionTitle;
    self.sectionCode.text = [NSString stringWithFormat:@"Section code: %@", self.courseListItem.sectionCode];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    
    NSString *startDate = [dateFormatter stringFromDate:self.courseListItem.sectionStartDate];
    self.sectionStartDate.text = [NSString stringWithFormat:@"Start date: %@", startDate];
    
    NSString *endDate = [dateFormatter stringFromDate:self.courseListItem.sectionEndDate];
    self.sectionEndDate.text = [NSString stringWithFormat:@"End date: %@", endDate];
    
    self.courseType.text = [NSString stringWithFormat:@"Course type: %@", self.courseListItem.courseType];
    NSString *status;
    switch (self.courseListItem.itemStatus) {
        case pending:
            status = @"Pending";
            break;
        case active:
            status = @"Active";
            break;
        default:
            status = @"Unknown";
            break;
    }
    self.statusLabel.text = [NSString stringWithFormat:@"Status: %@", status];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)viewCourseStructureSelected:(id)sender
{
    
}

- (IBAction)showCourseAssignments:(id)sender {
    [UIView animateWithDuration:0.5
                     animations:nil
                     completion:^(BOOL finished){
                         [self performSegueWithIdentifier: @"CourseAssignmentsSegue" sender: self];
                     }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"CourseListToCourseStructureSegue"])
    {
        PGMCourseStructureTableViewController *vc = [segue destinationViewController];
        vc.sectionID = self.courseListItem.sectionId;
    }
    else if ([[segue identifier] isEqualToString:@"CourseAssignmentsSegue"])
    {
        PGMCourseAssignmentsTableViewController *courseAssignmentVC = [segue destinationViewController];
        courseAssignmentVC.courseListItem = self.courseListItem;
    }
}

@end

//
//  PGMCourseStructureDetailsTableViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 9/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <classroom-ios/PGMClssCourseStructureItem.h>
#import "PGMCourseStructureDetailsTableViewController.h"
#import "PGMAppDelegate.h"
#import "PGMCourseStructureProvider.h"

@interface PGMCourseStructureDetailsTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *courseStructureDetailsTableView;
@property (nonatomic, strong) NSMutableArray *courseStructureDetails;

@end

@implementation PGMCourseStructureDetailsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadCourseStructureDetails];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadCourseStructureDetails
{
    self.courseStructureDetails = [[NSMutableArray alloc] init];
    PGMAppDelegate *delegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    PGMCourseStructureProvider *provider = [[PGMCourseStructureProvider alloc] initWithCredentials:delegate.credentials];
    [provider courseStructureForItem:self.courseStructureItem forSection:self.sectionID onComplete:^(NSArray *details) {
        [self.courseStructureDetails addObjectsFromArray:details];
        [self.courseStructureDetailsTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.courseStructureDetails ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseStructureDetails ? self.courseStructureDetails.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailCell" forIndexPath:indexPath];
    PGMClssCourseStructureItem *item = [self.courseStructureDetails objectAtIndex:indexPath.row];
    cell.textLabel.text = item.title;
    cell.detailTextLabel.text = item.contentUrl;
    return cell;
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

@end

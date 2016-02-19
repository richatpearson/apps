//
//  PGMCourseStructureTableViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 8/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <classroom-ios/PGMClssCourseStructureItem.h>
#import "PGMCourseStructureTableViewController.h"
#import "PGMAppDelegate.h"
#import "PGMCourseStructureProvider.h"
#import "PGMChildCourseStructureTableViewController.h"

@interface PGMCourseStructureTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *courseStructureTableView;
@property (strong, nonatomic) NSMutableArray *courseStructureItems;

@end

@implementation PGMCourseStructureTableViewController

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
    [self loadCourseStructure];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.courseStructureTableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadCourseStructure
{
    self.courseStructureItems = [[NSMutableArray alloc] init];
    PGMAppDelegate *delegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    PGMCourseStructureProvider *provider = [[PGMCourseStructureProvider alloc] initWithCredentials:delegate.credentials];
    [provider courseStructureForSection:self.sectionID onComplete:^(NSArray *returnedCourseStructureItems) {
        [self.courseStructureItems addObjectsFromArray:returnedCourseStructureItems];
        [self.courseStructureTableView reloadData];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.courseStructureItems ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.courseStructureItems ? self.courseStructureItems.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CourseStructureCell" forIndexPath:indexPath];
    PGMClssCourseStructureItem *courseStructureItem = [self.courseStructureItems objectAtIndex:indexPath.row];
    cell.textLabel.text = courseStructureItem.title;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    if ([[segue identifier] isEqualToString:@"ChildCourseStructureSegue"])
    {
        PGMChildCourseStructureTableViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.courseStructureTableView indexPathForCell:cell];
        vc.sectionID = self.sectionID;
        vc.courseStructureItem = [self.courseStructureItems objectAtIndex:indexPath.row];
    }
}

@end

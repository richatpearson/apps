//
//  PGMChildCourseStructureTableViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 9/2/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMChildCourseStructureTableViewController.h"
#import <classroom-ios/PGMClssCourseStructureItem.h>
#import "PGMAppDelegate.h"
#import "PGMCourseStructureProvider.h"
#import "PGMCourseStructureDetailsTableViewController.h"

@interface PGMChildCourseStructureTableViewController ()

@property (strong, nonatomic) IBOutlet UITableView *courseStructureUITableView;
@property (strong, nonatomic) NSMutableArray *courseStructureItems;

@end

@implementation PGMChildCourseStructureTableViewController

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
    [self loadChildCourseStructure];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadChildCourseStructure
{
    self.courseStructureItems = [[NSMutableArray alloc] init];
    PGMAppDelegate *delegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
    PGMCourseStructureProvider *provider = [[PGMCourseStructureProvider alloc] initWithCredentials:delegate.credentials];
    [provider childCourseStructureForItem:self.courseStructureItem forSection:self.sectionID onComplete:^(NSArray *returnedCourseStructureItems) {
        [self.courseStructureItems addObjectsFromArray:returnedCourseStructureItems];
        [self.courseStructureUITableView reloadData];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UITableViewCell *cell = sender;
    if ([[segue identifier] isEqualToString:@"CourseStructureDetails"])
    {
        PGMCourseStructureDetailsTableViewController *vc = [segue destinationViewController];
        NSIndexPath *indexPath = [self.courseStructureUITableView indexPathForCell:cell];
        vc.sectionID = self.sectionID;
        vc.courseStructureItem = [self.courseStructureItems objectAtIndex:indexPath.row];
    }
}

@end

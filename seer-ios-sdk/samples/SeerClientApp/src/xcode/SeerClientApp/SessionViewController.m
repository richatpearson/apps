//
//  SessionViewController.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "SessionViewController.h"
#import "AssetByScreenHeight.h"
#import "AppDelegate.h"
#import "SessionRequest.h"
#import "SessionTableViewCell.h"
#import "JSONViewController.h"
#import "BlockingView.h"

@interface SessionViewController ()

@property (nonatomic, weak) SessionRequest* selectedRequest;
@property (nonatomic, strong) BlockingView* blockingView;

@end

@implementation SessionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.backgroundImageView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"Background")];
    
    //AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    //self.sessionArray = appDelegate.sessionHistory;
}

- (void) viewWillAppear:(BOOL)animated
{
    //NSLog(@"In session's viewWillAppear");
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.sessionArray = appDelegate.sessionHistory;
    
    self.itemsQueued.text = [[appDelegate itemsInQueue] stringValue];
    self.sizeOfQueue.text = [self formatFileSize:[appDelegate sizeOfQueue]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sessionUpdated) name:kSessionUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableAndQueueInfo) name:kSessionItemsUpdated object:nil];
}

- (void) viewWillDisappear:(BOOL)animated
{
    //NSLog(@"Session view disappearing...");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSessionUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSessionItemsUpdated object:nil];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectedRequest = [self.sessionArray objectAtIndex:[indexPath row]];
    
    [self performSegueWithIdentifier:@"SessionJSONSegue" sender:self];
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
           editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.sessionArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* CellIdentifer = @"SessionRequest";
    SessionTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifer];
    
    NSUInteger row = [indexPath row];
    
    SessionRequest* sessionRequest = [self.sessionArray objectAtIndex:row];
    
    cell.objectTypeLabel.text = [sessionRequest objectType];
    cell.verbLabel.text = [sessionRequest displayVerb];
    cell.requestTypeLabel.text = [sessionRequest getRequestTypeAbbreviation];
    cell.statusLabel.text = [[sessionRequest seerRequestStatusToString:sessionRequest.status] uppercaseString];
    cell.statusLabel.textColor = [self getTextColor:sessionRequest.status];
    NSLog(@"QUEUED: %@", sessionRequest.queued?@"QUEUED":@"NOT QUEUED");
    cell.queueLabel.text = sessionRequest.queued?@"QUEUED":@"";
    return cell;
}

- (UIColor*) getTextColor:(SeerRequestStatus)status
{
    UIColor* textColor = [UIColor new];
    
    switch (status)
    {
        case kRequestStatusPending:
            textColor = [UIColor colorWithRed:237.0f/255.0f green:211.0f/255.0f blue:18.0f/255.0f alpha:1.0f];
            break;
        case kRequestStatusError:
            textColor = [UIColor orangeColor];
            break;
        case kRequestStatusFailure:
            textColor = [UIColor redColor];
            break;
        case kRequestStatusSuccess:
            textColor = [UIColor greenColor];
            break;
        default:
            textColor = [UIColor blackColor];;
    }
    
    return textColor;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"SessionJSONSegue"])
    {
        JSONViewController *controller = (JSONViewController *)segue.destinationViewController;
        controller.json = self.selectedRequest.jsonDict;
    }
}

- (IBAction) clearSessionRequests
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    [appDelegate clearSession];
}

- (void)updateTableAndQueueInfo {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.sessionArray = appDelegate.sessionHistory;
    [self.tableView reloadData];
    
    self.itemsQueued.text = [[appDelegate itemsInQueue] stringValue];
    self.sizeOfQueue.text = [self formatFileSize:[appDelegate sizeOfQueue]];
}

- (void) sessionUpdated
{
    [self updateTableAndQueueInfo];
    
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
}

- (IBAction) postQueuedItems
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    self.blockingView = [[BlockingView alloc] initWithFrame:self.navigationController.view.bounds];
    [self.navigationController.view addSubview:self.blockingView];
    
    [appDelegate reportQueue];
}

- (NSString*) formatFileSize:(NSNumber*)fileSize
{
    NSLog(@"FormatFileSize incoming: %@", fileSize);
    NSString* formatedFileSize = @"";
    NSString* extension = @"";
    float fSize = [fileSize floatValue];
    float ff;
    if (fSize < 1024.0f)
    {
        formatedFileSize = [NSString stringWithFormat:@"%@", fileSize];
        extension = @"bytes";
    }
    else if (fSize < 1048576.0f)
    {
        ff = fSize / 1024.0f;
        formatedFileSize = [NSString stringWithFormat:@"%.2f", ff];
        extension = @"KB";
    }
    else
    {
        ff = fSize / 1048576.0f;
        formatedFileSize = [NSString stringWithFormat:@"%.2f", ff];
        extension = @"MB";
    }
    return [NSString stringWithFormat:@"%@ %@", formatedFileSize, extension];
}

@end

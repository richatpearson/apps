//
//  MainViewController
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "MainViewController.h"
#import "AppDelegate.h"
#import "DetailViewController.h"
#import "UserStatusViewController.h"
#import <PushNotifications/PearsonPushNotifications.h>
#import <PushNotifications/PearsonNotificationsValidator.h>

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationsUpdated:) name:kPN_NotificationsUpdate object:nil];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(appDelegate.notificationHistory.capacity > 0)
    {
        [appDelegate.notificationHistory restoreHistory];
    }
    
    // Style the Buttons
    self.clearAllButton = [appDelegate styleButton:self.clearAllButton];
    self.regUnregButton = [appDelegate styleButton:self.regUnregButton];
    
    [self setUI];
}

- (void) setUI
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.navigationItem.title = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    [self.activityIndicator setHidden:YES];
    
    [self.userUUIDLabel setBackgroundColor:[UIColor clearColor]];
    self.userUUIDLabel.text = [appDelegate.pushNotifications currentUserUUID];
    
    [self.deviceUUIDLabel setBackgroundColor:[UIColor clearColor]];
    self.deviceUUIDLabel.text = [appDelegate.pushNotifications currentDeviceUUID];
    
    self.currentUserLabel.text = [appDelegate currentUserId];
    
    [self setRegUnregLabels];
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSUInteger nCount = [[appDelegate.notificationHistory getStoredNotificationsForUserId:[appDelegate currentUserId]] count];
    
    self.notificationCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)nCount];
    return nCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.tag = 100 + indexPath.row;
    
    // Configure the cell
    NSArray* myNotifications = [appDelegate.notificationHistory getStoredNotificationsForUserId:[appDelegate currentUserId]];
    PearsonNotification* notification = [myNotifications objectAtIndex:[indexPath row]];
    
    // Text - Notification Message
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
    if(notification.alert)
    {
        if( notification.alert && ([notification.alert length] > 0) )
        {
            cell.textLabel.text = (NSString*)notification.alert;
        }
        else
        {
            cell.textLabel.text = @"NULL";
        }
    }
    else if(notification.alertDict)
    {
        id key = [[notification.alertDict allKeys] objectAtIndex:0]; // Assumes 'alertDict' is not empty
        id object = [notification.alertDict objectForKey:key];
        NSString* objectStr =  [[object description] stringByReplacingOccurrencesOfString:@"\n" withString:@" "];
        cell.textLabel.text = [NSString stringWithFormat:@"{%@:%@...}", (NSString*)key, objectStr];
    }
    else
    {
        cell.textLabel.text = @"NULL";
    }
    
    // Subtitle - Notification Timestamp
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMMM dd, yyyy HH:mm:ss"];
    
    NSString *timeStamp = [formatter stringFromDate:notification.timestamp];
    
    cell.detailTextLabel.text = timeStamp;
    
    // Image - Application State when notification was received
    UIImage *cellImage = nil;
    
    switch (notification.applicationState)
    {
        case UIApplicationStateActive:
            cellImage = [UIImage imageNamed:@"ApplicationActive.png"];
            break;
        case UIApplicationStateInactive:
            cellImage = [UIImage imageNamed:@"ApplicationInactive.png"];
            break;
        case UIApplicationStateBackground:
            cellImage = [UIImage imageNamed:@"ApplicationBackground.png"];
            break;
        default:
            cellImage = [UIImage imageNamed:@"ApplicationUnknown.png"];
            break;
    }
    cell.imageView.image = cellImage;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([identifier isEqualToString:@"ShowNotificationDetail"])
    {
       return YES;
    }

    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"ShowNotificationDetail"])
    {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        NSString* userId = [appDelegate currentUserId];
        
        PearsonNotification* notification = [[appDelegate.notificationHistory getStoredNotificationsForUserId:userId] objectAtIndex:[indexPath row]];

        [[segue destinationViewController] setNotificationForDetail:notification];
    }
    if ([[segue identifier] isEqualToString:@"ChooseUser"])
    {
        [[segue destinationViewController] setSegueSender:self];
    }
}

- (void)notificationsUpdated:(id)response
{
    NSLog(@"MainViewController notificationsUpdated");
    [self.tableView reloadData];
}

- (IBAction)clearAll:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSString* userId = [appDelegate currentUserId];
    [appDelegate.notificationHistory clearStoredNotificationsForUserId:userId];
}

/******************** Disconnect - Reconnect ********************/

- (void) unregisteredWithAppServices:(NSNotification *) nsNotification
{
    NSLog(@"unregisteredWithAppServices");
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPN_UnregisteredWithAppServices object:nil];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    NSLog(@"MainViewController unregisteredWithAppServices");
    
    [self setRegUnregLabels];
}

- (void) reregisteredWithAppServices:(NSNotification *) nsNotification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPN_ReregisteredWithAppServices object:nil];
    
    [self.activityIndicator setHidden:YES];
    [self.activityIndicator stopAnimating];
    
    NSLog(@"MainViewController reregisteredWithAppServices");
    
    [self setRegUnregLabels];
}

- (void) userDeviceReconnectionResponse:(NSNotification *) nsNotification
{
    PearsonClientResponse* response = (PearsonClientResponse*)nsNotification.object;
    if(!response.completedSuccessfully)
    {
        NSString* alertMsg = [NSString stringWithFormat:@"%@ - %@", response.errorCode, response.errorDescription];
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate alert:alertMsg title:@"User Device Reconnection Error"];
    }
    
    [self setRegUnregLabels];
}

- (void) userDeviceConnectionResponse:(NSNotification *) nsNotification
{
    PearsonClientResponse* response = (PearsonClientResponse*)nsNotification.object;
    if(!response.completedSuccessfully)
    {
        NSString* alertMsg = @"";
        if(response.errorCode)
        {
            alertMsg = [NSString stringWithFormat:@"%@ - %@", response.errorCode, response.errorDescription];
        }
        else
        {
            alertMsg = [NSString stringWithFormat:@"403 - Failed to conect user to device"];
        }
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate alert:alertMsg title:@"User Device Connection Error"];
    }
    
    [self setRegUnregLabels];
}

- (IBAction)regUnreg:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [self.activityIndicator setHidden:NO];
    [self.activityIndicator startAnimating];
    
    if([appDelegate.pushNotifications userIsConnectedToDevice])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(unregisteredWithAppServices:) name:kPN_UnregisteredWithAppServices object:nil];
        NSString* userToUnregister = [appDelegate currentUserId];
        NSLog(@"userToUnregister: %@", userToUnregister);
        if([userToUnregister isEqualToString:@""])
        {
            // Go Back To Login Screen
            NSLog(@"userToUnregister is blank");
        }
        else
        {
            NSString* authToken = [appDelegate currentAuthToken];
            NSLog(@"authToken: %@", authToken);
            [appDelegate.pushNotifications unregisterWithAppServicesUsingAuthorizationToken:authToken
                                                                                     userId:userToUnregister];
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reregisteredWithAppServices:) name:kPN_ReregisteredWithAppServices object:nil];
        NSString* userToRegister = [appDelegate currentUserId];
        NSLog(@"userToRegister: %@", userToRegister);
        if([userToRegister isEqualToString:@""])
        {
            // Go Back To Login Screen
            
        }
        else
        {
            NSString* authToken = [appDelegate currentAuthToken];
            NSLog(@"authToken: %@", authToken);
            [appDelegate.pushNotifications reregisterWithAppServicesUsingAuthorizationToken:authToken
                                                                                     userId:userToRegister];
        }
    }
    self.regUnregButton.enabled = NO;
}

- (void)setRegUnregLabels
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSLog(@"MainViewConroller: setRegUnregLabels: %@", [appDelegate.pushNotifications userIsConnectedToDevice]?@"YES":@"NO");
    if([appDelegate.pushNotifications userIsConnectedToDevice])
    {
        [self.regUnregButton setTitle:@"Unregister" forState:UIControlStateNormal];
        self.currentUserLabel.text = [appDelegate currentUserId];
        self.userUUIDLabel.text = [appDelegate.pushNotifications currentUserUUID];
    }
    else
    {
        [self.regUnregButton setTitle:@"Register" forState:UIControlStateNormal];
        self.currentUserLabel.text = @"None";
        self.userUUIDLabel.text = @"";
    }
    
    self.regUnregButton.enabled = YES;
    [self.tableView reloadData];
}

- (IBAction) userStatus:(id)sender
{
    [self performSegueWithIdentifier:@"UserStatus" sender:self];
}

@end

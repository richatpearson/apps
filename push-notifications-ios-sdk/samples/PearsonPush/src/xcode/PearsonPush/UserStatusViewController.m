//
//  UserStatusViewController.m
//  PearsonPush
//
//  Created by Tomack, Barry on 10/1/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "UserStatusViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@implementation UserStatusViewController

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
    
    PearsonPushNotificationType* pushType = [PearsonPushNotificationType new];
    
    if ([pushType areNotificationTypesSet])
    {
        self.notificationStatus.text    = @"ON";
        self.badgeStatus.text           = pushType.badge?@"YES":@"NO";
        self.soundStatus.text           = pushType.sound?@"YES":@"NO";
        self.alertStatus.text           = pushType.alert?@"YES":@"NO";
        self.newsstandStatus.text       = pushType.newsstand?@"YES":@"NO";
    }
    else
    {
        NSLog(@"Notifications are set to off");
        self.notificationStatus.text    = @"OFF";
        self.badgeStatus.text           = @"NO";
        self.soundStatus.text           = @"NO";
        self.alertStatus.text           = @"NO";
        self.newsstandStatus.text       = @"NO";
    }
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.notificationBaseURL.text = appDelegate.notificationBaseURL;
    [self.notificationBaseURL sizeToFit];
}

- (IBAction) logout:(id)sender
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate logout];
}

//- (void) registerCurrentUser
//{
//    [self.activityIndicator setHidden:NO];
//    [self.activityIndicator startAnimating];
//    
//    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationResponse:) name:kPN_RegisteredWithAppServices object:nil];
//    
//    NSString* userToRegister = [appDelegate currentUserId];
//    NSString* authToken = [appDelegate currentAuthToken];
//    NSLog(@"userToRegister: %@ ::: authToken: %@", userToRegister, authToken);
//    [appDelegate.pushNotifications registerWithAppServicesUsingAuthorizationToken:authToken
//                                                                           userId:userToRegister];
//    NSLog(@"RegisteredUser: %@", userToRegister);
//}
//
//- (void) registrationResponse:(NSNotification*)notification
//{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPN_RegisteredWithAppServices object:nil];
//    if([self.sender respondsToSelector:@selector(setUI)])
//    {
//        [self.sender setUI];
//    }
//    [self.activityIndicator removeFromSuperview];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}
//
- (void) setSegueSender:(id)sender
{
    self.sender = sender;
}

@end

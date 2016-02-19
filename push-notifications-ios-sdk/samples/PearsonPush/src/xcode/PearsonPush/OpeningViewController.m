//
//  OpeningViewController.m
//  PearsonPush
//
//  Created by Tomack, Barry on 8/15/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import "AppDelegate.h"
#import "OpeningViewController.h"
#import <PushNotifications/PearsonPushNotifications.h>

@interface OpeningViewController ()

@end

@implementation OpeningViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    NSLog(@"OpenigViewcontroller nibNameOrNil: %@....nibBundleOrNil: %@", nibNameOrNil, nibBundleOrNil);
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
    }
    return self;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    self.bundleNameLabel.text = bundleName;
    
	self.logoImageView.alpha = 1.0f;
    
    PearsonPushNotificationType* pushType = [PearsonPushNotificationType new];
    
    if (! [pushType areNotificationTypesSet])
    {
        [self openingAnimation];
        [appDelegate alert:@"This device is disabled from receiving Push Notifications." title:@"Alert"];
    }
}

- (IBAction) submitLogin:(id)sender
{
    [self.userNameField resignFirstResponder];
    [self.passWordField resignFirstResponder];
    
    if([self loginFormComplete])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(registrationComplete:) name:kPN_RegisteredWithAppServices object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:RUMBA_AUTHENTICATION_FAILURE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:SMS_AUTHENTICATION_FAILURE object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginFailed) name:PI_AUTHENTICATION_FAILURE object:nil];
        [self blockTouchActivity];
        [self registerUser];
    }
    else
    {
        [self displayWarningForIncompleteForm];
    }
}

- (BOOL) loginFormComplete
{
    BOOL completed = YES;
    
    if ([self.userNameField.text isEqualToString:@""] || [self.passWordField.text isEqualToString:@""])
    {
        completed = NO;
    }
    
    return completed;
}

- (void) blockTouchActivity
{
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    
    self.blockingView = [[UIView alloc] initWithFrame:screenFrame];
    [self.view addSubview:self.blockingView];
    
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.alpha = 1.0;
    self.activityIndicator.center = CGPointMake(screenFrame.size.width/2, (screenFrame.size.height/2 + 25));
    self.activityIndicator.hidesWhenStopped = NO;
    self.activityIndicator.color = [UIColor colorWithRed:42.0/255.0 green:23.0/255.0 blue:11.0/255.0 alpha:1.0];
    
    [self.view addSubview:self.activityIndicator];
    [self.activityIndicator startAnimating];
}

- (void) displayWarningForIncompleteForm
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate alert:@"Please enter both a username and password" title:@"Login Failed"];
}

-(void) registerUser
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate loginWithUsername:self.userNameField.text
                          password:self.passWordField.text
                      authProvider:self.authProvider.selectedSegmentIndex];
}

- (void)registrationComplete:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPN_RegisteredWithAppServices object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUMBA_AUTHENTICATION_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SMS_AUTHENTICATION_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PI_AUTHENTICATION_FAILURE object:nil];
//    NSLog(@"OpeningViewConroller: registrationComplete");
    [self openingAnimation];
}

- (void)openingAnimation
{
    [UIView animateWithDuration:0.5
                     animations:^{
                         self.logoImageView.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [self.activityIndicator removeFromSuperview];
                         [self.blockingView removeFromSuperview];
                         [self performSegueWithIdentifier: @"OpeningAnimation" sender: self];
                     }];
}

- (void)loginFailed
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kPN_RegisteredWithAppServices object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RUMBA_AUTHENTICATION_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SMS_AUTHENTICATION_FAILURE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PI_AUTHENTICATION_FAILURE object:nil];
    
    [self.activityIndicator removeFromSuperview];
    [self.blockingView removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction) setUsernameAndPassword:(id)sender
{
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    if (self.authProvider.selectedSegmentIndex == 0)
    {
        // Pi
        if ([bundleName isEqualToString:@"MobileApp1"] ||
            [bundleName isEqualToString:@"MobileApp2"] ||
            [bundleName isEqualToString:@"MobileApp3"] ||
            [bundleName isEqualToString:@"MobileApp4"])
        {
            self.userNameField.text = @"group12user";
            self.passWordField.text = @"P@ssword1";
        }
    }
    else if (self.authProvider.selectedSegmentIndex == 1)
    {
        // Rumba
        self.userNameField.text = @"certservice1";
        self.passWordField.text = @"password1";
    }
    else if (self.authProvider.selectedSegmentIndex == 2)
    {
        // SMS
        self.userNameField.text = @"cert_ins_002";
        self.passWordField.text = @"password1";
    }
}

@end

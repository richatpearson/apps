//
//  PGMLoginViewController.m
//  CourseListClient
//
//  Created by Joe Miller on 8/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMLoginViewController.h"
#import "PGMAppDelegate.h"
#import <Pi-ios-client/PGMPiConsentPolicy.h>

@interface PGMLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;

@end

@implementation PGMLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [self addObservers];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self removeObservers];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [self removeObservers];
}

- (void)addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(loginComplete:)
                                                 name: @"LoginComplete"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(loginFailed:)
                                                 name: @"LoginError"
                                               object: nil];
}

- (void)removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver: @"LoginComplete"];
    [[NSNotificationCenter defaultCenter] removeObserver: @"LoginError"];
}

- (IBAction)submitLogin:(id)sender
{
    if ([self loginFormComplete])
    {
        PGMAppDelegate *appDelegate = (PGMAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate loginWithUsername:self.usernameField.text password:self.passwordField.text];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Incomplete Login"
                                                            message: @"Please enter a username and password"
                                                           delegate: self
                                                  cancelButtonTitle: @"OK"
                                                  otherButtonTitles: nil];
        [alertView show];
    }
}

- (BOOL) loginFormComplete
{
    if ([self.usernameField.text isEqualToString:@""] || [self.passwordField.text isEqualToString:@""])
    {
        return NO;
    }
    return YES;
}

- (void)loginComplete:(NSNotification*)notification
{
    [self segueToClassList];
}

- (void)loginFailed:(NSNotification*)notification
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle: @"Login Failed"
                                                        message: @"Incorrect username and/or password entered"
                                                       delegate: self
                                              cancelButtonTitle: @"OK"
                                              otherButtonTitles: nil];
    [alertView show];
}

- (void)segueToClassList
{
    [UIView animateWithDuration:0.5
                     animations:nil
                     completion:^(BOOL finished){
                         [self performSegueWithIdentifier: @"CourseListSegue" sender: self];
                     }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

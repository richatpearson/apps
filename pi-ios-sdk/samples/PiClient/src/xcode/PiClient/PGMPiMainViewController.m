//
//  PGMPiMainViewController.m
//  PiClient
//
//  Created by Tomack, Barry on 6/12/14.
//  Copyright (c) 2014 Tomack, Barry. All rights reserved.
//

#import "PGMPiMainViewController.h"
#import "PGMPiAppDelegate.h"

@interface PGMPiMainViewController ()

@end

@implementation PGMPiMainViewController

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
    self.blockingView = [[BlockingView alloc] initWithFrame:self.navigationController.view.bounds];
}

- (void) viewDidAppear:(BOOL)animated
{
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil]
     setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor grayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [self.navigationController.navigationBar setTintColor:[UIColor grayColor]];
    
    [super viewDidAppear:animated];
}

- (IBAction)checkToken :(id)sender
{
    // Check if there is a token
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PGMPiResponse *response = [appDelegate checkToken];
    
    [self addObservers];
    
    if(response.requestStatus == PiRequestSuccess)
    {
        [self showAuthenticationResults];
    }
    else
    {
        if(response.requestStatus == PiRequestPending)
        {
            [self.navigationController.view addSubview:self.blockingView];
        }
    }
}

- (void) addObservers
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(validPiToken:)
                                                 name: @"ValidPiToken"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(invalidPiToken:)
                                                 name: @"InvalidPiToken"
                                               object: nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ValidPiToken" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InvalidPiToken" object:nil];
}

- (void) validPiToken:(NSNotification *)notification
{
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    [self showAuthenticationResults];
}

- (void) invalidPiToken:(NSNotification *)notification
{
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    [self showLoginView];
}


- (void) showAuthenticationResults
{
    [self removeObservers];
    [self performSegueWithIdentifier:@"goToResults" sender:self];
}

- (void) showLoginView
{
    [self removeObservers];
    [self performSegueWithIdentifier:@"goToLogin" sender:self];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

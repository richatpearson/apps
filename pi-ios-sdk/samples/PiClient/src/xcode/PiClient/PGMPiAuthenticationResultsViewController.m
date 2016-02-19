//
//  PGMPiAuthenticationResultsViewController.m
//  PiClient
//
//  Created by Richard Rosiak on 6/9/14.
//  Copyright (c) 2014 Richard Rosiak. All rights reserved.
//

#import "PGMPiAuthenticationResultsViewController.h"
#import "PGMPiAppDelegate.h"

@interface PGMPiAuthenticationResultsViewController ()

@end

@implementation PGMPiAuthenticationResultsViewController

- (IBAction)dismiss:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

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
    // Do any additional setup after loading the view.
    NSLog(@"AuthenticationResults viewDidLoad");
    [self fillInLabels];
    self.blockingView = [[BlockingView alloc] initWithFrame:self.navigationController.view.bounds];
}

- (void) fillInLabels
{
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    self.piUserIdLabel.text = appDelegate.piCredentials.userId;
    self.accessTokenLabel.text = appDelegate.piToken.accessToken;
    self.refreshTokenLabel.text = appDelegate.piToken.refreshToken;
    self.expiresInLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)appDelegate.piToken.expiresIn];
    self.creationIntervalLabel.text = [NSString stringWithFormat:@"%f", (double)appDelegate.piToken.creationDateInterval];
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

- (IBAction)tokenRefresh:(id)sender
{
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addObservers];
    [self.navigationController.view addSubview:self.blockingView];
    [appDelegate tokenRefresh];
}

- (void) addObservers
{
    NSLog(@"PGMPiAuthenticationResultsViewController adding pbservers");
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(tokenRefreshed:)
                                                 name: @"TokenRefreshed"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(tokenRefreshError:)
                                                 name: @"TokenRefreshError"
                                               object: nil];
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TokenRefreshed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TokenRefreshError" object:nil];
}

- (void) tokenRefreshed:(NSNotification*)notification
{
    NSLog(@"PGMPiAuthenticationResultsViewController tokenRefreshed");
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    PGMPiResponse* response = (PGMPiResponse*)notification.object;
    
    appDelegate.piToken = (PGMPiToken*)[response getObjectForOperationType:PiTokenRefreshOp];
    NSLog(@"PGMPiAuthenticationResultsViewController piToken: %@", appDelegate.piToken);
    
    [self removeObservers];
    [self fillInLabels];
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
}

- (void) tokenRefreshError:(NSNotification*)notification
{
    [self removeObservers];
    if (self.blockingView)
    {
        [self.blockingView removeFromSuperview];
    }
    //TODO: Display Error
}

- (IBAction)logout:(id)sender
{
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate logout];
    
    self.piUserIdLabel.text = @"";
    self.accessTokenLabel.text = @"";
    self.refreshTokenLabel.text = @"";
    self.expiresInLabel.text = @"";
    self.creationIntervalLabel.text = @"";
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end

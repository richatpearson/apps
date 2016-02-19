//
//  PGMViewController.m
//  PiClient
//
//  Created by Richard Rosiak on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "PGMPiLoginViewController.h"
#import "PGMPiAppDelegate.h"
#import <Pi-ios-client/PGMPiCredentials.h>
#import <Pi-ios-client/PGMPiConsentPolicy.h>
#import "PGMPiConsentViewController.h"

@interface PGMPiLoginViewController ()

@property (nonatomic, strong) PGMPiClientLoginOptions *loginOptions;
@property (nonatomic, strong) PGMPiConsentViewController *consentViewController;

@end

#define kMoveForKeyboard 52.0

@implementation PGMPiLoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.usernameField.delegate = self;
    self.passwordField.delegate = self;
    
    self.blockingView = [[BlockingView alloc] initWithFrame:self.navigationController.view.bounds];
    
    self.resourceView.hidden = YES;
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.loginOptions = [appDelegate getLoginOptions];
    appDelegate.loginView = self;
    
    [self setResourceSwitches];
}

- (void) setResourceSwitches
{
    if (self.loginOptions.requestAffiliation)
        [self.affiliationSwitch setOn:YES];
    if (self.loginOptions.requestIdentity)
        [self.identitySwitch setOn:YES];
    if (self.loginOptions.requestUserComposite)
        [self.userCompositeSwitch setOn:YES];
}

#pragma textfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.usernameField || textField == self.passwordField) {
        return;
    }
    
    CGRect rect = self.view.frame;
    if (rect.origin.y <= -kMoveForKeyboard) {
        return;
    }
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    rect.origin.y = -kMoveForKeyboard; //movedUp
    self.view.frame = rect;
    [UIView commitAnimations];
    
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == self.usernameField || textField == self.passwordField) {
        return;
    }
    
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    rect.origin.y = 0; //moveddwn
    self.view.frame = rect;
    [UIView commitAnimations];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma end of textfield delegate methods


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addLoginObservers
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piLoginComplete:)
                                                 name: @"LoginComplete"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piLoginFailedWithBadCredentials:)
                                                 name: @"LoginErrorBadCredentials"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piLoginFailedWithNoConsent:)
                                                 name: @"LoginErrorNoConsent"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piLoginFailedWithError:)
                                                 name: @"LoginError"
                                               object: nil];
}

- (void) addForgotPasswordObserver
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piForgotPasswordComplete:)
                                                 name: @"ForgotPasswordComplete"
                                               object: nil];
}

- (void) addForgotUsernameObserver
{
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piForgotUsernameComplete:)
                                                 name: @"ForgotUsernameComplete"
                                               object: nil];
}

- (IBAction)loginButton:(id)sender {
    
    [self.view endEditing:YES];
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![self.usernameField.text isEqualToString:@""] && ![self.passwordField.text isEqualToString:@""]) {
        
        [self.navigationController.view addSubview:self.blockingView];
        
        [self addLoginObservers];
        
        [appDelegate loginWithUsername:self.usernameField.text
                              password:self.passwordField.text
                               options:self.loginOptions
                      storeCredentials:self.storeCredentialsSwitch.on];
    }
    else
    {
        [self showAlertwithMessage:@"Both username and password must be provided."];
    }
}

- (void) showAlertwithMessage:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (void) piLoginComplete:(NSNotification*)notification
{
    [self removeLoginObservers];
    
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PGMPiResponse* response = (PGMPiResponse*)notification.object;
    
    NSLog(@"PiClientApp piLoginComplete: %@ ::: Credentials: %@", [response getObjectForOperationType:PiTokenOp],
          [response getObjectForOperationType:PiUserIdOp]);
    
    appDelegate.piCredentials = [response getObjectForOperationType:PiUserIdOp];
    appDelegate.piToken = (PGMPiToken*)[response getObjectForOperationType:PiTokenOp];
    
    [self resetFields];
    
    [self performSegueWithIdentifier:@"showResults" sender:self];
}

- (void) piLoginFailedWithBadCredentials:(NSNotification*)notification
{
    [self removeLoginObservers];
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    [self showAlertwithMessage:@"Please check your username and password."];
}

- (void) piLoginFailedWithNoConsent:(NSNotification*)notification
{
    [self removeLoginObservers];
    
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    
    [self showAlertwithMessage:@"User is missing consent. Please submit consent forms."];
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PGMPiResponse* response = (PGMPiResponse*)notification.object;
    
    appDelegate.consentPolicies = (NSArray*)[response getObjectForOperationType:PiTokenOp];
    NSLog(@"Consent Policies: %@", appDelegate.consentPolicies);
    
    [self performSegueWithIdentifier:@"PolicyConsentSegue" sender:self];
}

- (void) piLoginFailedWithError:(NSNotification*)notification
{
    [self removeLoginObservers];
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    
    PGMPiResponse* response = (PGMPiResponse*)notification.object;
    
    if (response.error.code == 8) {
        [self showAlertwithMessage:@"User has refused to consent"];
    } else {
        [self showAlertwithMessage:@"Unable to log in."];
    }
}

- (void) removeLoginObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"LoginComplete" object:nil];
    [center removeObserver:self name:@"LoginErrorBadCredentials" object:nil];
    [center removeObserver:self name:@"LoginError" object:nil];
    [center removeObserver:self name:@"LoginErrorNoConsent" object:nil];
}

- (void) removeConsentObservers {
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"ConsentFlowCompleted" object:nil];
    [center removeObserver:self name:@"UnconsentedPolicyError" object:nil];
    [center removeObserver:self name:@"ConsentFlowError" object:nil];
}

- (void) removeForgotPasswordObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"ForgotPasswordComplete" object:nil];
}

- (void) removeForgotUsernameObserver
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center removeObserver:self name:@"ForgotUsernameComplete" object:nil];
}

- (void) addConsentFlowObservers {
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piConsentComplete:)
                                                 name: @"ConsentFlowCompleted"
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piConsentFailedWithUnconsentedPolicy:)
                                                 name: @"UnconsentedPolicyError"
                                               object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(piConsentFailed:)
                                                 name: @"ConsentFlowError"
                                               object: nil];
}

- (void) submitConsentAfterAcceptance {
    
    [self addConsentFlowObservers];
    [self addLoginObservers];
    [self.navigationController.view addSubview:self.blockingView];
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appDelegate submitConsentPolicies:appDelegate.consentPolicies];
}

- (void) piConsentComplete:(NSNotification*)notification {
    
    [self removeConsentObservers];
}

- (void) piConsentFailedWithUnconsentedPolicy:(NSNotification*)notification {
    
    [self removeConsentObservers];
    [self removeLoginObservers];
    
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    [self showAlertwithMessage:@"User must consent to all policies."];
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    appDelegate.consentPolicies = [self setUnconsentedPoliciesForReivew:appDelegate.consentPolicies];
    [self performSegueWithIdentifier:@"PolicyConsentSegue" sender:self];
}

- (void) piConsentFailed:(NSNotification*)notification {
    
    [self removeConsentObservers];
    [self removeLoginObservers];
    
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    [self showAlertwithMessage:@"Error posting consents to Pi."];
}

- (NSArray*) setUnconsentedPoliciesForReivew:(NSArray*)policies {
    for (PGMPiConsentPolicy *currentPolicy in policies) {
        if (!currentPolicy.isConsented) {
            currentPolicy.isReviewed = NO;
        }
    }
    return policies;
}

- (IBAction)setText:(id)sender
{
    NSString* bundleName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    
    if ([bundleName isEqualToString:@"PiClientStaging"])
    {
        self.usernameField.text = @"group12iosuser";
        self.passwordField.text = @"P@ssword1";
    }
    else if ([bundleName isEqualToString:@"PiClientProduction"])
    {
        self.usernameField.text = @"group12user";
        self.passwordField.text = @"P@ssword1";
    }
}

- (void)resetFields
{
    self.usernameField.text = @"";
    self.passwordField.text = @"";
}

- (IBAction)retrieveCredentials:(id)sender
{
    self.usernameField.text = @"";
    self.passwordField.text = @"";
    
    PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    PGMPiCredentials *piCredentials = [appDelegate retrieveCredentials];
    
    if (piCredentials)
    {
        self.usernameField.text = piCredentials.username;
        self.passwordField.text = piCredentials.password;
    }
}

- (IBAction)chooseAdditonalResources:(id)sender
{
    [self setResourceSwitches];
    self.resourceView.hidden = NO;
}

- (IBAction)addAdditionalResourceRequests:(id)sender
{
    [self setPiLoginOptions];
    self.resourceView.hidden = YES;
}

- (void) setPiLoginOptions
{
    self.loginOptions.requestAffiliation = self.affiliationSwitch.isOn;
    self.loginOptions.requestIdentity = self.identitySwitch.isOn;
    self.loginOptions.requestUserComposite = self.userCompositeSwitch.isOn;
    
    NSLog(@"Login Options: %@", self.loginOptions);
}

- (IBAction)forgotPassword:(id)sender
{
    if(self.usernameField.text && ![self.usernameField.text isEqualToString:@""])
    {
        [self.usernameField resignFirstResponder];
        [self.passwordField resignFirstResponder];
        
        [self.navigationController.view addSubview:self.blockingView];
        [self addForgotPasswordObserver];
        
        PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate forgotPasswordForUsername:self.usernameField.text];
        
    } else {
        NSLog(@"PGMPiLoginViewCOntroller forgotPAssword ERROR: NO USERNAME");
        [self showAlertwithMessage:@"Please enter a username so your account can be looked up."];
    }
}

- (void) piForgotPasswordComplete:(NSNotification*)notification
{
    [self removeForgotPasswordObserver];
    if (self.blockingView)
    {
        [self.blockingView removeFromSuperview];
    }
    
    PGMPiResponse *response = (PGMPiResponse *)notification.object;
    
    if(response.requestStatus == PiRequestFailure)
    {
        NSDictionary *responseDict = [response getObjectForOperationType:PiForgotPassword];
        if([[responseDict objectForKey:@"status"] isEqualToString:@"error"])
        {
            // Example Error Response:
            // {"status":"error","message":"Too many tickets for resource ForgotPassword and ownder ffffffff53f82770e4b0ed5d911a3304","code":"404-NOT_FOUND"}
            [self showAlertwithMessage:[responseDict objectForKey:@"message"]];
        }
        else
        {
            NSLog(@"An unknown error occurred: %@", [responseDict objectForKey:@"fault"]);
            [self showAlertwithMessage:@"An unknown error occurred."];
        }
    }
    else
    {
        NSLog(@"Got HTML: %@", [response getObjectForOperationType:PiForgotPassword]);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Password Request"
                                                        message:@"You have been sent an email to reset your password."
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)forgotUsername:(id)sender
{
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Forgot Username?"
                                                      message:@"Enter email"
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Submit", nil];
    
    [message setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *buttonTitle = [alertView buttonTitleAtIndex:buttonIndex];
    NSLog(@"AlertViewTitle: %@", alertView.title);
    if (alertView.title)
    {
        if([buttonTitle isEqualToString:@"Submit"])
        {
            NSLog(@"Email: %@", [alertView textFieldAtIndex:0].text);
            NSString *email = [alertView textFieldAtIndex:0].text;
            if ([self validEmail:email])
            {
                [self.navigationController.view addSubview:self.blockingView];
                [self addForgotUsernameObserver];

                PGMPiAppDelegate* appDelegate = (PGMPiAppDelegate *)[[UIApplication sharedApplication] delegate];
                [appDelegate forgotUsernameForEmail:email];
            }
            else
            {
                [self showAlertwithMessage:@"Invalid Email Address."];
            }
        }
    }
    
}

- (BOOL) validEmail:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

- (void) piForgotUsernameComplete:(NSNotification*)notification
{
    [self removeForgotUsernameObserver];
    if (self.blockingView)
    {
        [self.blockingView removeFromSuperview];
    }
    
    PGMPiResponse *response = (PGMPiResponse *)notification.object;
    NSLog(@"piForgotUsernameComplete response: %@", response);
    if(response.requestStatus == PiRequestFailure)
    {
        NSDictionary *responseDict = [response getObjectForOperationType:PiForgotPassword];
        if([[responseDict objectForKey:@"status"] isEqualToString:@"error"])
        {
            [self showAlertwithMessage:[responseDict objectForKey:@"message"]];
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Username Request"
                                                        message:@"Username has been sent to primary email"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

@end

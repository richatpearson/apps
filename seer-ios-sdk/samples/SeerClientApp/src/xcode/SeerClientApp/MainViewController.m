//
//  MainViewController.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "MainViewController.h"
#import "AssetByScreenHeight.h"
#import "AppDelegate.h"
#import "BlockingView.h"

@interface MainViewController ()

@end

#define kMoveForKeyboard        52.0
#define CHACTERS @"0123456789"

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"Background")];
    
    self.actorNameField.delegate = self;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if (appDelegate.actorName)
    {
        self.actorNameField.text = appDelegate.actorName;
    }
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(startSeerSession)
                                                 name: kSEER_RequestStartSession
                                               object: nil];
    
    self.blockingView = [[BlockingView alloc] initWithFrame:self.navigationController.view.bounds];
    [self.navigationController.view addSubview:self.blockingView];
    
    [appDelegate startClient];
}

- (BOOL) shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    appDelegate.actorName = self.actorNameField.text;
    
    return YES;
}

#pragma textfield delegate methods

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.actorNameField) {
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
    if (textField == self.actorNameField) {
        return;
    }
    
    NSString *enterdSize = textField.text;
    if (enterdSize && [[enterdSize stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] > 0) {
        AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        
        ValidationResult *validation = [appDelegate userSetBatchSize:[textField.text integerValue]];
        
        UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:validation.title message:validation.detail delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];

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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.actorNameField) {
        return YES;
    }
    
    NSCharacterSet *cs;
    NSString *filtered;
    cs = [[NSCharacterSet characterSetWithCharactersInString:CHACTERS] invertedSet];
    filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    return [string isEqualToString:filtered];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.actorNameField resignFirstResponder];
    [self.batchSizeField resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) startSeerSession
{
    NSLog(@"START SEER SESSSION");
    if (self.blockingView) {
        [self.blockingView removeFromSuperview];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kSEER_RequestStartSession object:nil];
}

- (IBAction)autoReportSwitch:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.autoReportSwitch isOn]) {
        [appDelegate changeAutoReportQueue:YES];
        NSLog(@"Auto Report Queue option is now on.");
    }
    else {
        [appDelegate changeAutoReportQueue:NO];
        NSLog(@"Auto Report Queue option is now off.");
    }
}

- (IBAction)removeOldestQueuedItemsSwitched:(id)sender {
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    if ([self.removeOldestQueuedItems isOn]) {
        [appDelegate changeRemoveOldItemsWhenFullDB:YES];
    }
    else {
        [appDelegate changeRemoveOldItemsWhenFullDB:NO];
    }
}

@end

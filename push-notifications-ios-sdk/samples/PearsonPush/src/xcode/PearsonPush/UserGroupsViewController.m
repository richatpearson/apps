//
//  UserGroupsViewController.m
//  PearsonPush
//
//  Created by Richard Rosiak on 3/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "UserGroupsViewController.h"
#import "AppDelegate.h"

@interface UserGroupsViewController ()

@property (nonatomic, strong) UITextField* activeField;

@end

@implementation UserGroupsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.pushNotifications onlyAddUserToExistingGroups:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.groupNameField.delegate = self;
    self.userGroupsScrollView.delegate = self;
    self.userGroupsScrollView.contentSize = self.userGroupsScrollView.frame.size;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self registerForKeyboardNotifications];
    [self registerForPearsonGroupNotifications];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [self removeObservers];
    [super viewDidDisappear:animated];
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

- (IBAction)registerUserToGroup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if ([self.autoCreateGroupSwitch isOn]) {
        [appDelegate.pushNotifications onlyAddUserToExistingGroups:NO];
    } else {
        [appDelegate.pushNotifications onlyAddUserToExistingGroups:YES];
    }
    if (![self.groupNameField.text isEqualToString:@""]) {
        
        NSString* groupName = self.groupNameField.text;
        
        [appDelegate addUserToGroup:groupName];
    }
    else {
        [self showAlertWithTitle:@"Missing Group Name"
                         message:@"Can't add user to empty group name."];
    }
}

- (IBAction)unregisterUserFromGroup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if (![self.groupNameField.text isEqualToString:@""]) {
        NSString* groupName = self.groupNameField.text;
        [appDelegate removeUserFromGroup:groupName];
    }
    else {
        [self showAlertWithTitle:@"Missing Group Name"
                         message:@"Can't remove user from empty group name."];
    }
}

-(void)showAlertWithTitle:(NSString*)alertTitle
                  message:(NSString*)alertMessage {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

- (IBAction)changeAutoCreateGroup:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if ([self.autoCreateGroupSwitch isOn]) {
        [appDelegate.pushNotifications onlyAddUserToExistingGroups:NO];
        NSLog(@"Auto create group turned on.");
    }
    else {
        [appDelegate.pushNotifications onlyAddUserToExistingGroups:YES];
        NSLog(@"Auto create group turned off.");
    }
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
    if (textField) {
        [textField resignFirstResponder];
    }
    return NO;
}

- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

- (void) registerForPearsonGroupNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestResponse:)
                                                 name:kPN_AddUserToGroupRequest
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(requestResponse:)
                                                 name:kPN_RemoveUserFromGroupRequest
                                               object:nil];
}

- (void) requestResponse:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[NSError class]])
    {
        NSError* requestError = (NSError*)notification.object;
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate alert:requestError.localizedDescription title:@"Request Error"];
    }
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.userGroupsScrollView.contentInset = contentInsets;
    self.userGroupsScrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.userGroupsScrollView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) )
    {
        float contentHeight = self.userGroupsScrollView.contentSize.height - kbSize.height;
        self.userGroupsScrollView.contentSize = CGSizeMake(self.userGroupsScrollView.contentSize.width, contentHeight);
        [self.userGroupsScrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.userGroupsScrollView.contentInset = contentInsets;
    }];
    
    self.userGroupsScrollView.scrollIndicatorInsets = contentInsets;
    
    [self.userGroupsScrollView setScrollEnabled:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void) removeObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPN_AddUserToGroupRequest
                                                  object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:kPN_RemoveUserFromGroupRequest
                                                  object:nil];
}

@end

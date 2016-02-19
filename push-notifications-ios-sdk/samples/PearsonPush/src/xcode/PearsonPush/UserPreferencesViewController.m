//
//  UserPreferencesViewController.m
//  PearsonPush
//
//  Created by Richard Rosiak on 2/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "UserPreferencesViewController.h"
#import <PushNotifications/PearsonNotificationPreferences.h>
#import "AppDelegate.h"

@interface UserPreferencesViewController ()

@property (nonatomic, strong) NSMutableDictionary *whitelist;
@property (nonatomic, strong) NSMutableDictionary *blacklist;

@end

@implementation UserPreferencesViewController

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
    
    self.preferenceTypeField.delegate = self;
    self.preferenceException1Field.delegate = self;
    self.preferenceException2Field.delegate = self;
    self.preferenceException3Field.delegate = self;
    self.preferencesJsonTextView.delegate = self;
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.scrollView.frame.size;
    
    self.preferencesJsonTextView.allowsEditingTextAttributes = NO;
    
    [self registerForKeyboardNotifications];
    [self.scrollView setScrollEnabled:YES];
    
    self.preferencesJsonTextView.text = @"";
}

- (void) viewWillAppear:(BOOL)animated
{
    [self resetPreferenceFields];
    
    [self initProperties];
}

-(void)initProperties
{
    self.whitelist = [NSMutableDictionary new];
    self.blacklist = [NSMutableDictionary new];
    
    PearsonNotificationPreferences *prefs = [self getPreferencesFromDevice];
    NSLog(@"Device prefs are: %@",[prefs getPreferences].description);
    if (prefs.whitelist)
    {
        [self.whitelist addEntriesFromDictionary:prefs.whitelist];
    }
    
    if (prefs.blacklist)
    {
        [self.blacklist addEntriesFromDictionary:prefs.blacklist];
    }
    
    self.preferencesJsonTextView.text = [self getPreferencesAsString];
}

-(PearsonNotificationPreferences *)getPreferencesFromDevice
{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [appDelegate.pushNotifications notificationPreferences];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
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

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.scrollView.frame;
    aRect.size.height -= kbSize.height;
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) )
    {
        float contentHeight = self.scrollView.contentSize.height - kbSize.height;
        self.scrollView.contentSize = CGSizeMake(self.scrollView.contentSize.width, contentHeight);
        [self.scrollView scrollRectToVisible:self.activeField.frame animated:YES];
    }
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    
    [UIView animateWithDuration:0.4 animations:^{
        self.scrollView.contentInset = contentInsets;
    }];
    
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
    [self.scrollView setScrollEnabled:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (IBAction)addPreferences:(id)sender
{
    NSString* preferenceTypeText = self.preferenceTypeField.text;
    NSLog(@"preferenceTypeText :%@", preferenceTypeText);
    
    if (![preferenceTypeText isEqualToString:@""])
    {
        NSMutableArray* exceptions = [self gatherExceptions];
        if (self.segmentedControl.selectedSegmentIndex == 0)
        {
            NSLog(@"WHITELIST PreferencesTestText: %@", preferenceTypeText);
            [self.whitelist setObject:exceptions forKey:preferenceTypeText];
        }
        else if (self.segmentedControl.selectedSegmentIndex == 1)
        {
            NSLog(@"BLACKLIST PreferencesTestText: %@", preferenceTypeText);
            [self.blacklist setObject:exceptions forKey:preferenceTypeText];
        }
    }
    NSLog(@"AllDone with gathering preferences");
    self.preferencesJsonTextView.text = [self getPreferencesAsString];

    [self resetPreferenceFields];
}

- (NSMutableArray*) gatherExceptions
{
    NSMutableArray* exceptions = [@[] mutableCopy];
    
    if (![self.preferenceException1Field.text isEqualToString:@""])
    {
        NSLog(@"Exception1: %@, count %lu", self.preferenceException1Field.text, (unsigned long)[exceptions count]);
        [exceptions addObject:self.preferenceException1Field.text];
    }
    if (![self.preferenceException2Field.text isEqualToString:@""])
    {
        NSLog(@"Exception2: %@, count %lu", self.preferenceException2Field.text, (unsigned long)[exceptions count]);
        [exceptions addObject:self.preferenceException2Field.text];
    }
    if (![self.preferenceException3Field.text isEqualToString:@""])
    {
        NSLog(@"Exception3: %@, count %lu", self.preferenceException3Field.text, (unsigned long)[exceptions count]);
        [exceptions addObject:self.preferenceException3Field.text];
    }
    
    return exceptions;
}

- (NSString*) getPreferencesAsString
{
    NSString *jsonString = @"";
    
    NSMutableDictionary *prefDict = [NSMutableDictionary dictionary];
    
    if (self.whitelist)
    {
        [prefDict setObject:self.whitelist forKey:@"whitelist"];
    }
    if (self.blacklist)
    {
        [prefDict setObject:self.blacklist forKey:@"blacklist"];
    }
    
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:prefDict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    if (! jsonData)
    {
        jsonString = @"ERROR WITH JSON FORMATTING";
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    
    return jsonString;
}

- (void) resetPreferenceFields
{
    self.preferenceTypeField.text = @"";
    self.preferenceException1Field.text = @"";
    self.preferenceException2Field.text = @"";
    self.preferenceException3Field.text = @"";
}

- (NSString *)jsonDictionaryToString:(NSDictionary *)json {
    NSError *error;
    NSData *jsonStringData = [NSJSONSerialization dataWithJSONObject:json
                                                             options:NSJSONWritingPrettyPrinted error:&error];
    
    NSLog(@"Adding pref JSON: %@", [[NSString alloc] initWithData:jsonStringData encoding:NSUTF8StringEncoding]);
    
    return [[NSString alloc] initWithData:jsonStringData encoding:NSUTF8StringEncoding];
}

- (IBAction)savePreferences:(id)sender {
    PearsonNotificationPreferences *prefs = [PearsonNotificationPreferences new];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    prefs.whitelist = self.whitelist;
    prefs.blacklist = self.blacklist;
    
    NSLog(@"Whitelist in PearsonNotificationPreferences is %@", prefs.whitelist.description);
    
    [appDelegate.pushNotifications saveNotificationPreferences:prefs withAuthToken:appDelegate.currentAuthToken];
}

- (IBAction)resetPreferences:(id)sender
{
    [self resetPreferenceFields];
    self.preferencesJsonTextView.text = @"";
    
    [self.whitelist removeAllObjects];
    [self.blacklist removeAllObjects];
    
}
@end

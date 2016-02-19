//
//  ActivityStreamViewController.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "ActivityStreamViewController.h"
#import "AssetByScreenHeight.h"
#import "JSONViewController.h"
#import "AppDelegate.h"
#import <Seer-ios-client/SeerUtility.h>

@interface ActivityStreamViewController ()

@end

@implementation ActivityStreamViewController

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
	self.backgroundImageView.image = [UIImage imageNamed:ASSET_BY_SCREEN_HEIGHT(@"Background")];
    
    self.verbField.delegate = self;
    self.objectField.delegate = self;
    self.targetField.delegate = self;
    
    self.scrollView.delegate = self;
    self.scrollView.contentSize = self.scrollView.frame.size;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.actorIdLabel.text = [NSString stringWithFormat:@"Actor: %@", appDelegate.actorName];
    
    [self registerForKeyboardNotifications];
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
     
    //self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if([segue.identifier isEqualToString:@"showJSONViewSegue"])
    {
        JSONViewController *controller = (JSONViewController *)segue.destinationViewController;
        controller.json = [self createActivityStreamJsonWithActorName: appDelegate.actorName
                                                                 verb: self.verbField.text
                                                               object: self.objectField.text
                                                               target: self.targetField.text];
    }
}

- (NSDictionary *)createActivityStreamJsonWithActorName:(NSString *)actorName
                                                   verb:(NSString *)verb
                                                 object:(NSString *)object
                                                 target:(NSString *)target
{
    NSString *objectId = @"";
    NSString *targetId = @"";
    
    if(object)
    {
        objectId = [NSString stringWithFormat: @"tag:pearson.com,2014:%@", object];
    }
    if(targetId)
    {
        targetId = [NSString stringWithFormat: @"tag:pearson.com,2014:%@", target];
    }
    
    NSDictionary *json = @{
                              @"actor" : @{
                                      @"id" : actorName
                                      },
                              @"verb": verb,
                              @"object": @{
                                      @"id" : objectId,
                                      @"objectType" : object,
                                      },
                              @"target": @{
                                      @"id" : targetId
                                      },
                              @"generator" : @{
                                      @"appId" : @"seer_ios_client_app",
                                      },
                              @"published" : [SeerUtility iso8601StringFromDate:[NSDate date]],
                              };
    NSLog(@"json dictionary is %@", [json description]);
    
    return json;
}


- (IBAction)postToSeer:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    NSDictionary* dataDict = [self createActivityStreamJsonWithActorName: appDelegate.actorName
                                                                    verb: self.verbField.text
                                                                  object: self.objectField.text
                                                                  target: self.targetField.text];
    
    [appDelegate reportDataDictionary:dataDict
                          requestType:kSEER_ActivityStreamReport];
    
    [self clearTextFields];
}

- (IBAction)queueActivityStream:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSDictionary* dataDict = [self createActivityStreamJsonWithActorName: appDelegate.actorName
                                                                    verb: self.verbField.text
                                                                  object: self.objectField.text
                                                                  target: self.targetField.text];
    
    [appDelegate queueDataDictionary:dataDict
                         requestType:kSEER_ActivityStreamReport];
    
    NSLog(@"SeerClientApp queueActivityStream");
    [self clearTextFields];
}

- (void) clearTextFields
{
    self.verbField.text = @"";
    self.objectField.text = @"";
    self.targetField.text = @"";
}

@end

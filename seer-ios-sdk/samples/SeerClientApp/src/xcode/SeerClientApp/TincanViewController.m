//
//  TincanViewController.m
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import "TincanViewController.h"
#import "AssetByScreenHeight.h"
#import "AppDelegate.h"
#import <Seer-ios-client/SeerUtility.h>
#import "JSONViewController.h"

@interface TincanViewController ()

@end

@implementation TincanViewController

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
    
    self.minField.delegate = self;
    self.maxField.delegate = self;
    self.rawField.delegate = self;
    self.scaledField.delegate = self;
    
    self.scrollView.delegate = self;
    
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    self.actorNameLabel.text = [NSString stringWithFormat:@"Actor: %@", appDelegate.actorName];
}

- (NSDictionary*) buildJSONDictionary
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    NSString* mbox = @"";
    NSString* fullName = @"";
    NSString* verbId = @"";
    NSString* objectId = @"";
    NSString* objectDesc = @"";
    
    if(![appDelegate.actorName isEqualToString:@""])
    {
        NSRange mailToRange = [appDelegate.actorName rangeOfString:@"mailTo:"];
        if (mailToRange.location == NSNotFound)
        {
            mbox = @"mailto:";
        }
        NSRange range = [appDelegate.actorName rangeOfString:@"@"];
        if (range.location == NSNotFound)
        {
            mbox = [NSString stringWithFormat:@"%@%@@pearson.com", mbox, [appDelegate.actorName lowercaseString]];
        }
        else
        {
            mbox = [NSString stringWithFormat:@"%@%@", mbox, [appDelegate.actorName lowercaseString]];
        }
        fullName = appDelegate.actorName;
    }
    if(! [self.verbField.text isEqualToString:@""])
    {
        verbId = [NSString stringWithFormat:@"http://pearson.com/%@", self.verbField.text ];
    }
    if(! [self.objectField.text isEqualToString:@""])
    {
        objectId = [NSString stringWithFormat:@"http://pearson.com/seeriosclienttest/%@/%@", self.objectField.text, [SeerUtility uniqueId]];
        objectDesc = self.objectField.text;
    }
    
    NSMutableDictionary *statement = [@{
                                @"id" : [SeerUtility uniqueId],
                                @"actor" : @{
                                        @"mbox" : mbox,
                                        @"name" : fullName,
                                        @"objectType" : @"Agent"
                                        },
                                @"verb": @{
                                        @"id":verbId,
                                        @"display" : @{
                                                @"en-US" : self.verbField.text
                                                }
                                        },
                                @"object" : @{
                                        @"objectType" : @"Activity",
                                        @"id" : objectId,
                                        @"definition" : @{
                                                @"name" : @{ @"en-US" : @"SeeriOSClientTest" },
                                                @"description" : @{ @"en-US" : objectDesc },
                                                @"type" : @"http://pearson.com/seeriosclienttest/"
                                                },
                                        },
                                @"result" : @{
                                        @"completion" : @([self.completedSwitch isOn]),
                                        @"success" : @([self.successSwitch isOn])
                                        },
                                @"context" : @{
                                        @"revision" : @"v1",
                                        @"platform" : @"iOS",
                                        @"language" : @"en-US",
                                        @"extensions" : @{
                                                @"appId" : @"seer_ios_client_app",
                                                }
                                        },
                                @"timestamp" : [SeerUtility iso8601StringFromDate:[NSDate date]]
                                } mutableCopy];
    
	NSMutableDictionary* score = [self buildScore];
    
    if(score)
    {
        NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:[statement objectForKey:@"result"]];
        [result setObject:score forKey:@"score"];
        [statement setObject:result forKey:@"result"];
    }
	return statement;
}

- (NSMutableDictionary*) buildScore
{
    NSMutableDictionary* score = [NSMutableDictionary new];
    BOOL scoreNil = YES;
    
    if(! [self.minField.text isEqualToString:@""])
    {
        [score setObject:self.minField.text forKey:@"min"];
        scoreNil = NO;
    }
    if(! [self.maxField.text isEqualToString:@""])
    {
        [score setObject:self.maxField.text forKey:@"max"];
        scoreNil = NO;
    }
    if(! [self.rawField.text isEqualToString:@""])
    {
        [score setObject:self.rawField.text forKey:@"raw"];
        scoreNil = NO;
    }
    if(! [self.scaledField.text isEqualToString:@""])
    {
        [score setObject:self.scaledField.text forKey:@"scaled"];
        scoreNil = NO;
    }
    if( scoreNil) return nil;

    return score;
}

- (IBAction) postToSeer
{
    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    [appDelegate reportDataDictionary:[self buildJSONDictionary]
                          requestType:kSEER_TincanReport];
}

- (IBAction)queueTincan:(id)sender
{
    AppDelegate* appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    [appDelegate queueDataDictionary:[self buildJSONDictionary]
                         requestType:kSEER_TincanReport];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self registerForKeyboardNotifications];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [self deregisterFromKeyboardNotifications];
    
    [super viewWillDisappear:animated];
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

- (void)deregisterFromKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardDidHideNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)keyboardWasShown:(NSNotification*)aNotification
{
    // Get keyboard size
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    // Set the background rect for the superview (scrollView)
    CGRect bkgndRect = self.activeField.superview.frame;
    bkgndRect.size.height += kbSize.height + self.scrollView.frame.origin.y;
    [self.activeField.superview setFrame:bkgndRect];
    [self.scrollView setContentOffset:CGPointMake(0.0, self.activeField.frame.origin.y-kbSize.height) animated:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
}

// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [UIView animateWithDuration:0.4 animations:^{
        [self.scrollView setContentOffset:CGPointMake(0.0, 0.0) animated:YES];
    }];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.verbField resignFirstResponder];
    [self.objectField resignFirstResponder];
    
    [self.minField resignFirstResponder];
    [self.maxField resignFirstResponder];
    [self.rawField resignFirstResponder];
    [self.scaledField resignFirstResponder];
    
    [self.scrollView resignFirstResponder];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"tincanJSONSegue"])
    {
        JSONViewController *controller = (JSONViewController *)segue.destinationViewController;
        controller.json = [self buildJSONDictionary];
    }
}

@end

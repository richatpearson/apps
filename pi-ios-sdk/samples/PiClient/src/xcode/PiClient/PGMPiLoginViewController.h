//
//  PGMViewController.h
//  PiClient
//
//  Created by Richard Rosiak on 5/29/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockingView.h"
#import "PGMPiConsentViewControllerDelegate.h"

@interface PGMPiLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate, PGMPiConsentViewControllerDelegate>

@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UISwitch *storeCredentialsSwitch;

@property (nonatomic, strong) BlockingView *blockingView;

@property (nonatomic, strong) IBOutlet UIView *resourceView;
@property (nonatomic, strong) IBOutlet UISwitch *affiliationSwitch;
@property (nonatomic, strong) IBOutlet UISwitch *identitySwitch;
@property (nonatomic, strong) IBOutlet UISwitch *userCompositeSwitch;


- (IBAction)loginButton:(id)sender;
- (IBAction)setText:(id)sender;

- (IBAction)chooseAdditonalResources:(id)sender;
- (IBAction)addAdditionalResourceRequests:(id)sender;

- (IBAction)retrieveCredentials:(id)sender;

- (IBAction)forgotPassword:(id)sender;
- (IBAction)forgotUsername:(id)sender;

@end

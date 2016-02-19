//
//  OpeningViewController.h
//  PearsonPush
//
//  Created by Tomack, Barry on 8/15/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpeningViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIImageView* logoImageView;
@property (weak, nonatomic) IBOutlet UITextField* userNameField;
@property (weak, nonatomic) IBOutlet UITextField* passWordField;
@property (weak, nonatomic) IBOutlet UIButton* submitButton;
@property (weak, nonatomic) IBOutlet UISegmentedControl* authProvider;

@property (weak, nonatomic) IBOutlet UILabel* bundleNameLabel;

@property (strong, nonatomic) UIActivityIndicatorView* activityIndicator;
@property (strong, nonatomic) UIView* blockingView;

- (IBAction) submitLogin:(id)sender;

- (IBAction) setUsernameAndPassword:(id)sender;

@end

//
//  UserPreferencesViewController.h
//  PearsonPush
//
//  Created by Richard Rosiak on 2/5/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserPreferencesViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (strong, nonatomic) IBOutlet UITextField *preferenceTypeField;
@property (strong, nonatomic) IBOutlet UITextField *preferenceException1Field;
@property (strong, nonatomic) IBOutlet UITextField *preferenceException2Field;
@property (strong, nonatomic) IBOutlet UITextField *preferenceException3Field;
@property (strong, nonatomic) IBOutlet UIButton *addButton;

@property (nonatomic, strong) UITextField* activeField;

//- (IBAction)switchController:(id)sender;
- (IBAction)addPreferences:(id)sender;

@property (strong, nonatomic) IBOutlet UITextView *preferencesJsonTextView;

@property (strong, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet UIButton *resetButton;

- (IBAction)savePreferences:(id)sender;
- (IBAction)resetPreferences:(id)sender;

- (void)initProperties;

@end

//
//  TincanViewController.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TincanViewController : UIViewController <UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (strong, nonatomic) IBOutlet UILabel *actorNameLabel;

@property (nonatomic, strong) IBOutlet UITextField* verbField;
@property (nonatomic, strong) IBOutlet UITextField* objectField;

@property (nonatomic, strong) IBOutlet UITextField* minField;
@property (nonatomic, strong) IBOutlet UITextField* maxField;
@property (nonatomic, strong) IBOutlet UITextField* rawField;
@property (nonatomic, strong) IBOutlet UITextField* scaledField;

@property (nonatomic, strong) IBOutlet UISwitch* completedSwitch;
@property (nonatomic, strong) IBOutlet UISwitch* successSwitch;

@property (nonatomic, strong) IBOutlet UIButton* postToSeerButton;

@property (nonatomic, strong) UITextField* activeField;

@property (nonatomic, strong) IBOutlet UIScrollView* scrollView;

- (IBAction) postToSeer;
- (IBAction)queueTincan:(id)sender;

@end

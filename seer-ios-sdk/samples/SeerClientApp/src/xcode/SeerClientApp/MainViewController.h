//
//  MainViewController.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/6/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockingView.h"

@interface MainViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, strong) IBOutlet UITextField* actorNameField;
@property (nonatomic, strong) IBOutlet UITextField* batchSizeField;

@property (nonatomic, strong) IBOutlet BlockingView* blockingView;

@property (strong, nonatomic) IBOutlet UISwitch *autoReportSwitch;
- (IBAction)autoReportSwitch:(id)sender;

@property (strong, nonatomic) IBOutlet UISwitch *removeOldestQueuedItems;
@end

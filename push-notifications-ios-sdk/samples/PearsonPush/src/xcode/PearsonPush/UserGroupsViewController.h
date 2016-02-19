//
//  UserGroupsViewController.h
//  PearsonPush
//
//  Created by Richard Rosiak on 3/14/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserGroupsViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UIScrollView *userGroupsScrollView;
@property (strong, nonatomic) IBOutlet UITextField *groupNameField;
@property (strong, nonatomic) IBOutlet UISwitch *autoCreateGroupSwitch;

- (IBAction)registerUserToGroup:(id)sender;
- (IBAction)unregisterUserFromGroup:(id)sender;

- (IBAction)changeAutoCreateGroup:(id)sender;

@end

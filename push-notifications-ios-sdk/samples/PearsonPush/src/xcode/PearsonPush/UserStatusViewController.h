//
//  UserStatusViewController.h
//  PearsonPush
//
//  Created by Tomack, Barry on 10/1/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserStatusViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel* notificationStatus;
@property (weak, nonatomic) IBOutlet UILabel* badgeStatus;
@property (weak, nonatomic) IBOutlet UILabel* soundStatus;
@property (weak, nonatomic) IBOutlet UILabel* alertStatus;
@property (weak, nonatomic) IBOutlet UILabel* newsstandStatus;

@property (weak, nonatomic) IBOutlet UILabel* notificationBaseURL;

@property (weak, nonatomic) IBOutlet UIButton* logoutButton;

@property (weak, nonatomic) id sender;


- (IBAction) logout:(id)sender;

- (void) setSegueSender:(id)sender;

@end

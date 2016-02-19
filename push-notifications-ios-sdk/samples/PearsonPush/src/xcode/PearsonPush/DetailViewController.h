//
//  DetailViewController.h
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PushNotifications/PearsonNotification.h>

@interface DetailViewController : UIViewController <UISplitViewControllerDelegate>

@property (strong, nonatomic) PearsonNotification* notification;

@property (weak, nonatomic) IBOutlet UILabel* soundLabel;
@property (weak, nonatomic) IBOutlet UILabel* badgeLabel;
@property (weak, nonatomic) IBOutlet UITextView* messageTextView;
@property (weak, nonatomic) IBOutlet UILabel *timestampLabel;
@property (weak, nonatomic) IBOutlet UIImageView *appStateImg;
@property (weak, nonatomic) IBOutlet UITextView* customPayloadTextView;

- (void)setNotificationForDetail:(PearsonNotification*)notification;

@end

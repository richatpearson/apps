//
//  ActivityStreamViewController.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ActivityStreamViewController : UIViewController <UIScrollViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (strong, nonatomic) IBOutlet UILabel *actorIdLabel;

@property (strong, nonatomic) IBOutlet UITextField *verbField;
@property (strong, nonatomic) IBOutlet UITextField *objectField;
@property (strong, nonatomic) IBOutlet UITextField *targetField;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) UITextField* activeField;

- (NSDictionary *)createActivityStreamJsonWithActorName:(NSString *)firstName
                                                   verb:(NSString *)verb
                                                 object:(NSString *)object
                                                 target:(NSString *)target;

- (IBAction)postToSeer:(id)sender;

- (IBAction)queueActivityStream:(id)sender;

@end

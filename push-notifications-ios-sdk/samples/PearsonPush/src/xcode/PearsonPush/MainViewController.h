//
//  MainViewController
//  PearsonPush
//
//  Created by Tomack, Barry on 8/13/13.
//  Copyright (c) 2013 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

@interface MainViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *clearAllButton;
@property (weak, nonatomic) IBOutlet UILabel *notificationCount;
@property (weak, nonatomic) IBOutlet UILabel* currentUserLabel;
@property (weak, nonatomic) IBOutlet UITextView* userUUIDLabel;
@property (weak, nonatomic) IBOutlet UITextView* deviceUUIDLabel;
@property (weak, nonatomic) IBOutlet UINavigationItem *checkNotificationTypesButton;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (weak, nonatomic) IBOutlet UIButton *regUnregButton;

- (void) setUI;

@end

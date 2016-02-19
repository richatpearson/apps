//
//  SessionViewController.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/8/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (nonatomic, strong) IBOutlet UIButton* clearSessionButton;

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) IBOutlet UILabel* itemsQueued;
@property (nonatomic, strong) IBOutlet UILabel* sizeOfQueue;

@property (nonatomic, strong) NSArray* sessionArray;

- (IBAction) clearSessionRequests;
- (IBAction) postQueuedItems;

@end

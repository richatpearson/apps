//
//  SessionTableViewCell.h
//  SeerClientApp
//
//  Created by Tomack, Barry on 1/13/14.
//  Copyright (c) 2014 Pearson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SessionTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UILabel* requestTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel* objectTypeLabel;
@property (nonatomic, strong) IBOutlet UILabel* verbLabel;

@property (nonatomic, strong) IBOutlet UILabel* statusLabel;
@property (nonatomic, strong) IBOutlet UILabel* queueLabel;

@end

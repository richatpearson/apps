//
//  PGMPiAuthenticationResultsViewController.h
//  PiClient
//
//  Created by Richard Rosiak on 6/9/14.
//  Copyright (c) 2014 Richard Rosiak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockingView.h"

@interface PGMPiAuthenticationResultsViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *piUserIdLabel;
@property (strong, nonatomic) IBOutlet UILabel *accessTokenLabel;
@property (strong, nonatomic) IBOutlet UILabel *refreshTokenLabel;
@property (strong, nonatomic) IBOutlet UILabel *expiresInLabel;
@property (strong, nonatomic) IBOutlet UILabel *creationIntervalLabel;

@property (nonatomic, strong) BlockingView* blockingView;

- (IBAction)tokenRefresh:(id)sender;
- (IBAction)logout:(id)sender;


@end

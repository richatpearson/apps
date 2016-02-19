//
//  PGMPiConsentViewController.h
//  PiClient
//
//  Created by Richard Rosiak on 6/17/14.
//  Copyright (c) 2014 Richard Rosiak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMPiConsentViewControllerDelegate.h"

@interface PGMPiConsentViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView *consentWebView;
@property (strong, nonatomic) IBOutlet UIButton *consentButton;
@property (strong, nonatomic) IBOutlet UIButton *declineButton;

@property (nonatomic, strong) id<PGMPiConsentViewControllerDelegate> delegate;

- (IBAction)acceptConsentButton:(id)sender;
- (IBAction)declineConsentButton:(id)sender;

@end

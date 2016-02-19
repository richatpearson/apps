//
//  PGMPiMainViewController.h
//  PiClient
//
//  Created by Tomack, Barry on 6/12/14.
//  Copyright (c) 2014 Tomack, Barry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BlockingView.h"

@interface PGMPiMainViewController : UIViewController

@property (nonatomic, strong) BlockingView* blockingView;

- (IBAction)checkToken :(id)sender;

@end
